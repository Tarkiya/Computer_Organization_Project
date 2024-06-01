module clock_clk (
    input wire clk_in,
    input wire rst,
    output reg clk_out
);
    localparam FREQ_RATIO = 23.0 / 100.0;
    localparam PHASE_INC = FREQ_RATIO * (2**32);

    reg [31:0] phase_accum = 0;

    always @(posedge clk_in) begin
        if (~rst) begin
            phase_accum <= 0;
            clk_out <= 0;
        end else begin
            phase_accum <= phase_accum + PHASE_INC;
            clk_out <= phase_accum[31];
        end
    end

endmodule