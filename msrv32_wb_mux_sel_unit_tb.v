module msrv32_wb_mux_sel_unit_tb;

  // Parameters and signals for the testbench
  reg alu_src_reg_in;
  reg [2:0] wb_mux_sel_reg_in;
  reg [31:0] alu_result_in, lu_output_in, imm_reg_in, iadder_out_reg_in, csr_data_in, pc_plus_4_reg_in, rs2_reg_in;
  wire alu_2nd_src_mux_out;
  wire [31:0] wb_mux_out;

  // Instantiate the module under test
  msrv32_wb_mux_sel_unit dut (
    .alu_src_reg_in(alu_src_reg_in),
    .wb_mux_sel_reg_in(wb_mux_sel_reg_in),
    .alu_result_in(alu_result_in),
    .lu_output_in(lu_output_in),
    .imm_reg_in(imm_reg_in),
    .iadder_out_reg_in(iadder_out_reg_in),
    .csr_data_in(csr_data_in),
    .pc_plus_4_reg_in(pc_plus_4_reg_in),
    .rs2_reg_in(rs2_reg_in),
    .alu_2nd_src_mux_out(alu_2nd_src_mux_out),
    .wb_mux_out(wb_mux_out)
  );

  // Initialize the signals
  initial begin
    // Test input values
    alu_src_reg_in = 1'b1; 
    wb_mux_sel_reg_in = 3'b000; // ALU result
    alu_result_in = 32'hAABBCCDD;
    lu_output_in = 32'h00112233;
    imm_reg_in = 32'h11223344;
    iadder_out_reg_in = 32'h12345678;
    csr_data_in = 32'h0000ABCD;
    pc_plus_4_reg_in = 32'h99999999;
    rs2_reg_in = 32'h55555555;

    // Monitor the output signals
    $display("alu_src_reg_in = %b", alu_src_reg_in);
    $display("wb_mux_sel_reg_in = %b", wb_mux_sel_reg_in);
    $display("alu_result_in = %h", alu_result_in);
    $display("lu_output_in = %h", lu_output_in);
    $display("imm_reg_in = %h", imm_reg_in);
    $display("iadder_out_reg_in = %h", iadder_out_reg_in);
    $display("csr_data_in = %h", csr_data_in);
    $display("pc_plus_4_reg_in = %h", pc_plus_4_reg_in);
    $display("rs2_reg_in = %h", rs2_reg_in);
    $display("alu_2nd_src_mux_out = %h", alu_2nd_src_mux_out);
    $display("wb_mux_out = %h", wb_mux_out);

    // Run the test cases
    #1 wb_mux_sel_reg_in = 3'b001; // Load Unit output
    $display("wb_mux_out = %h", wb_mux_out);
    #1 wb_mux_sel_reg_in = 3'b010; // Immediate value
    $display("wb_mux_out = %h", wb_mux_out);
    #1 wb_mux_sel_reg_in = 3'b011; // IADDer output
    $display("wb_mux_out = %h", wb_mux_out);
    #1 wb_mux_sel_reg_in = 3'b100; // CSR data
    $display("wb_mux_out = %h", wb_mux_out);
    #1 wb_mux_sel_reg_in = 3'b101; // PC+4 output
    $display("wb_mux_out = %h", wb_mux_out);

    // Finish the simulation
    $finish;
  end
endmodule

