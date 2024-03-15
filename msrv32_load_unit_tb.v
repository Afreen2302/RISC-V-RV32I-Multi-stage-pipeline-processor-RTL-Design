module msrv32_load_unit_tb;

  // Parameters and signals for the testbench
  reg ahb_resp_in;
  reg [31:0] ms_riscv32_mp_dmdata_in;
  reg [1:0] iadder_out_1_to_0_in;
  reg load_unsigned_in;
  reg [1:0] load_size_in;
  wire [31:0] lu_output_out;

  // Instantiate the module under test
  msrv32_load_unit dut (
    .ahb_resp_in(ahb_resp_in),
    .ms_riscv32_mp_dmdata_in(ms_riscv32_mp_dmdata_in),
    .iadder_out_1_to_0_in(iadder_out_1_to_0_in),
    .load_unsigned_in(load_unsigned_in),
    .load_size_in(load_size_in),
    .lu_output_out(lu_output_out)
  );

  // Initialize the signals
  initial begin
    // Initialize test inputs
    ahb_resp_in = 1'b0; // Active low signal
    ms_riscv32_mp_dmdata_in = 32'hAABBCCDD;
    iadder_out_1_to_0_in = 2'b00; // Byte
    load_unsigned_in = 1'b0; // Signed
    load_size_in = 2'b00; 
    $display("lu_output_out = %h", lu_output_out);
    #10 ahb_resp_in = 1'b0; // Active low signal
    #10 ms_riscv32_mp_dmdata_in = 32'hAABBCCDD;
    #10 iadder_out_1_to_0_in = 2'b01; // Byte
    #10 load_unsigned_in = 1'b1; // Unsigned
    #10 load_size_in = 2'b01; 
    $display("lu_output_out = %h", lu_output_out);
    #10 ahb_resp_in = 1'b0; // Active low signal
    #10 ms_riscv32_mp_dmdata_in = 32'hAABBCCDD;
    #10 iadder_out_1_to_0_in = 2'b10; // Byte
    #10 load_unsigned_in = 1'b0; // Signed
    #10 load_size_in = 2'b10; 
    $display("lu_output_out = %h", lu_output_out);
    #10 ahb_resp_in = 1'b0; // Active low signal
    #10 ms_riscv32_mp_dmdata_in = 32'hAABBCCDD;
    #10 iadder_out_1_to_0_in = 2'b11; // Byte
    #10 load_unsigned_in = 1'b1; // Unsigned
    #10 load_size_in = 2'b11; 
    #10
    // Display the output signals
    $display("lu_output_out = %h", lu_output_out);

    // Finish the simulation
    $finish;
  end
endmodule

