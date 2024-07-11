module adder(
    input  bit [10:0] op1, op2,
    output bit [11:0] sum
    );
    
    assign sum = op1 + op2;

endmodule
