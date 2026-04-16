`timescale 1ns/1ps

module output_memory #(
   parameter filename = "edge_output.mem",
    parameter maxpixels = 65536
)(
    input wire clk, input wire write_enable, input wire [15:0] addr,
    input wire edge_pixel, input wire [15:0] imgw, input wire [15:0] imgh, input wire save
);
    reg mem [0:maxpixels-1];
    integer i, r, c, f;
    initial for(i=0; i<maxpixels; i=i+1) mem[i]=0;
    always @(negedge clk) if (write_enable) mem[addr] <= edge_pixel;
    
    always @(posedge save) if (imgw > 0) begin
        f = $fopen(filename, "w");
        // file open krrne lyi
        if (f) begin
            for (r=0; r<imgh; r=r+1) begin
                for (c=0; c<imgw; c=c+1) $fwrite(f, "%0d ", mem[r*imgw + c]);
                $fwrite(f, "\n");
            end
            $fclose(f);
        end
    end
endmodule