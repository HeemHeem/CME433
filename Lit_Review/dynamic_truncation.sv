module dynamic_truncation #(N=8, T=4)(
    input bit [N:0] x,
    output bit [N-2:N-T] x_trunc
);

always @ *
    x_trunc <= { x[N-2:N-T-1], 1'b1};


endmodule: dynamic_truncation