`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/20/2022 02:06:17 PM
// Design Name: 
// Module Name: Sample_Sum
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


module Sample_Sum
#(
    parameter   presample_num   = 8,
    parameter   sample_num      = 16 
) (
    input       clk,
    input       rst,
    
    input       L0,
    
    
    input           [11:0]  data_in,
    output logic    [11:0]  data_out
);

localparam   presample_shift = $clog2(presample_num);
localparam   sample_shift = $clog2(sample_num);

enum logic [7:0]    {   IDLE,
                        PRESAMPLE_SUM,
                        SAMPLE_SUM  } state;

logic [15:0] presample_sum;
logic [15:0] sample_sum;
logic [7:0] cnt;

always_ff @(posedge clk)
begin
    if(rst)
    begin
        presample_sum <= 0;
        sample_sum <= 0;
        cnt <= 0;
        state <= IDLE;
    end
    else
    begin
        case(state)
            IDLE:
                if(L0)
                begin
                    presample_sum <= 0;
                    sample_sum <= 0;
                    cnt <= presample_num;
                    state <= PRESAMPLE_SUM;
                end
            PRESAMPLE_SUM:
            begin
                if(cnt != 0)
                begin
                    cnt <= cnt - 1;
                    presample_sum <= presample_sum + data_in;
                end
                else
                begin
                    cnt <= sample_num;
                    state <= SAMPLE_SUM;
                end
            end
            SAMPLE_SUM:
            begin
                if(cnt != 0)
                begin
                    cnt <= cnt - 1;
                    sample_sum <= sample_sum + data_in;
                end
                else
                begin
                    data_out <= (sample_sum >> sample_shift) - (presample_sum >> presample_shift);
                    state <= IDLE;
                end
            end
            default: state <= IDLE;
        endcase
    end
end
endmodule
