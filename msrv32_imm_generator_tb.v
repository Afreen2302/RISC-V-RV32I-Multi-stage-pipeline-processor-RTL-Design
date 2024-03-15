module msrv32_imm_generator_tb;

  // Parameters and signals for the testbench
  reg [31:7] instr_in;
  reg [2:0] imm_type_in;
  wire [31:0] imm_out;

  // Instantiate the module under test
  msrv32_imm_generator dut (
    .instr_in(instr_in),
    .imm_type_in(imm_type_in),
    .imm_out(imm_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    instr_in = 32'hAABBCCDD; // Sample instruction value
    imm_type_in = 3'b000;    // Test different imm_type values (0 to 7)

    // Apply different imm_type values
    #10 imm_type_in = 3'b001;
    #10 imm_type_in = 3'b010;
    #10 imm_type_in = 3'b011;
    #10 imm_type_in = 3'b100;
    #10 imm_type_in = 3'b101;
    #10 imm_type_in = 3'b110;
    #10 imm_type_in = 3'b111; // Default case

    // Finish the simulation
    $finish;
  end

  // Monitor the imm_out signal
  always @(posedge imm_out) begin
    $display("imm_out = %h", imm_out);
  end

endmodule

