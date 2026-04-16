`timescale 1ns/1ps

module image_memory #(
    parameter pixelbits = 24,    // one pixel da size
    parameter filename = "universal_8x8.mem",
    parameter maxpixels = 65536   // max no of pixel limit
)(
    input wire [15:0] addr, 
    output wire [pixelbits-1:0] pixelout
);
    reg [pixelbits-1:0] mem [0:maxpixels-1];
    integer i;
    initial begin
        for (i = 0; i < maxpixels; i = i + 1) mem[i] = 0;
        $readmemb(filename, mem);    // file cho read krn lyyi binary 
    end
    assign pixelout = mem[addr];
endmodule