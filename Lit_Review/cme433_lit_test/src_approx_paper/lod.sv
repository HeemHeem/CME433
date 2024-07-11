module lod(
    input  bit [7:0] data,
    output bit [2:0] k,
    output bit [6:0] x
);
    // pos
    always_comb
        if      (data[7]) k = 3'd7;
        else if (data[6]) k = 3'd6;
        else if (data[5]) k = 3'd5;
        else if (data[4]) k = 3'd4;
        else if (data[3]) k = 3'd3;
        else if (data[2]) k = 3'd2;
        else if (data[1]) k = 3'd1;
        else              k = 3'd0;

    // fraction
    assign x = data << (7-k);
endmodule
