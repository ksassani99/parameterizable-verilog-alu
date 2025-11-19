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

    // task (applying one vector)
    task run_test;
        input [WIDTH-1:0] t_a;
        input [WIDTH-1:0] t_b;
        input [2:0] t_op;

        begin
            a = t_a;
            b = t_b;
            op = t_op;

            #1;   // wait for combinational logic to settle

            tests = tests + 1;   // bump test counter

            // display outputs
            $display("Test %0d: a=%0d, b=%0d, op=%b => y=%0d, overflow=%b, carry=%b, zero=%b, negative=%b", 
                    tests, a, b, op, y, overflow, carry, zero, negative);
        end
    endtask

    // test procedure
    initial begin
        tests = 0;
        errors = 0;

        // ADD 1 + 2
        run_test(1, 2, 3'b000);

        // SUB 10 - 3
        run_test(10, 3, 3'b001);

        // AND all ones & 0
        run_test({WIDTH{1'b1}}, 0, 3'b010);

        // OR all ones | 0
        run_test({WIDTH{1'b1}}, 0, 3'b011);

        // XOR: 0xAA ^ 0xFF (truncated to WIDTH)
        run_test('hAA, 'hFF, 3'b100);

        $display("Smoke test complete (WIDTH=%0d): tests=%0d errors=%0d (Add self-checking next)", 
                WIDTH, tests, errors);
        $finish;
    end
endmodule