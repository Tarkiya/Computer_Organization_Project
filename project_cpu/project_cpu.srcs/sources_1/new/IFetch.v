module IFetch(
    input clk,
    input rst,
    input [31:0] imm32,
    input zero,
    input Ecall,
    input Branch,nBranch,Blt,Bge,Bltu,Bgeu,
    output [31:0] inst
    );
    reg [31:0] pc;
    wire Bran;
    assign Bran = Branch || nBranch || Blt || Bge || Bltu || Bgeu;
    always @(negedge clk) begin
        if(~rst) pc <= 32'h00000000;
        else begin
            if(Ecall == 1'b1) begin
                pc <= pc;
            end
            else if(Bran == 1'b1 && zero == 1'b1) begin
                pc <= pc + imm32;
            end
            else pc <= pc + 4;
        end
    end
    inst_memory uinst(
        .clka(clk),
        .addra(pc>>2),
        .douta(inst)
    );
endmodule
