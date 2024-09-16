module SPI_Slave (
    input wire clk,
    input wire rst,

    input wire sck,
    input wire cs,
    input wire mosi,
    output wire miso,
    
    input wire data_in_valid,
    output reg data_out_valid,
    output wire busy,

    input wire [7:0] data_in,
    output reg [7:0] data_out
);


reg [7:0] data_in_reg, data_to_send;
reg [2:0] bit_count;
reg [2:0] sck_sync, cs_sync; // 3-bit shift register to slk and cs sync
reg [1:0] mosi_sync;
wire rising_edge, falling_edge, cs_active, start_message, end_message;

always @(posedge clk ) begin
    if(rst == 1'b1) begin
        sck_sync  <= 3'b000;
        cs_sync   <= 3'b000;
        mosi_sync <= 2'b00;
    end else begin
        sck_sync  <= {sck_sync[1:0], sck};
        cs_sync   <= {cs_sync[1:0], cs};
        mosi_sync <= {mosi_sync[0], mosi};
    end
end

always @(posedge clk ) begin
    if(cs_active == 1'b0) begin
        bit_count <= 3'b000;
    end else begin
        if(rising_edge == 1'b1) begin
            bit_count <= bit_count + 1'b1;
            data_out <= {data_out[6:0], mosi_sync[1]};
        end    
    end
end

always @(posedge clk ) begin
    if(rst == 1'b1) begin
        data_out_valid <= 1'b0;
    end else begin
        data_out_valid <= cs_active && rising_edge && (bit_count == 3'b111);
    end
end

always @(posedge clk ) begin
    if(rst == 1'b1) begin
        data_in_reg <= 8'h55;
    end else begin
        if(data_in_valid == 1'b1) begin
            data_in_reg <= data_in;
        end
    end
end

always @(posedge clk ) begin
    if(cs_active == 1'b1) begin
        if(start_message == 1'b1) begin
            data_to_send <= data_in_reg;
        end else begin
            if(rising_edge == 1'b1) begin
                data_to_send <= {data_to_send[6:0], 1'b0};
            end
        end
    end
end

assign miso          = data_to_send[7];
assign rising_edge   = (sck_sync[2:1] == 2'b01) ? 1'b1 : 1'b0;
assign falling_edge  = (sck_sync[2:1] == 2'b10) ? 1'b1 : 1'b0;
assign cs_active     = ~cs_sync[1];
assign start_message = (cs_sync[2:1] == 2'b10) ? 1'b1 : 1'b0; // message starts in cs falling edge
assign end_message   = (cs_sync[2:1] == 2'b01) ? 1'b1 : 1'b0; // message ends in cs rising edge
assign busy          = cs_sync[1];

endmodule
