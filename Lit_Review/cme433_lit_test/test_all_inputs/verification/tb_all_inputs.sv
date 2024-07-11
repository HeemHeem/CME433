module tbench_top();

logic signed [7:0] inA, inB;
logic signed [15:0] approx_mult_out, exact_mult_out;

longint approx_out_sum, exact_out_sum, count;
longint EMAC;
real mean_EMAC, NMED, dut_err, max_err;

initial begin
    #0;
    EMAC = 0;
    approx_out_sum = 0;
    exact_out_sum = 0;
    count = 0;
    for(int a= -128; a<0; a++) begin
        for(int b = -128; b<0; b++) begin
            inA = a;
            inB = b;
            #50;

            // approx_out_sum += approx_mult_out;
            // exact_out_sum +=  exact_mult_out;
            count++;
            EMAC += approx_mult_out-exact_mult_out;
            // take out emac here?
                // if(approx_out_sum >= exact_out_sum)
                //  EMAC += approx_out_sum-exact_out_sum;
                //     else
                // EMAC += exact_out_sum - approx_out_sum;

            // $display("---------------Calc-----------");
            $display("A = %d", a);
            $display("B = %d", b);

            $display("approx_mult_out %d", approx_mult_out);
            $display("exact_mult_out %d", exact_mult_out);
            
            // $display("exact_out_sum: %d", exact_out_sum);
            // $display("approx_out_sum: %d", approx_out_sum);
            // $display("EMAC Before ADD %d", EMAC);    
            // EMAC = EMAC + approx_mult_out;
            // $display("EMAC After ADD %d", EMAC);
            // EMAC = EMAC - exact_mult_out;
            $display("EMAC %d", EMAC);
            // $display("---------------end Calc-----------");

        end
    // $display("approx_out_sum: %d\n", approx_out_sum);
    end

    for(int a= 0; a<128; a++) begin
        for(int b = 0; b<128; b++) begin
            inA = a;
            inB = b;
            #50;

            // approx_out_sum += approx_mult_out;
            // exact_out_sum +=  exact_mult_out;
            count++;
            EMAC += approx_mult_out-exact_mult_out;
            // take out emac here?
                // if(approx_out_sum >= exact_out_sum)
                //  EMAC += approx_out_sum-exact_out_sum;
                //     else
                // EMAC += exact_out_sum - approx_out_sum;

            // $display("---------------Calc-----------");
            $display("A = %d", a);
            $display("B = %d", b);

            $display("approx_mult_out %d", approx_mult_out);
            $display("exact_mult_out %d", exact_mult_out);
            
            // $display("exact_out_sum: %d", exact_out_sum);
            // $display("approx_out_sum: %d", approx_out_sum);
            // $display("EMAC Before ADD %d", EMAC);    
            // EMAC = EMAC + approx_mult_out;
            // $display("EMAC After ADD %d", EMAC);
            // EMAC = EMAC - exact_mult_out;
            $display("EMAC %d", EMAC);
            // $display("---------------end Calc-----------");

        end
    // $display("approx_out_sum: %d\n", approx_out_sum);
    end
    $display("Count %d\n", count);
    // $display("exact_out_sum: %d\n", exact_out_sum);
    // $display("approx_out_sum: %d\n", approx_out_sum);

    #50;
end

final begin

    $display("NMED Calculation Results for All possible Inputs\n");

    // if(approx_out_sum >= exact_out_sum)
    //     EMAC = approx_out_sum-exact_out_sum;
    // else
    //     EMAC = exact_out_sum - approx_out_sum;
    $display("EMAC %d", EMAC);
    if(EMAC < 0)
        EMAC = EMAC * -1;
    mean_EMAC = $itor(EMAC)/32768;
    $display("Mean_EMAC: %f", mean_EMAC);
    NMED = mean_EMAC/16129;
    $display("NMED = %f", NMED);
    $finish;
end


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


// log_multiplier approx_mult(
//     .A(inA),
//     .B(inB),
//     .result(approx_mult_out)
// );


endmodule: tbench_top
