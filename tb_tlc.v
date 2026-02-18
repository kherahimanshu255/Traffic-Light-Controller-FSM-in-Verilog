`timescale 1ns / 1ps

module tb_traffic_light_controller();
    reg clk;
    reg reset;
    wire [2:0] light_north_south;
    wire [2:0] light_east_west;

    // Instantiate the design
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .light_north_south(light_north_south),
        .light_east_west(light_east_west)
    );

    // Generate Clock (Toggle every 5ns for 100MHz)
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        #20 reset = 0; // Release reset after 20ns
        
        #500 $finish; // Run for 500ns then stop
    end
endmodule