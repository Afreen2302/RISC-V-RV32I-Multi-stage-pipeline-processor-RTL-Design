module msrv32_instruction_mux_tb;

  // Parameters and signals for the testbench
  reg flush_in;
  reg [31:0] ms_riscv32_mp_instr_in;
  wire [6:0] opcode_out, funct7_out;
  wire [2:0] funct3_out;
  wire [4:0] rs1addr_out, rs2addr_out, rdaddr_out;
  wire [11:0] csr_addr_out;
  wire [24:0] instr_out;

  // Instantiate the module under test
  msrv32_instruction_mux dut (
    .flush_in(flush_in),
    .ms_riscv32_mp_instr_in(ms_riscv32_mp_instr_in),
    .opcode_out(opcode_out),
    .funct3_out(funct3_out),
    .funct7_out(funct7_out),
    .rs1addr_out(rs1addr_out),
    .rs2addr_out(rs2addr_out),
    .rdaddr_out(rdaddr_out),
    .csr_addr_out(csr_addr_out),
    .instr_out(instr_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    flush_in = 0;
    ms_riscv32_mp_instr_in = 32'h00123456; // Sample instruction value

    // Test case 1: Not in flush mode
    // Verify the output signals based on the provided instruction
    #10 flush_in = 0;
    $display("opcode_out = %h, funct3_out = %h, funct7_out = %h", opcode_out, funct3_out, funct7_out);
    $display("rs1addr_out = %h, rs2addr_out = %h, rdaddr_out = %h", rs1addr_out, rs2addr_out, rdaddr_out);
    $display("csr_addr_out = %h, instr_out = %h", csr_addr_out, instr_out);
    // Test case 2: In flush mode
    #10 flush_in = 1;

    // Finish the simulation
    $finish;
  end

endmodule

