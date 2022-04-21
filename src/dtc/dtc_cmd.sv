`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/20/2022 02:02:33 PM
// Design Name: 
// Module Name: dtc_cmd
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


module dtc_cmd
(
    //DTC_PORTS
    input                   rst,
    input                   dtc_clk,
    input           [31:0]  address,
    input           [31:0]  write_data,
    output logic    [31:0]  read_data = 0,
    input                   write,
    input                   read,
    output logic            data_vld,
    
    //FEC_PORTS
    output logic    [15:0]  reg_pwr_en,
    input           [15:0]  status,
    output logic    [7:0]   thyst,
    output logic    [7:0]   toti,
    output logic    [63:0]  channel_mask,
    output logic            altro_rst,
    output logic            fee_rst,
    output logic            hv_update,
    input           [15:0]  firmvare,
    input           [9:0]   adc_data [14:0],
    output logic    [31:0][11:0]  hv_dac_data = 0    
);

`define     CMD_REG_EN          8'h01   //  RW Power enable, 11 bits
`define     CMD_FEE_STATUS      8'h02   //  RO FEC status, 16 bits 
`define     CMD_MAP_ADDRESS     8'h03   //  RW FEE GTL address, 5 bits
`define     CMD_THYST           8'h04   //  RW Temperature thresholds, 8 bits
`define     CMD_TOTI            8'h05   //  RW Temperature thresholds, 8 bits
//  RW Channel readout mask, 64 bits
`define     CMD_CNANNEL_MASK_0  8'h06     
`define     CMD_CNANNEL_MASK_1  8'h07   
`define     CMD_CNANNEL_MASK_2  8'h08   
`define     CMD_CNANNEL_MASK_3  8'h09

`define     CMD_ALTRO_RESET     8'h19   //  WO Altro reset
`define     CMD_FEE_RESET       8'h1A   //  WO FEE reset
`define     CMD_HV_UPDATE       8'h1E   //  WO APD bias high voltage update command
`define     CMD_FIRMWARE        8'h20   //  RO Firmware Version, 16 bits
//  RO FEE temperature ,current and voltage status 0x50 - 0x5E
`define     CMD_ADC_DATA_BASE   8'h50

// RW APD bias voltage for 32 channels 0x60 - 0x7F
`define     CMD_HV_BASE         8'h60
`define     CMD_SERIAL_NUMBER   8'h80   //  RW  Could only write before installed ???

logic [4:0]     map_address;

logic [15:0]    serial_number;

integer i, j, k;
always_ff @(posedge dtc_clk)
begin
    altro_rst   <= 1'b0;
    fee_rst     <= 1'b0;
    hv_update   <= 1'b0;
    if(write)
    begin
        if((address[7:4] == 4'h6) || (address[7:4] == 4'h7))
        begin
            for(i = 0; i < 32; i = i + 1)
                if((address - `CMD_HV_BASE) == i) hv_dac_data[i] <= write_data[11:0];
        end
        else case(address[7:0])
            `CMD_REG_EN:            reg_pwr_en          <= write_data[10:0];
            `CMD_MAP_ADDRESS:       map_address         <= write_data[4:0];
            `CMD_THYST:             thyst               <= write_data[7:0];
            `CMD_TOTI:              toti                <= write_data[7:0];
            `CMD_CNANNEL_MASK_0:    channel_mask[15:0]  <= write_data[15:0];
            `CMD_CNANNEL_MASK_1:    channel_mask[31:16] <= write_data[15:0];
            `CMD_CNANNEL_MASK_2:    channel_mask[47:32] <= write_data[15:0];
            `CMD_CNANNEL_MASK_3:    channel_mask[63:48] <= write_data[15:0];
            `CMD_ALTRO_RESET:       altro_rst   <= 1'b1;
            `CMD_FEE_RESET:         fee_rst     <= 1'b1;
            `CMD_HV_UPDATE:         hv_update   <= 1'b1;   
            `CMD_SERIAL_NUMBER:     serial_number       <= write_data[15:0];
            default: ;
        endcase
    end
end

always_ff @(posedge dtc_clk)
begin
    data_vld <= 1'b0;
    if(read)
    begin
        data_vld <= 1'b1;
        if((address[7:4] == 4'h6) || (address[7:4] == 4'h7))
        begin
            for(j = 0; j < 32; j = j + 1)
                if((address - `CMD_HV_BASE) == j) read_data   <= {{20{1'b0}}, hv_dac_data[j]};
        end
        else if(address[7:4] == 4'h5)
        begin
            for(k = 0; k < 15; k = k + 1)
                if((address - `CMD_ADC_DATA_BASE) == k) read_data   <= {{22{1'b0}}, adc_data[k]};
        end
        else case(address[7:0])
            `CMD_REG_EN:            read_data   <= {{21{1'b0}}, reg_pwr_en};
            `CMD_FEE_STATUS:        read_data   <= {{16{1'b0}}, status};
            `CMD_MAP_ADDRESS:       read_data   <= {{27{1'b0}}, map_address};
            `CMD_THYST:             read_data   <= {{24{1'b0}}, thyst};
            `CMD_TOTI:              read_data   <= {{24{1'b0}}, toti};
            `CMD_CNANNEL_MASK_0:    read_data   <= channel_mask[15:0];
            `CMD_CNANNEL_MASK_1:    read_data   <= channel_mask[31:16];
            `CMD_CNANNEL_MASK_2:    read_data   <= channel_mask[47:32];
            `CMD_CNANNEL_MASK_3:    read_data   <= channel_mask[63:48];
            `CMD_SERIAL_NUMBER:     read_data   <= serial_number;
            default: read_data <= address;
        endcase
    end
end

endmodule
