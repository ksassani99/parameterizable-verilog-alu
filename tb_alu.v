`timescale 1ns/1ps

module tb_alu;
    parameter WIDTH = 8;

    // DUT inputs
    reg [WIDTH-1:0] a;
    reg [WIDTH-1:0] b;
    reg [2:0] op;

    // DUT outputs
    wire [WIDTH-1:0] y;
    wire overflow;
    wire carry;
    wire zero;
    wire negative;

    // instantiate the ALU
    alu #(.WIDTH(WIDTH)) dut (
        .a(a),
        .b(b),
        .op(op),
        .y(y),
        .overflow(overflow),
        .carry(carry),
        .zero(zero),
        .negative(negative)
    );

    integer tests;    // how many test vectors run
    integer errors;   // how many of those failed

    // waveform dump
    initial begin
        $dumpfile("tb_alu.vcd");
        $dumpvars(0, tb_alu);
    end

    // test procedure
    initial begin
        tests = 0;
        errors = 0;

        // default values
        a = {WIDTH{1'b0}};
        b = {WIDTH{1'b0}};
        op = 3'b000;

        #1;
        a = 1;
        b = 2;
        op = 3'b000; // ADD
        #1;

        $display("Smoke test done (WIDTH=%0d). Add self-checking next.", WIDTH);
        $finish;
    end
endmodule