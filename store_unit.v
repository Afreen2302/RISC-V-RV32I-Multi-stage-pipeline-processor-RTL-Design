module msrv32_store_unit (
    input [1:0] funct3_in,
    input [31:0] iadder_in,
    input [31:0] rs2_in,
    input mem_wr_req_in, ahb_ready_in,

    output reg [31:0] ms_riscv32_mp_dmdata_out,
    output [31:0] ms_riscv32_mp_dmaddr_out,
    output reg [3:0] ms_riscv32_mp_dmwr_mask_out,
    output ms_riscv32_mp_req_out,
    output reg [1:0] ahb_htrans_out
);

reg [31:0] byte_dout, halfword_dout;
reg [3:0] byte_wr_mask, halfword_wr_mask;
reg [31:0] d_addr = 0;
assign ms_riscv32_mp_dmaddr_out = {iadder_in[31:2], 2'b00}; //masking the last 2 bits
assign ms_riscv32_mp_req_out = mem_wr_req_in; 

// 3 cases : word (4 bytes), halfword (2 bytes), byte (1); either come out of the store unit
// Masking for byte: (without assigning to the output)

always @(*) begin
    case (iadder_in[1:0])
        2'b00  : byte_dout = {8'b0, 8'b0, 8'b0, rs2_in[7:0]}; //other bytes are masked to '0'
        2'b01  : byte_dout = {8'b0, 8'b0, rs2_in[15:8], 8'b0};
        2'b10  : byte_dout = {8'b0, rs2_in[23:16], 8'b0, 8'b0};
        2'b11  : byte_dout = {rs2_in[31:24], 8'b0, 8'b0, 8'b0};
        default: byte_dout = 32'd0;
    endcase
end

//Masking for halfword: (without assigning to the output)

always @(*) begin
    case (iadder_in[1])
        1'b0   : halfword_dout  = {16'b0, rs2_in[15:0]}; //other bytes are masked to '0'
        1'b1   : halfword_dout  = {rs2_in[31:16], 16'b0};
        default: halfword_dout  = 32'd0;
    endcase
end

//Transmission based on funct3_in

always @(*) begin
    if(ahb_ready_in) begin
        case (funct3_in)
            2'b00   : ms_riscv32_mp_dmdata_out  = byte_dout; //other bytes are masked to '0'
            2'b01   : ms_riscv32_mp_dmdata_out  = halfword_dout;
            default: ms_riscv32_mp_dmdata_out   = rs2_in;
        endcase
        ahb_htrans_out = 2'b10; //it is a functionality: where after transferring data to the memory, ahb_trans_out should indicate 2'b10 value, if not transferred then 2'b00
    end
    else
        ahb_htrans_out = 2'b00;
end

//Mask output

always @(*) begin
    case (funct3_in)
        2'b00   : ms_riscv32_mp_dmwr_mask_out  = byte_wr_mask; //other bytes are masked to '0'
        2'b01   : ms_riscv32_mp_dmwr_mask_out  = halfword_wr_mask;
        default: ms_riscv32_mp_dmwr_mask_out   = {4{mem_wr_req_in}};
    endcase
end

//Mask depends on iaddr_in (a-byte mask, b-halfword mask)
//a

always @(*) begin
    case (iadder_in[1:0])
        2'b00  : byte_wr_mask = {3'b0, mem_wr_req_in}; //other bytes are masked to '0'
        2'b01  : byte_wr_mask = {2'b0, mem_wr_req_in, 1'b0}; //mem_wr_req_in --> connected to the memory in which data need to write
        2'b10  : byte_wr_mask = {1'b0, mem_wr_req_in, 2'b0};
        2'b11  : byte_wr_mask = {mem_wr_req_in, 3'b0};
        default: byte_wr_mask = {4{mem_wr_req_in}};
    endcase
end

//b
always @(*) begin
    case (iadder_in[1])
        1'b0   : halfword_wr_mask  = {2'b0, {2{mem_wr_req_in}}}; //other bytes are masked to '0'
        1'b1   : halfword_wr_mask  = {{2{mem_wr_req_in}}, 2'b0};
        default: halfword_wr_mask  = {4{mem_wr_req_in}};
    endcase
end

endmodule
