`timescale 1us/1ns

module testbench_ripple();

reg  clk;
wire Cout;
reg [31:0] A, B;
reg Cin; 
wire [31:0] S; 


reg Cout_test;
reg [32:0] S_inter;
reg [31:0] S_test;
reg [31:0] prev_A, prev_B;
reg prev_Cin;
initial #640 $stop;

initial clk = 1'b1;
always #0.5 clk = ~clk;

initial begin
    Cin <= 0;
    A <= 0;
    B <= 0;
end

always @ (posedge clk)
begin
    Cin <= $urandom();
    A <= $urandom();
    B <= $urandom();
end

ripple_carry_adder test(
    .clk(clk),
    .Cin(Cin),
    .A(A),
    .B(B),
    .S(S),
    .Cout(Cout)
);

always @ (posedge clk)
    begin
        prev_A <= A;
        prev_B <= B;
        prev_Cin <= Cin;
    end


always @ (posedge clk)
    S_inter = prev_A + prev_B;

always @ (posedge clk)
    S_test = S_inter[31:0];

always @ (posedge clk)
    Cout_test = S_inter[32];
endmodule
