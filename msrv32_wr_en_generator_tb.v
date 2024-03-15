module msrv32_wr_en_generator_tb;

  // Parameters and signals for the testbench
  reg flush_in, rf_wr_en_reg_in, csr_wr_en_reg_in;
  wire wr_en_integer_file_out, wr_en_csr_file_out;

  // Instantiate the module under test
  msrv32_wr_en_generator dut (
    .flush_in(flush_in),
    .rf_wr_en_reg_in(rf_wr_en_reg_in),
    .csr_wr_en_reg_in(csr_wr_en_reg_in),
    .wr_en_integer_file_out(wr_en_integer_file_out),
    .wr_en_csr_file_out(wr_en_csr_file_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    flush_in = 0;
    rf_wr_en_reg_in = 1;
    csr_wr_en_reg_in = 0;

    // Test case 1: Not in flush mode
    // Both signals should be equal to their respective inputs
    #10 flush_in = 0;
    #10 rf_wr_en_reg_in = 0;
    #10 csr_wr_en_reg_in = 1;
    $display("wr_en_integer_file_out = %b, wr_en_csr_file_out = %b", wr_en_integer_file_out, wr_en_csr_file_out);

    // Test case 2: In flush mode
    // Both signals should be 0
    #10 flush_in = 1;

    // Finish the simulation
    $finish;
  end

  // Monitor the wr_en_integer_file_out and wr_en_csr_file_out signals
  always @(posedge wr_en_integer_file_out) begin
    
  end

endmodule

