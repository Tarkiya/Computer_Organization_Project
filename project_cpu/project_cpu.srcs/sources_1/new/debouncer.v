module debouncer (
    input slowclk,
    input button,
    output signal
    );
    reg q1 = 0;
    reg q2 = 1;
    always @(posedge slowclk) begin
        if (button) begin
            q1 <= 1;
            q2 <= ~q1;
        end
        else begin
            q1 <= 0;
            q2 <= ~q1;
        end
    end
    assign signal = q1 & q2;
endmodule