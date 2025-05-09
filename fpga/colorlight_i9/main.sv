module top (
    input  logic clk,
    input  logic reset,
    
    input  logic rx,
    output logic tx,

    input  logic sck,
    input  logic cs,
    input  logic mosi,
    output logic miso,

    input  logic rw,
    output logic intr,

    output logic [7:0]led
);

logic [7:0] leds;
logic [7:0] counter;
logic [2:0] busy_sync;
logic data_in_valid;
logic rst, busy, data_out_valid, busy_posedge;

assign busy_posedge = ~busy_sync[2] & busy_sync[1];


ResetBootSystem #(
    .CYCLES  (20)
) ResetBootSystem(
    .clk     (clk),
    .rst_n_o (rst_n)
);

SPI_Slave #(
    .SPI_BITS_PER_WORD (8),
    .SPI_MODE          (1)
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
            jc <= ~leds;
        end
    end
end


endmodule

