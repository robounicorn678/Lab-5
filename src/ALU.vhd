--+----------------------------------------------------------------------------
--|
--| NAMING CONVENSIONS :
--|
--|    xb_<port name>           = off-chip bidirectional port ( _pads file )
--|    xi_<port name>           = off-chip input port         ( _pads file )
--|    xo_<port name>           = off-chip output port        ( _pads file )
--|    b_<port name>            = on-chip bidirectional port
--|    i_<port name>            = on-chip input port
--|    o_<port name>            = on-chip output port
--|    c_<signal name>          = combinatorial signal
--|    f_<signal name>          = synchronous signal
--|    ff_<signal name>         = pipeline stage (ff_, fff_, etc.)
--|    <signal name>_n          = active low signal
--|    w_<signal name>          = top level wiring signal
--|    g_<generic name>         = generic
--|    k_<constant name>        = constant
--|    v_<variable name>        = variable
--|    sm_<state machine type>  = state machine type definition
--|    s_<signal name>          = state name
--|
--+----------------------------------------------------------------------------
--|
--| ALU OPCODES:
--|
--|     ADD     000
--|     SUB     001
--|     AND     011
--|     OR      010
--|     LSHIFT  11X
--|     RSHIFT  10X
--|
--+----------------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;



entity ALU is
    Port(
        i_A      : in  STD_LOGIC_VECTOR (7 downto 0);
        i_B      : in  STD_LOGIC_VECTOR (7 downto 0);
        i_op     : in  STD_LOGIC_VECTOR;             -- unconstrained
        o_result : out STD_LOGIC_VECTOR (7 downto 0);
        o_flags  : out STD_LOGIC_VECTOR (3 downto 0)
    );
end ALU;

architecture behavioral of ALU is 
    -- widen your intermediates to 9 bits
    signal w_9bit_A      : STD_LOGIC_VECTOR(8 downto 0);
    signal w_9bit_B      : STD_LOGIC_VECTOR(8 downto 0);
    signal w_add_res     : STD_LOGIC_VECTOR(8 downto 0);
    signal w_andor_res   : STD_LOGIC_VECTOR(8 downto 0);
    signal w_Lshift_res  : STD_LOGIC_VECTOR(8 downto 0);
    signal w_Rshift_res  : STD_LOGIC_VECTOR(8 downto 0);
    signal w_final_res   : STD_LOGIC_VECTOR(8 downto 0);
    signal s_A, s_B, s_RES : signed(7 downto 0);
    signal op3           : STD_LOGIC_VECTOR(2 downto 0);  -- <== low-3 bits

begin
    --------------------------------------------------------------------
    -- 1) Build 9-bit versions of A and B
    w_9bit_A <= '0' & i_A;
    w_9bit_B <= '0' & i_B;

    -- 2) Slice off exactly the bottom 3 bits of whatever-width i_op:
    op3 <= i_op(i_op'high downto i_op'high-2);

    --------------------------------------------------------------------
    -- 3) All of your operation assignments now compare op3 instead of i_op

    w_add_res <= std_logic_vector(unsigned(w_9bit_A) + unsigned(w_9bit_B))  when op3 = "000" else
                 std_logic_vector(unsigned(w_9bit_A) - unsigned(w_9bit_B))  when op3 = "001" else
                 (others => '0');

    w_andor_res <= w_9bit_A and w_9bit_B when op3 = "010" else  -- AND on "010"
                   w_9bit_A or  w_9bit_B when op3 = "011" else  -- OR  on "011"
                   (others => '0');
                
    w_Lshift_res <= std_logic_vector(shift_left(unsigned(w_9bit_A),
                               to_integer(unsigned(w_9bit_B(2 downto 0))))) when op3 = "110" else
                    std_logic_vector(shift_left(unsigned(w_9bit_A),
                                to_integer(unsigned(w_9bit_B(2 downto 0))))) when op3 = "111" else
                    (others => '0');

    w_Rshift_res <= std_logic_vector(shift_right(unsigned(w_9bit_A),
                                to_integer(unsigned(w_9bit_B(2 downto 0))))) when op3 = "100" else
                    std_logic_vector(shift_right(unsigned(w_9bit_A),
                                to_integer(unsigned(w_9bit_B(2 downto 0))))) when op3 = "101" else
                    (others => '0');

    --------------------------------------------------------------------
    -- 4) Select which result to use
    w_final_res <= w_add_res    when op3 = "000" else
                   w_add_res    when op3 = "001" else
                   w_andor_res  when op3 = "010" else  
                   w_andor_res  when op3 = "011" else 
                   w_Rshift_res when op3 = "100" else
                   w_Rshift_res when op3 = "101" else
                   w_Lshift_res when op3 = "110" else
                   w_Lshift_res when op3 = "111" else
                   (others => '0');

    --------------------------------------------------------------------
    -- 5) Flags
    s_A   <= signed(i_A);

    s_B   <= signed(i_B);

    s_RES <= signed(w_final_res(7 downto 0));
 
 
    o_flags(0) <= '1' when ((op3 = "000" and s_A(7) = s_B(7) and s_RES(7) /= s_A(7)) or  -- ADD overflow
                        (op3 = "001" and s_A(7) /= s_B(7) and s_RES(7) /= s_A(7)))  -- SUB overflow
              else '0'; 
    o_flags(3) <= w_final_res(7);                         -- sign
    o_flags(2) <= '1' when w_final_res(7 downto 0) = "00000000" else '0';
    o_flags(1) <= w_final_res(8) when op3 = "000" else
              '1' when op3 = "001" and unsigned(i_A) >= unsigned(i_B) else
              '0';                        -- carry

    --------------------------------------------------------------------
    -- 6) Final 8-bit result
    o_result   <= w_final_res(7 downto 0);

end behavioral;