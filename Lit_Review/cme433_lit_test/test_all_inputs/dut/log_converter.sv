`include "parameters.sv"

module log_converter (
    input  bit [2:0]    k,
    input  bit [`T-1:0] x_t,
    output bit [`T+2:0] log_value
    );

    assign log_value = {k, x_t};

endmodule
