module top (
    input wire clk,
    input wire reset,
    
    input wire rx,
    output wire tx,

    input wire sck,
    input wire cs,
    input wire mosi,
    output wire miso,

    output reg [7:0]led,
    inout [1:0]gpios
);

wire [7:0] leds;
reg [7:0] counter;
reg data_in_valid;
wire rst, busy, data_out_valid;

ResetBootSystem #(
    .CYCLES(20)
) ResetBootSystem(
    .clk    (clk),
    .reset_o(rst)
);

SPI_Slave U1(
    .clk(clk),
    .rst(rst),

    .sck (sck),
    .cs  (cs),
    .mosi(mosi),
    .miso(miso),

    .data_in_valid (data_in_valid),
    .data_out_valid(data_out_valid),
    .busy          (busy),

    .data_in (counter),
    .data_out(leds)
);

always @(posedge clk ) begin
    counter <= counter + 1'b1;
    if(busy == 1'b1) begin
        data_in_valid <= 1'b1;
    end else begin
        data_in_valid <= 1'b0;
    end

    if(data_out_valid == 1'b1) begin
        led <= ~leds;
    end
end

endmodule
