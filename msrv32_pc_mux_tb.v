module msrv32_pc_mux_tb;

  // Parameters and signals for the testbench
  reg rst_in, branch_taken_in, ahb_ready_in;
  reg [1:0] pc_src_in;
  reg [31:0] epc_in, trap_address_in, pc_in;
  reg [31:1] iaddr_in;
  wire [31:0] pc_plus_4_out;
  wire [31:0] iaddr_out, pc_mux_out;
  wire misaligned_instr_logic_out;

  // Instantiate the module under test
  msrv32_pc_mux dut (
    .rst_in(rst_in),
    .branch_taken_in(branch_taken_in),
    .ahb_ready_in(ahb_ready_in),
    .pc_src_in(pc_src_in),
    .epc_in(epc_in),
    .trap_address_in(trap_address_in),
    .pc_in(pc_in),
    .iaddr_in(iaddr_in),
    .iaddr_out(iaddr_out),
    .pc_plus_4_out(pc_plus_4_out),
    .misaligned_instr_logic_out(misaligned_instr_logic_out),
    .pc_mux_out(pc_mux_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    rst_in = 0;
    branch_taken_in = 0;
    ahb_ready_in = 1;
    pc_src_in = 2'b00; // Test different cases (0, 1, 2, 3)
    epc_in = 32'hAABBCCDD; // Sample values
    trap_address_in = 32'h11223344; // Sample values
    pc_in = 32'h00000000; // Sample values
    iaddr_in = 31'd0; //Sample values

    // Start the test
    #10 rst_in = 1; // Apply reset
    #10 rst_in = 0; // Release reset

    // Test branch_taken_in
    #10 branch_taken_in = 1;
    #10 branch_taken_in = 0;

    // Test different pc_src_in values
    #10 pc_src_in = 2'b01;
    #10 pc_src_in = 2'b10;
    #10 pc_src_in = 2'b11;

    // Test different ahb_ready_in values
    #10 ahb_ready_in = 0;
    #10 ahb_ready_in = 1;

    // Finish the simulation
    $finish;
  end

endmodule

