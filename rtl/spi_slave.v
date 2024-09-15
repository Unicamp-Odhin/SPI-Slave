module SPI_Slave (
    input wire clk,
    input wire rst,

    input wire sck,
    input wire cs,
    input wire mosi,
    output reg miso,
    
    input wire data_in_valid,
    output reg data_out_valid,
    output wire busy,

    input wire [7:0] data_in,
    output reg [7:0] data_out,
);


reg [7:0] data_in_reg;
reg [2:0] bit_count;

always @(posedge clk) begin
    if(rst == 1'b1) begin
        data_in_reg <= 8'b0;
    end else begin
        if(data_in_valid == 1'b1 && cs == 1'b1) begin
            data_in_reg <= data_in;
        end
    end
end

always @(posedge sck) begin
    if(rst == 1'b1) begin
        miso <= 1'b0;
        bit_count <= 3'b0;
    end else begin
        if(cs == 1'b0) begin
            data_out_valid <= 1'b0;

            miso <= data_in_reg[7];
            data_in_reg <= {data_in_reg[6:0], 1'b0};
            
            bit_count <= bit_count + 1'b1;

            data_out <= {data_out[6:0], mosi};

            if(bit_count == 3'b111) begin
                data_out_valid <= 1'b1;
            end
        end else begin
            miso_reg <= 1'b0;
            bit_count <= 3'b000;
        end
    end
end

assign busy = cs; 
    
endmodule