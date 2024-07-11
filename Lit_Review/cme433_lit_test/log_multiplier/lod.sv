module lod(
    input  bit [7:0] data,
    output bit       zero_flag,
    output bit [2:0] k,
    output bit [7:0] x
    );
    
    assign zero_flag = data == 8'b0;

    // pos
    always @ *
    if          (data[7]) k = 3'd7;
        else if (data[6]) k = 3'd6;
        else if (data[5]) k = 3'd5;
        else if (data[4]) k = 3'd4;
        else if (data[3]) k = 3'd3;
        else if (data[2]) k = 3'd2;
        else if (data[1]) k = 3'd1;
        else              k = 3'd0;

    // fraction
    assign x = {1'b0, data[6:0] << (8 - k - 1)};
endmodule
