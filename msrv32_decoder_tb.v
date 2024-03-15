module msrv32_decoder_tb;

  // Parameters and signals for the testbench
  reg trap_taken_in;
  reg [4:0] funct7_5_in;
  reg [6:0] opcode_in;
  reg [2:0] funct3_in;
  reg [1:0] iadder_out_1_to_0_in;
  wire [2:0] wb_mux_sel_out, imm_type_out, csr_op_out;
  wire [3:0] alu_opcode_out;
  wire [1:0] load_size_out;
  wire mem_wr_req_out, load_unsigned_out, alu_src_out, iadder_src_out, csr_wr_en_out, rf_wr_en_out, illegal_instr_out, misaligned_load_out, misaligned_store_out;

  // Instantiate the module under test
  msrv32_decoder dut (
    .trap_taken_in(trap_taken_in),
    .funct7_5_in(funct7_5_in),
    .opcode_in(opcode_in),
    .funct3_in(funct3_in),
    .iadder_out_1_to_0_in(iadder_out_1_to_0_in),
    .wb_mux_sel_out(wb_mux_sel_out),
    .imm_type_out(imm_type_out),
    .csr_op_out(csr_op_out),
    .alu_opcode_out(alu_opcode_out),
    .load_size_out(load_size_out),
    .mem_wr_req_out(mem_wr_req_out),
    .load_unsigned_out(load_unsigned_out),
    .alu_src_out(alu_src_out),
    .iadder_src_out(iadder_src_out),
    .csr_wr_en_out(csr_wr_en_out),
    .rf_wr_en_out(rf_wr_en_out),
    .illegal_instr_out(illegal_instr_out),
    .misaligned_load_out(misaligned_load_out),
    .misaligned_store_out(misaligned_store_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    trap_taken_in = 0;
    funct7_5_in = 0;
    opcode_in = 0;
    funct3_in = 0;
    iadder_out_1_to_0_in = 0;

    //Sample test case
    #10 trap_taken_in = 1;
    #10 funct7_5_in = 3'b101;
    #10 opcode_in = 5'b01100;
    #10 funct3_in = 3'b010;
    #10 iadder_out_1_to_0_in = 2'b10;

    // Finish the simulation
    $finish;
  end

  // Monitor the output signals
  always @(posedge illegal_instr_out) begin
    $display("wb_mux_sel_out = %h, imm_type_out = %h, csr_op_out = %h", wb_mux_sel_out, imm_type_out, csr_op_out);
    $display("alu_opcode_out = %h, load_size_out = %h, mem_wr_req_out = %b", alu_opcode_out, load_size_out, mem_wr_req_out);
    $display("load_unsigned_out = %b, alu_src_out = %b, iadder_src_out = %b", load_unsigned_out, alu_src_out, iadder_src_out);
    $display("csr_wr_en_out = %b, rf_wr_en_out = %b, illegal_instr_out = %b", csr_wr_en_out, rf_wr_en_out, illegal_instr_out);
    $display("misaligned_load_out = %b, misaligned_store_out = %b", misaligned_load_out, misaligned_store_out);
  end

endmodule

