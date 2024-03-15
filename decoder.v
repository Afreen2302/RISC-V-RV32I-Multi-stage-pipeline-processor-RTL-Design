module msrv32_decoder (
    input trap_taken_in, funct7_5_in,
    input [6:0] opcode_in,
    input [2:0] funct3_in,
    input [1:0] iadder_out_1_to_0_in,
    output [2:0] wb_mux_sel_out, imm_type_out, csr_op_out,
    output [3:0] alu_opcode_out,
    output [1:0] load_size_out,
    output mem_wr_req_out, load_unsigned_out, alu_src_out, iadder_src_out, csr_wr_en_out, rf_wr_en_out, illegal_instr_out, misaligned_load_out, misaligned_store_out
);

//instruction type opcode
parameter OPCODE_OP = 5'b01100;
parameter OPCODE_OP_IMM = 5'b00100;
parameter OPCODE_LOAD = 5'b00000;
parameter OPCODE_STORE = 5'b01000;
parameter OPCODE_BRANCH = 5'b11000;
parameter OPCODE_JAL = 5'b11011;
parameter OPCODE_JALR = 5'b11001;
parameter OPCODE_LUI = 5'b01101;
parameter OPCODE_AUIPC = 5'b00101;
parameter OPCODE_MISC_MEM = 5'b00011;
parameter OPCODE_SYSTEM = 5'b11100;

//funct3 logical and arithmetic instructions
parameter FUNCT3_ADD = 3'b000;
parameter FUNCT3_SUB = 3'b000;
parameter FUNCT3_SLT = 3'b010;
parameter FUNCT3_SLTU = 3'b011;
parameter FUNCT3_AND = 3'b111;
parameter FUNCT3_OR = 3'b110;
parameter FUNCT3_XOR = 3'b100;
parameter FUNCT3_SLL = 3'b001;
parameter FUNCT3_SRL = 3'b101;
parameter FUNCT3_SRA = 3'b101;

reg is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori, is_load, is_store, is_jalr, is_lui, is_auipc, is_jal, is_op, is_op_imm, is_branch, is_system, is_misc_mem;
wire is_csr, is_implemented_instr, mal_word, mal_half;

always @(*) begin
    case (opcode_in[6:2])
        OPCODE_OP       : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b10000000000;
        OPCODE_OP_IMM   : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b01000000000; 
        OPCODE_LOAD     : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00100000000;
        OPCODE_STORE    : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00010000000;
        OPCODE_BRANCH   : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00001000000;
        OPCODE_JAL      : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000100000;
        OPCODE_JALR     : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000010000;
        OPCODE_LUI      : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000001000;
        OPCODE_AUIPC    : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000100;
        OPCODE_MISC_MEM : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000010;
        OPCODE_SYSTEM   : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000001;
        default         : {is_op, is_op_imm, is_load, is_store, is_branch, is_jal, is_jalr, is_lui, is_auipc, is_misc_mem, is_system} = 11'b00000000000;
    endcase
end

always @(*) begin
    case (funct3_in)
        FUNCT3_ADD      : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0};
        FUNCT3_SLT      : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, is_op_imm, 1'b0, 1'b0, 1'b0, 1'b0};
        FUNCT3_SLTU     : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, is_op_imm, 1'b0, 1'b0, 1'b0};
        FUNCT3_AND      : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, is_op_imm, 1'b0, 1'b0};
        FUNCT3_OR       : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, 1'b0, is_op_imm, 1'b0};
        FUNCT3_XOR      : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, is_op_imm};
        default         : {is_addi, is_slti, is_sltiu, is_andi, is_ori, is_xori} = 6'b000000;
    endcase
end

//output logic for decode
//a
assign alu_opcode_out[2:0] = funct3_in;                                                                                                             //p9
//b
assign alu_opcode_out[3] = funct7_5_in & ~(is_addi | is_slti | is_sltiu | is_andi | is_ori | is_xori);                                              //p10
//c
assign load_size_out = funct3_in[1:0];                                                                                                              //p1
assign load_unsigned_out = funct3_in [2];                                                                                                           //p2
//d
assign alu_src_out = opcode_in[5];                                                                                                                  //p3
//e
assign iadder_src_out = is_load | is_store | is_jalr;                                                                                               //p7
//f
assign csr_wr_en_out = is_csr;                                                                                                                      //p5
//g
assign rf_wr_en_out = is_lui | is_auipc | is_jalr | is_jal | is_op | is_load | is_csr | is_op_imm;                                                  //p8
//h
assign wb_mux_sel_out[0] = is_load | is_auipc | is_jal | is_jalr;                                                                                   //p11
assign wb_mux_sel_out[1] = is_lui | is_auipc;                                                                                                       //p12
assign wb_mux_sel_out[2] = is_csr | is_jal | is_jalr;                                                                                               //p13
//i
assign imm_type_out[0] = is_op_imm | is_load | is_jalr | is_branch | is_jal;                                                                        //p14
assign imm_type_out[1] = is_store | is_branch | is_csr;                                                                                             //p15
assign imm_type_out[2] = is_lui | is_auipc | is_jal | is_csr;                                                                                       //p16
//j 
assign is_implemented_instr = is_op | is_op_imm | is_load | is_store | is_branch | is_jal  | is_jalr | is_lui | is_auipc | is_misc_mem | is_system; //p17
//k
assign csr_op_out = funct3_in;                                                                                                                      //p6
//l
assign misaligned_load_out = (mal_word | mal_half) & is_load;                                                                                       //p21
//m
assign misaligned_store_out = (mal_word | mal_half) & is_store;                                                                                     //p22
//n
assign mem_wr_req_out = is_store && !trap_taken_in && !mal_word && !mal_half;                                                                       //p23

assign illegal_instr_out = ~opcode_in[1] | ~opcode_in[0] | ~is_implemented_instr;                                                                   //p18

//internal wire
assign mal_word = funct3_in[1] & ~funct3_in[0] & (iadder_out_1_to_0_in[1] | iadder_out_1_to_0_in[0]);                                               //p19
assign mal_half = ~funct3_in[1] & funct3_in[0] & iadder_out_1_to_0_in[0];                                                                           //p20
assign is_csr = is_system & (funct3_in[2] | funct3_in[1] | funct3_in[0]);                                                                           //p4

endmodule
