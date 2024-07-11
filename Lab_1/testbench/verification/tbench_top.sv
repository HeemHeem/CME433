module tbench_top();

// ALU Wires
wire [6:0] D; // Parity Input
wire F_davio, F_conv;



// instantiate testbench module
testbench testbench(
    .D(D), .F_conv(F_conv), .F_davio(F_davio)
     );

// instantiate dut module
parity_conventional dut_conv(
    .D(D), .F(F_conv)
);

parity_davio dut_davio(
    .D(D), .F(F_davio)
);


    
endmodule