module pcmux_tb();
reg rst_in,branch_taken_in,ahb_ready_in;
reg [1:0] pc_src_in;
reg [31:0] epc_in, trap_address_in,pc_in;
reg [31:1] iaddr_in;
wire [31:0]  pc_plus_4_out;
wire [31:0] iaddr_out,pc_mux_out;
wire misaligned_instr_logic_out;
reg [31:1] next_pc;
integer j,k,l,m,n,o;
parameter BOOT_ADDRESS = 32'd0;
//pcmux BOOT (.BOOT_ADDRESS(32'd0));
pcmux DUT (.rst_in(rst_in),.branch_taken_in(branch_taken_in),.ahb_ready_in(ahb_ready_in),.pc_src_in(pc_src_in),.epc_in(epc_in),.trap_address_in(trap_address_in),.pc_in(pc_in),.iaddr_in(iaddr_in),.pc_plus_4_out(pc_plus_4_out),.iaddr_out(iaddr_out),.pc_mux_out(pc_mux_out),.misaligned_instr_logic_out(misaligned_instr_logic_out));
task initialize;
begin
    //{rst_in,
    //branch_taken_in,
    //ahb_ready_in,
    //pc_src_in,
    //epc_in,
    //trap_address_in,
    //pc_in,
    //iaddr_in} = 0;
    rst_in = 0;
    branch_taken_in = 0;
    ahb_ready_in = 1;
    pc_src_in = 2'b00;
    epc_in = 32'h12345678;
    trap_address_in = 32'hABCDEF00;
    pc_in = 32'h80000000;
    iaddr_in = 32'b00000000000000000000000000000010;
end
endtask

task branchtaken_in (input a);
begin
    branch_taken_in = a;
end
endtask

task nextpc (input [31:1] b);
begin
    next_pc = b;
end
endtask

task pcsrc_in (input [1:0] c);
begin
    pc_src_in = c;
end
endtask

task rstin (input d);
begin
    rst_in = d;
end
endtask

task ahbready_in (input e);
begin
    ahb_ready_in = e;
end
endtask

task epcin (input [31:0] f);
begin
    epc_in = f;
end
endtask

task trapadd_in (input [31:0] g);
begin
    trap_address_in = g;
end
endtask

task pcin (input [31:0] h);
begin
    pc_in = h;
end
endtask

task iaddrin (input [31:1] i);
begin
    iaddr_in = i;
end
endtask

initial begin
    initialize;
    #10
    for (j=0;j<2;j=j+1) begin
        branchtaken_in(j);
        for(k=0;k<4;k=k+1) begin
            next_pc = (branch_taken_in) ? ({iaddr_in[31:1],1'b0}):(pc_in+32'h00000004);
            #10;
        end
    end
    for(l=0;l<4;l=l+1) begin
        pcsrc_in(l);
        for(m=0;m<16;m=m+1) begin
            epcin(m);
            #10;
            trapadd_in(m);
            #10;
        end
    end
    for(n=0;n<2;n=n+1) begin
        ahbready_in(n);
    end
end

endmodule
