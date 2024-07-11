module testbench( 
    input F_davio, F_conv,
    output  reg [6:0] D

);

int counter, limit;

initial begin
    D = 7'b0;
    counter = 0;
    limit = 10;
    #10;
    
    while(counter < limit) begin
        #10;
        if (F_davio != F_conv)
            $display("Error! Parity Davio and Parity Conventional did not match, F_davio = %b   F_conv =  %b", F_davio, F_conv);
    
        $display("D = %6b  F_parity = %b  F_conv = %b", D, F_davio, F_conv);
        D = $random();
        counter ++;
    end
    $display("Test complete");
    $finish;
end



endmodule
