module msrv32_pc_mux(rst_in,
            pc_src_in,
            epc_in,
            trap_address_in,
            branch_taken_in,
            iaddr_in,
            ahb_ready_in,
            pc_in,
            iaddr_out,
            pc_plus_4_out,
            misaligned_instr_logic_out,
            pc_mux_out);
input rst_in,branch_taken_in,ahb_ready_in;
input [1:0] pc_src_in;
input [31:0] epc_in, trap_address_in,pc_in;
input [31:0] iaddr_in;
output [31:0]  pc_plus_4_out;
output reg [31:0] iaddr_out,pc_mux_out;
output misaligned_instr_logic_out;
reg [31:1] next_pc;
parameter BOOT_ADDRESS = 32'd0;
assign pc_plus_4_out = pc_in + 32'h00000004;
assign misaligned_instr_logic_out = branch_taken_in & next_pc[1]; 

always @(*) begin
    if(branch_taken_in==1)
        next_pc = {iaddr_in,1'b0};
    else
        next_pc = pc_plus_4_out;
end

always @(*) begin
    case (pc_src_in)
        2'd0: pc_mux_out = BOOT_ADDRESS;
        2'd1: pc_mux_out = epc_in;
        2'd2: pc_mux_out = trap_address_in;
        2'd3: pc_mux_out = next_pc;
    endcase  
end

always @(*) begin
    if(rst_in)
        iaddr_out = BOOT_ADDRESS;
    else if(ahb_ready_in)
        iaddr_out = pc_mux_out;
    else if(ahb_ready_in==0)
        iaddr_out = 0;
end

endmodule