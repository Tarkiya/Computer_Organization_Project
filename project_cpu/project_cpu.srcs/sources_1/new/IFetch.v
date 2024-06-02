module IFetch(
    input clk,
    input rst,
    input [31:0] imm32,
    input result,
    input Ecall,
    input Branch,nBranch,Blt,Bge,Bltu,Bgeu,
    output reg [31:0] inst
    );
    wire Bran;
    wire [31:0] insto;
    reg [31:0] pc;
    reg [3:0] index=4'b0;
    assign Bran = Branch || nBranch || Blt || Bge || Bltu || Bgeu;
    always @(negedge clk) begin
        if(~rst) pc <= 32'h00000000;
        else begin
            if(Ecall == 1'b1||insto==32'h73&&index!=4'b1111) begin
                pc <= pc;
                index<=index+4'b1;
            end
            else if(Bran == 1'b1 && result == 1'b1) begin
                pc <= pc + imm32;
                index <=4'b0;
            end
            else begin 
                pc <= pc + 4;
                index <=4'b0;
            end
        end
    end
    always @(posedge clk) begin
        inst = insto;
    end
    inst_memory uinst(
        .clka(clk),
        .addra(pc>>2),
        .douta(insto)
    );
endmodule
