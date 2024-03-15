module msrv32_alu_tb;

  // Parameters and signals for the testbench
  reg [31:0] op_1_in;
  reg [31:0] op_2_in;
  reg [3:0] opcode_in;
  wire [31:0] result_out;

  // Instantiate the module under test
  msrv32_alu dut (
    .op_1_in(op_1_in),
    .op_2_in(op_2_in),
    .opcode_in(opcode_in),
    .result_out(result_out)
  );

  // Initialize the signals
  initial begin
    // Test input values
    op_1_in = 32'hAABBCCDD;
    op_2_in = 32'h00112233;
    opcode_in = 4'b0000; // Add

    // Monitor the output signals
    $display("op_1_in = %h, op_2_in = %h", op_1_in, op_2_in);
    $display("opcode_in = %b", opcode_in);
    $monitor("result_out = %h", result_out);

    // Run the test cases
    #1 opcode_in = 4'b1000; // Subtract
    #1 opcode_in = 4'b0010; // Signed comparison
    #1 opcode_in = 4'b0011; // Unsigned comparison
    #1 opcode_in = 4'b0111; // Bitwise AND
    #1 opcode_in = 4'b0110; // Bitwise OR
    #1 opcode_in = 4'b0100; // Bitwise XOR
    #1 opcode_in = 4'b0001; // Left shift
    #1 opcode_in = 4'b0101; // Right shift
    #1 opcode_in = 4'b1101; // Arithmetic right shift
    #1 opcode_in = 4'b1111; // Unsupported operation

    // Finish the simulation
    $finish;
  end
endmodule

