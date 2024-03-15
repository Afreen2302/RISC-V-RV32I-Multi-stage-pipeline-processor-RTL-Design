module msrv32_branch_unit_tb;

  // Parameters and signals for the testbench
  reg [31:0] rs1_in, rs2_in;
  reg [6:2] opcode_6_to_2_in;
  reg [2:0] funct3_in;
  wire branch_taken_out;

  // Instantiate the module under test
  msrv32_branch_unit dut (
    .rs1_in(rs1_in),
    .rs2_in(rs2_in),
    .opcode_6_to_2_in(opcode_6_to_2_in),
    .funct3_in(funct3_in),
    .branch_taken_out(branch_taken_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    rs1_in = 32'h12345678; // Sample values
    rs2_in = 32'hAABBCCDD;
    opcode_6_to_2_in = 5'b11011; // OPCODE_JAL
    funct3_in = 3'b100; 

    // Test case 1: OPCODE_JAL
    // The branch should be taken (branch_taken_out = 1)
    #10 opcode_6_to_2_in = 5'b11011;

    // Test case 2: OPCODE_JALR
    // The branch should be taken (branch_taken_out = 1)
    #10 opcode_6_to_2_in = 5'b11001;

    // Test case 3: OPCODE_BRANCH (B-type instruction)
    // The branch should be taken (branch_taken_out = 1)
    #10 opcode_6_to_2_in = 5'b00111;
    #10 funct3_in = 3'b100;

    // Test case 4: OPCODE_BRANCH (B-type instruction)
    // The branch should not be taken (branch_taken_out = 0)
    #10 opcode_6_to_2_in = 5'b00111;
    #10 funct3_in = 3'b110;

    // Test case (5, 6, 7, 8)
    #10 opcode_6_to_2_in = 5'b00111;
    #10 funct3_in = 3'b000;

    #10 opcode_6_to_2_in = 5'b00111;
    #10 funct3_in = 3'b001;

    #10 opcode_6_to_2_in = 5'b00111;
    #10 funct3_in = 3'b101;

    #10 opcode_6_to_2_in = 5'b00111;
    #10 funct3_in = 3'b111;
    #10
    // Finish the simulation
    $finish;
  end

  // Monitor the branch_taken_out signal
  always @(posedge branch_taken_out) begin
    $display("branch_taken_out = %b", branch_taken_out);
  end

endmodule

