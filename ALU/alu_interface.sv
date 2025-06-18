interface alu_if();

    logic [31:0] operand_a;
    logic [31:0] operand_b;
    logic [3:0]  alu_control;
    logic [31:0] result;
    logic        zero_flag;

endinterface
