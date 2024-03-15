module msrv32_reg_block_1_tb;

  // Inputs
  reg [31:0] pc_mux_in;
  reg ms_riscv32_mp_clk_in;
  reg ms_riscv32_mp_rst_in;

  // Output
  wire [31:0] pc_out;
  parameter BOOT_ADDRESS = 0;

  // Instantiate the module under test
  msrv32_reg_block_1 uut (
    .pc_mux_in(pc_mux_in),
    .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
    .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
    .pc_out(pc_out)
  );

  // Initial block for testbench stimulus
  initial begin
    // Initialize inputs
    pc_mux_in = 32'h12345678;
    ms_riscv32_mp_clk_in = 0;
    ms_riscv32_mp_rst_in = 0;

    // Apply reset (assert the reset)
    ms_riscv32_mp_rst_in = 1;
    #10; // Wait for a few clock cycles
    ms_riscv32_mp_rst_in = 0;
    #10; // Release the reset

    // Apply clock signal
    ms_riscv32_mp_clk_in = 1;

    // Observe the waveform for pc_out
    #10; // Wait for a few clock cycles
    $display("pc_out = %h", pc_out); // Display pc_out
    ms_riscv32_mp_clk_in = 0;

    // Advance time to observe the result
    #10;

    // Finish the simulation
    $finish;
  end

endmodule
