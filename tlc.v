module traffic_light_controller(
    input clk,          // Clock signal
    input reset,        // Reset signal
    output reg [2:0] light_north_south, // [Red, Yellow, Green]
    output reg [2:0] light_east_west    // [Red, Yellow, Green]
);

    // State Encoding
    parameter S0 = 2'b00, // NS Green, EW Red
              S1 = 2'b01, // NS Yellow, EW Red
              S2 = 2'b10, // NS Red, EW Green
              S3 = 2'b11; // NS Red, EW Yellow

    reg [1:0] current_state, next_state;
    reg [3:0] counter; // Timer for states

    // 1. State Transition Logic (Sequential)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
            counter <= 0;
        end else begin
            if (counter == 4'd10) begin // Stay in each state for 10 clock cycles
                current_state <= next_state;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end
    end

    // 2. Next State Logic (Combinational)
    always @(*) begin
        case (current_state)
            S0: next_state = S1;
            S1: next_state = S2;
            S2: next_state = S3;
            S3: next_state = S0;
            default: next_state = S0;
        endcase
    end

    // 3. Output Logic (Combinational)
    always @(*) begin
        case (current_state)
            S0: begin light_north_south = 3'b001; light_east_west = 3'b100; end // NS Green, EW Red
            S1: begin light_north_south = 3'b010; light_east_west = 3'b100; end // NS Yellow, EW Red
            S2: begin light_north_south = 3'b100; light_east_west = 3'b001; end // NS Red, EW Green
            S3: begin light_north_south = 3'b100; light_east_west = 3'b010; end // NS Red, EW Yellow
            default: begin light_north_south = 3'b100; light_east_west = 3'b100; end
        endcase
    end
endmodule