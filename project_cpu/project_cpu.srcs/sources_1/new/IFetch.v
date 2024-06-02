module IFetch(
    input clk,
    input rst,
    input [31:0] imm32,
    input result,
    input Branch,nBranch,Blt,Bge,Bltu,Bgeu,
    output [31:0] inst
    );
    wire Bran;
    //wire [31:0] insto;
    reg [31:0] pc;
    assign Bran = Branch || nBranch || Blt || Bge || Bltu || Bgeu;
    always @(negedge clk) begin
        if(~rst) pc <= 32'h00000000;
        else begin
            if(Bran == 1'b1 && result == 1'b1) begin
                pc <= pc + imm32;
            end
            else begin 
                pc <= pc + 4;
            end
        end
    end
//    always @(posedge clk) begin
//        inst = insto;
//    end
    inst_memory uinst(
        .clka(clk),
        .addra(pc>>2),
        .douta(inst)
    );
endmodule
