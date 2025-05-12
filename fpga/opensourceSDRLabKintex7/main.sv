module top (
    input  logic clk,
    input  logic rst_n,

    output logic [7:0]led,

    input  logic mosi,
    output logic miso,
    input  logic sck,
    input  logic cs
);

logic [7:0] counter, leds;
logic [2:0] busy_sync;
logic data_in_valid, busy, data_out_valid, busy_posedge;


SPI_Slave #(
    .SPI_BITS_PER_WORD (8),
    .SPI_MODE          (0)
) U1(
    .clk            (clk),
    .rst_n          (rst_n),

    .sck            (sck),
    .cs             (cs),
    .mosi           (mosi),
    .miso           (miso),

    .data_in_valid  (data_in_valid),
    .data_out_valid (data_out_valid),
    .busy           (busy),

    .data_in        (counter),
    .data_out       (leds)
);

always_ff @(posedge clk ) begin
    busy_sync <= {busy_sync[1:0], busy};

    if(!rst_n) begin
        counter <= 8'h00;
    end else begin
        if(busy_posedge) begin
            data_in_valid <= 1'b1;
            counter       <= counter + 1'b1;
        end else begin
            data_in_valid <= 1'b0;
        end
        if(data_out_valid) begin
            led <= leds;
        end
    end
end

assign busy_posedge = (busy_sync[2:1] == 2'b01) ? 1'b1 : 1'b0;

endmodule
