module msrv32_immediate_adder_tb;

  // Parameters and signals for the testbench
  reg iadder_src_in;
  reg [31:0] pc_in, rs_1_in, imm_in;
  wire [31:0] iadder_out;

  // Instantiate the module under test
  msrv32_immediate_adder dut (
    .iadder_src_in(iadder_src_in),
    .pc_in(pc_in),
    .rs_1_in(rs_1_in),
    .imm_in(imm_in),
    .iadder_out(iadder_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    iadder_src_in = 1'b0; // Select the first case
    pc_in = 32'hAABBCCDD; // Sample values
    rs_1_in = 32'h11223344;
    imm_in = 32'h00000123; // Sample immediate value

    // Test case :
    #10 iadder_src_in = 1'b1; // Select the second case
    #10

    // Finish the simulation
    $finish;
  end

  // Display the iadder_out signal
  always @(posedge iadder_out) begin
    $display("iadder_out = %h", iadder_out);
  end

endmodule

