module alu #(
    parameter WIDTH = 8         // parameter for width, default is 8 bits
)(
    input wire [WIDTH-1:0] a,   // input operand a
    input wire [WIDTH-1:0] b,   // input operand b
    input wire [2:0] op,        // operation selector

    output reg [WIDTH-1:0] y,   // output result
    output reg overflow         // overflow flag
);

endmodule