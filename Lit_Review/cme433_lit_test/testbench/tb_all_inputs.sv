module tbench_top();

logic signed [7:0] inA, inB;
logic signed [15:0] approx_mult_out, exact_mult_out;

longint approx_out_sum, exact_out_sum, count;
int EMAC;
real mean_EMAC, NMED;

initial begin
    #0;
    approx_out_sum = 0;
    exact_out_sum = 0;
    count = 0;
    for(int a= -128; a<128; a++) begin
        for(int b = -128; b<128; b++) begin
            inA = a;
            inB = b;
            #10;
            $display("int %d", exact_mult_out);
            approx_out_sum += approx_mult_out;
            exact_out_sum +=  exact_mult_out;
            count++;
        end
    end
    $display("Count %d\n", count);
    $display("exact_out_sum: %d\n", exact_out_sum);
    $display("approx_out_sum: %d\n", approx_out_sum);

    // #10;


        $display("NMED Calculation Results for All possible Inputs\n");

    if(approx_out_sum >= exact_out_sum)
        EMAC = approx_out_sum-exact_out_sum;
    else
        EMAC = exact_out_sum - approx_out_sum;
    $display("EMAC %d", EMAC);

    mean_EMAC = $itor(EMAC)/65535;
    $display("Mean_EMAC: %f", mean_EMAC);
    NMED = mean_EMAC/16129*10**12;
    $display("NMED = %f e-6", NMED);
    $finish;
end

// final begin


// end


exact_mult ex_mult(
    .i_a(inA),
    .i_b(inB),
    .o_z(exact_mult_out)
);

approx_log_multiplier_modified approx_mult(
    .A(inA),
    .B(inB),
    .result(approx_mult_out)
);

endmodule: tbench_top