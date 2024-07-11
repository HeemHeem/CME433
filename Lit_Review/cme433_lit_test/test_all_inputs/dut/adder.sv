`include "parameters.sv"

module adder(
    input  bit [`T+2:0] op1, op2,
    input  bit          flag, t,
    output bit [`T+3:0] sum
    );

    assign sum = op1 + op2 + 1'b1;
endmodule
