`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2022 02:09:56 PM
// Design Name: 
// Module Name: i2c
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


module i2c
(
    input                   clk,
    input                   start,
    input           [7:0]   data_in,
    input                   w_rn,
    input                   first,
    input                   last,
    output logic    [7:0]   data_out,
    input                   ack_out,
    output logic            ack_in,
    
    output logic            done,
    
    inout                   iic_sda,
    inout                   iic_scl
);

enum logic [7:0] {  IDLE,
                    START,
                    WRITE_BIT_0,
                    WRITE_BIT_1,
                    WRITE_BIT_2,
                    READ_BIT_0,
                    READ_BIT_1,
                    READ_BIT_2,
                    ACK_0,
                    ACK_1,
                    ACK_2,
                    STOP_0,
                    STOP_1  } state = IDLE;

logic sda = 1'b1; 
logic scl = 1'b1;

logic [2:0] cnt;
logic w_rn_int;
logic last_int;

assign iic_scl = scl ? 1'bz : 1'b0;
assign iic_sda = sda ? 1'bz : 1'b0;

always_ff @(posedge clk)
begin
    case(state)
        IDLE:
        begin
            if(start)
            begin
                cnt <= 7;
                last_int <= last;
                w_rn_int <= w_rn;
                if(first)
                begin
                    state <= START;
                    sda <= 1'b0;
                    scl <= 1'b1;
                end
                else
                begin
                    if(w_rn_int)
                        state <= WRITE_BIT_0;
                    else
                    begin
                        sda <= 1'b1;
                        state <= READ_BIT_0;
                    end
                end 
            end
        end
        
        START:
        begin
            scl <= 1'b0;
            if(w_rn_int)
                state <= WRITE_BIT_0;
            else
                state <= READ_BIT_0;
        end
        
        WRITE_BIT_0:
        begin
            sda <= data_in[cnt];
            scl <= 1'b0;
            state <= WRITE_BIT_1;
        end
        
        WRITE_BIT_1:
        begin
            sda <= data_in[cnt];
            scl <= 1'b1;
            state <= WRITE_BIT_2;
        end
        
        WRITE_BIT_2:
        begin
            sda <= data_in[cnt];
            scl <= 1'b0;
            if(cnt != 0)
            begin
                cnt <= cnt - 1;
                state <= WRITE_BIT_0;
            end
            else
                sda <= 1'b1;
                state <= ACK_0;
        end
        
        READ_BIT_0:
        begin
            scl <= 1'b0;
            state <= READ_BIT_1;
        end
        
        READ_BIT_1:
        begin
            scl <= 1'b1;
            state <= READ_BIT_2;
        end
        
        READ_BIT_2:
        begin
            scl <= 1'b0;
            data_out <= {data_out[6:0], sda};
            if(cnt != 0)
            begin
                cnt <= cnt - 1;
                state <= READ_BIT_0;
            end
            else
            begin
                sda <= 1'b0;
                state <= ACK_0;
            end
        end
        
        ACK_0:
        begin
            scl <= 1'b1;
            state <= ACK_1;
        end
        
        ACK_1:
        begin
            scl <= 1'b0;
            ack_in <= sda;
            if(last_int)
                state <= STOP_0;
            else
                state <= IDLE;
        end
        
        STOP_0:
        begin
            scl <= 1'b1;
            sda <= 1'b0;
            state <= STOP_1;
        end
        
        STOP_1:
        begin
            sda <= 1'b1;
            state <= IDLE;
        end
        
        default: state <= IDLE;
    endcase
end

endmodule 