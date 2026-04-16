`timescale 1ns/1ps
module diagonal_detector #(
    parameter pixelbits = 24
)(
    input wire [pixelbits-1:0] p0,  
    input wire [pixelbits-1:0] pUL, 
    input wire [pixelbits-1:0] pUR, 
    input wire [pixelbits-1:0] pDL, 
    input wire [pixelbits-1:0] pDR, 
    input wire [1:0] mode,
    
    output wire raweUL, 
    output wire raweUR, 
    output wire raweDL, 
    output wire raweDR
);
    xor_edge_detector #(.pixelbits(pixelbits)) xUL (p0, pUL, mode, raweUL);
    xor_edge_detector #(.pixelbits(pixelbits)) xUR (p0, pUR, mode, raweUR);
    xor_edge_detector #(.pixelbits(pixelbits)) xDL (p0, pDL, mode, raweDL);
    xor_edge_detector #(.pixelbits(pixelbits)) xDR (p0, pDR, mode, raweDR);

endmodule