`include "parameters.sv"

module dynamic_truncation(
    input  bit [7:0]    x,
    output bit [`T-1:0] x_t,
    output bit flag,
    output bit [2:0] t
);

    assign flag = ^x[1:0];
    assign t = x[2:0];
    assign x_t = x[7-:`T];
endmodule
