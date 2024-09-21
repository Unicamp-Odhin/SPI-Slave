module top (
    input wire clk,
    input wire reset,
    
    input wire rx,
    output wire tx,

    input wire sck,
    input wire cs,
    input wire mosi,
    output wire miso,

    input wire rw,
    output wire intr,

    output reg [7:0]led
);

wire [7:0] leds;
reg [7:0] counter;
reg [2:0] busy_sync;
reg data_in_valid;
wire rst, busy, data_out_valid, busy_posedge;

assign busy_posedge = (busy_sync[2:1] == 2'b01) ? 1'b1 : 1'b0;

ResetBootSystem #(
    .CYCLES(20)
) ResetBootSystem(
    .clk    (clk),
    .reset_o(rst)
);

SPI_Slave #(  
    .SPI_BITS_PER_WORD(8)
)U1(
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
    busy_sync <= {busy_sync[1:0], busy};

    if(reset == 1'b1) begin
        counter <= 8'h00;
    end else begin
        if(busy_posedge == 1'b1) begin
            data_in_valid <= 1'b1;
            counter <= counter + 8'h4;
        end else begin
            data_in_valid <= 1'b0;
        end
        if(data_out_valid == 1'b1) begin
            led <= ~leds;
        end
    end
end

endmodule

