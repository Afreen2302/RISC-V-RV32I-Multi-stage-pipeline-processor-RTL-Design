module msrv32_immediate_adder(pc_in,rs_1_in,iadder_src_in,,imm_in,iadder_out);
input iadder_src_in;
input [31:0] pc_in,rs_1_in,imm_in;
output reg [31:0] iadder_out;
always @(*) begin
    case(iadder_src_in)
        1'b0 : iadder_out = pc_in + imm_in;
        1'b1 : iadder_out = rs_1_in + imm_in;
    endcase
end
endmodule