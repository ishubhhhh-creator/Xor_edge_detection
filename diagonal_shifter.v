`timescale 1ns/1ps
module diagonal_shifter (
    input wire [15:0] addr,
    input wire [15:0] imgw,
    input wire [15:0] imgh,
    output wire [15:0] aUL,
    output wire [15:0] aUR, 
    output wire [15:0] aDL,
    output wire [15:0] aDR, 
    output wire vUL, 
    output wire vUR, 
    output wire vDL,
    output wire vDR 
);

    shift_unit sUL (.addr(addr), .offx(-1), .offy(-1), .imgw(imgw), .imgh(imgh), .shifted_addr(aUL), .valid(vUL));
    shift_unit sUR (.addr(addr), .offx(1),  .offy(-1), .imgw(imgw), .imgh(imgh), .shifted_addr(aUR), .valid(vUR));
    shift_unit sDL (.addr(addr), .offx(-1), .offy(1),  .imgw(imgw), .imgh(imgh), .shifted_addr(aDL), .valid(vDL));
    shift_unit sDR (.addr(addr), .offx(1),  .offy(1),  .imgw(imgw), .imgh(imgh), .shifted_addr(aDR), .valid(vDR));

endmodule