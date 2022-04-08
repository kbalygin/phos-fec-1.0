//
//     PHOS FEC V1 - ADC Channel Mapping
//
//    Copyright 2021 Andrey Shchipunov
//
//    This file may be used under the terms of the
//    GNU General Public License version 3.0 as
//    published by the Free Software Foundation.
//    http://www.gnu.org/licenses/gpl.html
//


module phos_fec_v1_adc_mapping #(
   parameter ADC_BITS     = 12,
   parameter ADC_CHIPS    = 2,
   parameter ADC_CHIP_NCH = 32
) (
   input  wire [ADC_CHIPS*ADC_CHIP_NCH*ADC_BITS-1:0] adc_pdata_i,
   output wire [ADC_CHIPS*ADC_CHIP_NCH*ADC_BITS-1:0] adc_pdata_o
);


localparam ADC_NCH = ADC_CHIPS * ADC_CHIP_NCH;

genvar i;


// Split input ADC parallel data by channel
wire [ADC_BITS-1:0] adc_i [0:ADC_NCH-1];
generate
   for (i=0; i<ADC_NCH; i=i+1) begin : gen_adc_data_split
      assign adc_i[i] = adc_pdata_i[ (i+1)*ADC_BITS-1 : i*ADC_BITS ];
   end
endgenerate


////////////////////////////////////////////////////////////////////////////////
// ADC channels swap
wire [ADC_BITS-1:0] adc_fix [0:ADC_NCH-1];

// Ch 0-15
// assign adc_fix[ 0] = adc_i[ 0];
// assign adc_fix[ 1] = adc_i[ 1];
// assign adc_fix[ 2] = adc_i[ 4];
// assign adc_fix[ 3] = adc_i[ 5];
// assign adc_fix[ 4] = adc_i[ 8];
// assign adc_fix[ 5] = adc_i[ 9];
// assign adc_fix[ 6] = adc_i[12];
// assign adc_fix[ 7] = adc_i[13];
// assign adc_fix[ 8] = adc_i[16];
// assign adc_fix[ 9] = adc_i[17];
// assign adc_fix[10] = adc_i[20];
// assign adc_fix[11] = adc_i[21];
// assign adc_fix[12] = adc_i[24];
// assign adc_fix[13] = adc_i[25];
// assign adc_fix[14] = adc_i[28];
// assign adc_fix[15] = adc_i[29];
generate
for (i=0; i<16; i=i+2) begin : gen_adc_fix_0_15
   assign adc_fix[i+0] = adc_i[2*i+0];
   assign adc_fix[i+1] = adc_i[2*i+1];
end
endgenerate


// Ch 16-31
// assign adc_fix[16] = adc_i[61];
// assign adc_fix[17] = adc_i[60];
// assign adc_fix[18] = adc_i[57];
// assign adc_fix[19] = adc_i[56];
// assign adc_fix[20] = adc_i[53];
// assign adc_fix[21] = adc_i[52];
// assign adc_fix[22] = adc_i[49];
// assign adc_fix[23] = adc_i[48];
// assign adc_fix[24] = adc_i[45];
// assign adc_fix[25] = adc_i[44];
// assign adc_fix[26] = adc_i[41];
// assign adc_fix[27] = adc_i[40];
// assign adc_fix[28] = adc_i[37];
// assign adc_fix[29] = adc_i[36];
// assign adc_fix[30] = adc_i[33];
// assign adc_fix[31] = adc_i[32];
generate
for (i=0; i<16; i=i+2) begin : gen_adc_fix_16_31
   assign adc_fix[16+i] = adc_i[61-2*i];
   assign adc_fix[17+i] = adc_i[60-2*i];
end
endgenerate

// Ch 32-47
// assign adc_fix[32] = adc_i[ 2];
// assign adc_fix[33] = adc_i[ 3];
// assign adc_fix[34] = adc_i[ 6];
// assign adc_fix[35] = adc_i[ 7];
// assign adc_fix[36] = adc_i[10];
// assign adc_fix[37] = adc_i[11];
// assign adc_fix[38] = adc_i[14];
// assign adc_fix[39] = adc_i[15];
// assign adc_fix[40] = adc_i[18];
// assign adc_fix[41] = adc_i[19];
// assign adc_fix[42] = adc_i[22];
// assign adc_fix[43] = adc_i[23];
// assign adc_fix[44] = adc_i[26];
// assign adc_fix[45] = adc_i[27];
// assign adc_fix[46] = adc_i[30];
// assign adc_fix[47] = adc_i[31];
generate
for (i=0; i<16; i=i+2) begin : gen_adc_fix_32_47
   assign adc_fix[32+i] = adc_i[2*i+2];
   assign adc_fix[33+i] = adc_i[2*i+3];
end
endgenerate

// Ch 48-63
// assign adc_fix[48] = adc_i[63];
// assign adc_fix[49] = adc_i[62];
// assign adc_fix[50] = adc_i[59];
// assign adc_fix[51] = adc_i[58];
// assign adc_fix[52] = adc_i[55];
// assign adc_fix[53] = adc_i[54];
// assign adc_fix[54] = adc_i[51];
// assign adc_fix[55] = adc_i[50];
// assign adc_fix[56] = adc_i[47];
// assign adc_fix[57] = adc_i[46];
// assign adc_fix[58] = adc_i[43];
// assign adc_fix[59] = adc_i[42];
// assign adc_fix[60] = adc_i[39];
// assign adc_fix[61] = adc_i[38];
// assign adc_fix[62] = adc_i[35];
// assign adc_fix[63] = adc_i[34];
generate
for (i=0; i<16; i=i+2) begin : gen_adc_fix_48_63
   assign adc_fix[48+i] = adc_i[63-2*i];
   assign adc_fix[49+i] = adc_i[62-2*i];
end
endgenerate
////////////////////////////////////////////////////////////////////////////////


// Merge remapped ADC data into parallel output bus
generate
   for (i=0; i<ADC_NCH; i=i+1) begin : gen_adc_data_merge
      assign adc_pdata_o[ (i+1)*ADC_BITS-1 : i*ADC_BITS ] = adc_fix[i];
   end
endgenerate

endmodule
