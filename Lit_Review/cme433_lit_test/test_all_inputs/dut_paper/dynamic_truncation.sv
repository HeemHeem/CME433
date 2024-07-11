`include "parameters.sv"

module dynamic_truncation(
    input  bit [6:0]    x,
    output bit [`T-2:0] x_t
);

    assign x_t = {x[6-:`T-2], 1'b1};
endmodule
