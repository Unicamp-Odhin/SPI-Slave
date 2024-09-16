module top (
    input wire clk,
    input wire [0:0] btn,
    input wire rx,
    output wire tx,
    output wire [3:0] led,
    output wire [7:0] jc,
    input wire cs,
    input wire mosi,
    input wire sck,
    input wire reset,
    output wire miso,
    output wire int
);

wire rst;
reg [7:0] counter;
reg data_in_valid;

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
    .data_out_valid(),
    .busy          (),

    .data_in (8'h55),
    .data_out(jc)
);

always @(posedge clk ) begin
    data_in_valid <= 1'b0;
    if(rst == 1'b1) begin
        counter <= 8'h00;
    end else begin
        if(cs == 1'b1) begin
            counter <= counter + 1'b1;
            data_in_valid <= 1'b1;
        end
    end
end

endmodule
