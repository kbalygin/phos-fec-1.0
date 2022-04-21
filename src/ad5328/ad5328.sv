`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/21/2022 12:37:15 PM
// Design Name: 
// Module Name: ad5328
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ad5328
(
    input                       rst,
    input                       dtc_clk,
    
    input           [31:0][11:0]dac_data,
    input                       dac_update,
    
    output logic                din,
    output logic    [3:0]       sync_n,
    output logic                ldac_n,
    output logic                sclk
);

logic done = 0;
enum logic  [7:0]   {   INIT,
                        IDLE,
                        DATA_LOAD,
                        WAIT_,
                        DAC_LOAD    } state = INIT;
logic [15:0] data;
logic [4:0] sync_cnt;
logic [4:0] ch;
logic       sync;

assign ldac_n = ~(state == DAC_LOAD);
assign din = data[15];
assign sclk = (sync) ? sync_cnt[0] : 1'b1;

generate
genvar i;
for(i = 0; i < 4; i = i + 1)
begin : ChipSelect
	assign sync_n [i] = (ch[4:3] == i) ? (!sync) : 1'b1;
end
endgenerate


always_ff @(posedge dtc_clk)
begin
	if(rst) state <= INIT;
	else 
	begin
		case (state)
			INIT: 
			begin
				state <= IDLE;
				sync_cnt <= 5'b0;
				data <= 16'b0;
				sync <= 0;
				ch <= 0;
			end
			
			IDLE:
			begin
			     ch <= 0;
				if (dac_update)
				begin
					sync_cnt <= 31;
					data <= {1'b0 ,ch[2:0], dac_data[0]};
					sync <= 1'b1;
					ch <= 0;
					state <= DATA_LOAD;
				end
			end
			
			DATA_LOAD:
			begin
				if (sync_cnt == 0)
				begin
				    sync <= 1'b0;
				    if(ch == 31)
					   state <= DAC_LOAD;
					else
					begin
					   ch <= ch + 1;
					   state <= WAIT_;
					end
				end
				else
				begin
					sync_cnt <= sync_cnt - 1;
					if(sync_cnt[0] == 1'b0)
						data <= {data[14:0], 1'b0};
				end
			end
			WAIT_:
            begin
                data <= {1'b0 ,ch[2:0], dac_data[ch[2:0]]};
                sync_cnt <= 31;
                sync <= 1'b1;
                state <= DATA_LOAD;
			end
			DAC_LOAD:    state <= IDLE;
			
			default: state <= IDLE;
		endcase
	end
end
endmodule
