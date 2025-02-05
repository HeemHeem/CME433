`include "parameters.sv"
module dynamic_truncation(
    input  bit [6:0]    x,
    output bit [`T-2:0] x_t
);

    // assign x_t = {x[6-:`T-2], 1'b1};
    assign x_t[(`T-2):1] = x[6-:`T-2];
    assign x_t[0] = |x[8-`T:0];
endmodule
