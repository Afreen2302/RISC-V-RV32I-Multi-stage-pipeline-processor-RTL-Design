module msrv32_reg_block_2_tb;

  // Parameters and signals for the testbench
  reg clk_in;
  reg reset_in;
  reg [4:0] rd_addr_in;
  reg [11:0] csr_addr_in;
  reg [31:0] rs1_in, rs2_in, pc_in, pc_plus_4_in, iadder_in, imm_in;
  reg branch_taken_in;
  reg [3:0] alu_opcode_in;
  reg [1:0] load_size_in;
  reg load_unsigned_in;
  reg alu_src_in;
  reg csr_wr_en_in;
  reg rf_wr_en_in;
  reg [2:0] wb_mux_sel_in;
  reg [2:0] csr_op_in;

  wire [4:0] rd_addr_reg_out;
  wire [11:0] csr_addr_reg_out;
  wire [31:0] rs1_reg_out, rs2_reg_out, pc_reg_out, pc_plus_4_reg_out, iadder_out_reg_out, imm_reg_out;
  wire [3:0] alu_opcode_reg_out;
  wire [1:0] load_size_reg_out;
  wire load_unsigned_reg_out;
  wire alu_src_reg_out;
  wire csr_wr_en_reg_out;
  wire rf_wr_en_reg_out;
  wire [2:0] wb_mux_sel_reg_out;
  wire [2:0] csr_op_reg_out;

  // Instantiate the module under test
  msrv32_reg_block_2 dut (
    .clk_in(clk_in),
    .reset_in(reset_in),
    .rd_addr_in(rd_addr_in),
    .csr_addr_in(csr_addr_in),
    .rs1_in(rs1_in),
    .rs2_in(rs2_in),
    .pc_in(pc_in),
    .pc_plus_4_in(pc_plus_4_in),
    .iadder_in(iadder_in),
    .imm_in(imm_in),
    .branch_taken_in(branch_taken_in),
    .alu_opcode_in(alu_opcode_in),
    .load_size_in(load_size_in),
    .load_unsigned_in(load_unsigned_in),
    .alu_src_in(alu_src_in),
    .csr_wr_en_in(csr_wr_en_in),
    .rf_wr_en_in(rf_wr_en_in),
    .wb_mux_sel_in(wb_mux_sel_in),
    .csr_op_in(csr_op_in),
    .rd_addr_reg_out(rd_addr_reg_out),
    .csr_addr_reg_out(csr_addr_reg_out),
    .rs1_reg_out(rs1_reg_out),
    .rs2_reg_out(rs2_reg_out),
    .pc_reg_out(pc_reg_out),
    .pc_plus_4_reg_out(pc_plus_4_reg_out),
    .iadder_out_reg_out(iadder_out_reg_out),
    .imm_reg_out(imm_reg_out),
    .alu_opcode_reg_out(alu_opcode_reg_out),
    .load_size_reg_out(load_size_reg_out),
    .load_unsigned_reg_out(load_unsigned_reg_out),
    .alu_src_reg_out(alu_src_reg_out),
    .csr_wr_en_reg_out(csr_wr_en_reg_out),
    .rf_wr_en_reg_out(rf_wr_en_reg_out),
    .wb_mux_sel_reg_out(wb_mux_sel_reg_out),
    .csr_op_reg_out(csr_op_reg_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    clk_in = 0;
    reset_in = 0;
    rd_addr_in = 0;
    csr_addr_in = 0;
    rs1_in = 32'h12345678;
    rs2_in = 32'hAABBCCDD;
    pc_in = 32'h00001000;
    pc_plus_4_in = 32'h00001004;
    iadder_in = 32'h00001100;
    imm_in = 32'h00000100;
    branch_taken_in = 0;
    alu_opcode_in = 4'b0010;
    load_size_in = 2'b00;
    load_unsigned_in = 1'b0;
    alu_src_in = 1'b0;
    csr_wr_en_in = 1'b0;
    rf_wr_en_in = 1'b0;
    wb_mux_sel_in = 3'b000;
    csr_op_in = 3'b000;

    
    clk_in = 0;
    #5;
    forever begin
        #5 clk_in = ~clk_in;
    end

    // Finish the simulation after a certain number of clock cycles
    #100 $finish;
  end

  // Monitor the output signals
  always @(posedge clk_in) begin
    // Display or check the output signals here
    $display("pc_reg_out = %h, alu_opcode_reg_out = %h, imm_reg_out = %h, rs1_reg_out = %h, rs2_reg_out = %h", pc_reg_out, alu_opcode_reg_out, imm_reg_out, rs1_reg_out, rs2_reg_out);
  end

endmodule
