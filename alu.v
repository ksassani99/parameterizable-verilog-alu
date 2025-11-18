module alu #(
    parameter WIDTH = 8         // parameter for width, default is 8 bits
)(
    input wire [WIDTH-1:0] a,   // input operand a
    input wire [WIDTH-1:0] b,   // input operand b
    input wire [2:0] op,        // operation selector

    output reg [WIDTH-1:0] y,   // output result
    output reg overflow,        // overflow flag (for signed arithmetic)
    output reg carry,           // carry flag (for unsigned arithmetic)
    output reg zero,            // zero flag
    output reg negative         // negative flag
);

    // operation params (better organization for cases)
    localparam OP_ADD = 3'b000;   // add
    localparam OP_SUB = 3'b001;   // subtract
    localparam OP_AND = 3'b010;   // and
    localparam OP_OR  = 3'b011;   // or
    localparam OP_XOR = 3'b100;   // xor
    localparam OP_SLL = 3'b101;   // bit shift left logical (unsigned)
    localparam OP_SRL = 3'b110;   // bit shift right logical (unsigned)
    localparam OP_SRA = 3'b111;   // bit shift right arithmetic (signed)

    reg [WIDTH:0] temp_result; // temporary result with extra bit for carry

    always @(*) begin       // combinational logic (no clock)
        y = {WIDTH{1'b0}};  // default outputs set to zero
        overflow = 1'b0;
        carry = 1'b0;
        zero = 1'b0;
        negative = 1'b0;
        temp_result = {(WIDTH+1){1'b0}};

        case (op)
            OP_ADD: begin
                temp_result = {1'b0, a} + {1'b0, b};                                   // temporary result with carry
                y = temp_result[WIDTH-1:0];                                            // output result
                carry = temp_result[WIDTH];                                            // carry flag for unsigned
                overflow = (a[WIDTH-1] == b[WIDTH-1]) && (y[WIDTH-1] != a[WIDTH-1]);   // overflow for signed (same sign inputs leading to different sign output, overflow)
            end
            OP_SUB: begin
                temp_result = {1'b0, a} - {1'b0, b};                                   // temporary result with borrow
                y = temp_result[WIDTH-1:0];                                            // output result
                carry = temp_result[WIDTH];                                            // carry flag for unsigned (borrow)
                overflow = (a[WIDTH-1] != b[WIDTH-1]) && (y[WIDTH-1] != a[WIDTH-1]);   // overflow for signed (different sign inputs leading to different sign output, overflow)
            end
            OP_AND: begin
                y = a & b;
            end
            OP_OR: begin
                y = a | b;
            end
            OP_XOR: begin
                y = a ^ b;
            end
        endcase
    end

endmodule