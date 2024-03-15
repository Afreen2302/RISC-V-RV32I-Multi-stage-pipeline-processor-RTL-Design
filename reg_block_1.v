module msrv32_reg_block_1 (pc_mux_in,ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in,pc_out);
input [31:0] pc_mux_in;
input ms_riscv32_mp_clk_in,ms_riscv32_mp_rst_in;
output reg [31:0] pc_out;
parameter BOOT_ADDRESS = 0;
always @(posedge ms_riscv32_mp_clk_in) begin
    if(ms_riscv32_mp_rst_in)
        pc_out <= BOOT_ADDRESS;
    else
        pc_out <= pc_mux_in;
end
endmodule