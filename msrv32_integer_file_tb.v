module msrv32_integer_file_tb;

  // Parameters and signals for the testbench
  reg ms_riscv32_mp_clk_in, ms_riscv32_mp_rst_in, wr_en_in;
  reg [4:0] rs_2_addr_in, rd_addr_in, rs_1_addr_in;
  reg [31:0] rd_in;
  wire [31:0] rs_1_out, rs_2_out;

  // Instantiate the module under test
  msrv32_integer_file dut (
    .ms_riscv32_mp_clk_in(ms_riscv32_mp_clk_in),
    .ms_riscv32_mp_rst_in(ms_riscv32_mp_rst_in),
    .rs_2_addr_in(rs_2_addr_in),
    .rd_addr_in(rd_addr_in),
    .wr_en_in(wr_en_in),
    .rd_in(rd_in),
    .rs_1_addr_in(rs_1_addr_in),
    .rs_1_out(rs_1_out),
    .rs_2_out(rs_2_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    ms_riscv32_mp_clk_in = 0;
    ms_riscv32_mp_rst_in = 1;
    wr_en_in = 0;
    rs_2_addr_in = 5'b00000; // Address 0
    rd_addr_in = 5'b00001;   // Address 1
    rs_1_addr_in = 5'b00010; // Address 2
    rd_in = 32'hAABBCCDD;    // Sample data

    // Apply reset
    #10 ms_riscv32_mp_rst_in = 0;
    #10 ms_riscv32_mp_rst_in = 1;

    // Write data to the register file
    #10 wr_en_in = 1;
    #10 rd_addr_in = 5'b00001; // Write to Address 1
    #10 rd_in = 32'h12345678;  // Sample data

    // Read data from the register file
    #10 wr_en_in = 0;
    #10 rs_1_addr_in = 5'b00010; // Read from Address 2
    #10 rs_2_addr_in = 5'b00001; // Read from Address 1

    // Finish the simulation
    $finish;
  end

  // Monitor the rs_1_out and rs_2_out signals
  always @(posedge ms_riscv32_mp_clk_in) begin
    $display("rs_1_out = %h, rs_2_out = %h", rs_1_out, rs_2_out);
  end

endmodule

