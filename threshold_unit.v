`timescale 1ns/1ps
module threshold_unit (
    input wire [9:0] magnitude_in,
    input wire [9:0] threshold_val,
    output wire edge_pixel
);
    assign edge_pixel = (magnitude_in > threshold_val);
    
endmodule