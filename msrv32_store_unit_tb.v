module msrv32_store_unit_tb;

  // Parameters and signals for the testbench
  reg [1:0] funct3_in;
  reg [31:0] iadder_in, rs2_in;
  reg mem_wr_req_in, ahb_ready_in;
  wire [31:0] ms_riscv32_mp_dmdata_out;
  wire [31:0] ms_riscv32_mp_dmaddr_out;
  wire [3:0] ms_riscv32_mp_dmwr_mask_out;
  wire ms_riscv32_mp_req_out;
  wire [1:0] ahb_htrans_out;

  // Instantiate the module under test
  msrv32_store_unit dut (
    .funct3_in(funct3_in),
    .iadder_in(iadder_in),
    .rs2_in(rs2_in),
    .mem_wr_req_in(mem_wr_req_in),
    .ahb_ready_in(ahb_ready_in),
    .ms_riscv32_mp_dmdata_out(ms_riscv32_mp_dmdata_out),
    .ms_riscv32_mp_dmaddr_out(ms_riscv32_mp_dmaddr_out),
    .ms_riscv32_mp_dmwr_mask_out(ms_riscv32_mp_dmwr_mask_out),
    .ms_riscv32_mp_req_out(ms_riscv32_mp_req_out),
    .ahb_htrans_out(ahb_htrans_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    funct3_in = 2'b00;
    iadder_in = 32'h80000000;
    rs2_in = 32'hAABBCCDD;
    mem_wr_req_in = 1'b1;
    ahb_ready_in = 1'b1;
    #10 funct3_in = 2'b01;
    #10 iadder_in = 32'h80000000;
    #10 rs2_in = 32'hAABBCCDD;
    #10 mem_wr_req_in = 1'b1;
    #10 ahb_ready_in = 1'b1;

    // Display the output signals
    $display("ms_riscv32_mp_dmdata_out = %h, ms_riscv32_mp_dmaddr_out = %h", ms_riscv32_mp_dmdata_out, ms_riscv32_mp_dmaddr_out);
    $display("ms_riscv32_mp_dmwr_mask_out = %h, ms_riscv32_mp_req_out = %b, ahb_htrans_out = %h", ms_riscv32_mp_dmwr_mask_out, ms_riscv32_mp_req_out, ahb_htrans_out);

    // Finish the simulation
    $finish;
  end
endmodule

