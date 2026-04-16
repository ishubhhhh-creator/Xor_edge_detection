`timescale 1ns/1ps
module edge_combiner(
    input wire eL, input wire eR, input wire eU, input wire eD,
    input wire eUL, input wire eUR, input wire eDL, input wire eDR,
    output wire finaledge  
);
    // sare edges nnu combine krrn lyyi (OR all 8 inputs)
    assign finaledge = eL | eR | eU | eD | eUL | eUR | eDL | eDR;
endmodule