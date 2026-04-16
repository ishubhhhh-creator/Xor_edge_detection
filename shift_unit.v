`timescale 1ns/1ps
// shifte krrn lyyi
module shift_unit (
    input wire [15:0] addr,
    input wire signed [1:0] offx,
    input wire signed [1:0] offy,
    input wire [15:0] imgw,
    input wire [15:0] imgh,
    output reg [15:0] shifted_addr,
    output reg valid
);
    integer x, y, nx, ny;
    always @(*) begin
        x = addr % imgw;
        y = addr / imgw; 
        nx = x + offx;
        // shift krn lyi x axis nu
        ny = y + offy;
        // shift krn lyi y axis


        if (nx < 0 || nx >= imgw || ny < 0 || ny >= imgh) begin     // boundary cases handle kita
            valid = 0;
            shifted_addr = addr;
        end else begin
            valid = 1;
            shifted_addr = ny * imgw + nx;
        end
    end
endmodule
