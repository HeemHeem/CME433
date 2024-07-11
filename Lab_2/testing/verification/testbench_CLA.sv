`timescale 1us/1ns

module testbench_CLA();

reg  clk;
wire Cout, G, P;
reg [31:0] a, b;
reg cin; 
wire [31:0] sum; 

// test logic
reg Cout_test, G_test, P_test, prev_p;
reg [31:0] temp_P, temp_G;
reg [32:0] sum_inter;
reg [31:0] sum_test;
reg [31:0] prev_a, prev_b;
reg prev_cin;
// initial #640 $stop;

initial clk = 1'b1;
always #0.5 clk = ~clk;

initial begin
    cin <= 0;
    a <= 0;
    b <= 0;
    repeat (100)begin
    repeat(3)
    begin
        // repeat(3) @(posedge clk)
        @(posedge clk)
        cin <= $urandom;
        a <= $urandom;
        b <= $urandom;
        // repeat(3) @(posedge clk)
        // cin <= 0;
        // a <= ~0;
        // b <= 0;
    end
    repeat(3) begin
        @(posedge clk)
        cin <= 0;
        a <=  ~0;
        b <= 0;
    end
    end

    $finish;


end



always @ (posedge clk)
    begin
        prev_a <= a;
        prev_b <= b;
        prev_cin <= cin;
    end


always @ (posedge clk)
    sum_inter <= a + b;

always @ (posedge clk)
    sum_test <= prev_a + prev_b;//sum_inter[31:0];
// always @ (posedge clk)
//     sum_test = sum_inter[31:0];

always @ (posedge clk)
    Cout_test = sum_inter[32];




always @ (posedge clk)
    begin
        temp_P = prev_a | prev_b;
        P_test = &(temp_P);
        temp_G = prev_a & prev_b;
        G_test = temp_G[31];
        prev_p = temp_P[31];
        for(int i = 30;i >= 0; i--)
        begin
            G_test |= prev_p & (temp_G[i]);
            prev_p &= temp_P[i];
        end
    end


CLA_Adder_32bit test(
    .clk(clk),
    .cin(cin),
    .a(a),
    .b(b),
    .G(G),
    .P(P),
    .Cout(Cout),
    .sum(sum)
);


endmodule
