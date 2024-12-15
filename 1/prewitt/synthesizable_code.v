module prewitt_edge_detection #(
    parameter ROWS = 242,
    parameter COLS = 247
)(
    input clk,
    input rst,
    input [7:0] pixel_in,
    input valid_in,
    output reg [7:0] processed_pixel_out,
    output reg valid_out
);

    // Internal registers
    reg [7:0] line_buffer[0:2][0:COLS-1]; // 3-line buffer for sliding window
    reg [7:0] window[0:2][0:2]; // 3x3 sliding window
    reg signed [15:0] g_x, g_y;
    reg [15:0] edge_strength;

    integer i;

    // Line buffer and sliding window management
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < COLS; i = i + 1) begin
                line_buffer[0][i] <= 8'd0;
                line_buffer[1][i] <= 8'd0;
                line_buffer[2][i] <= 8'd0;
            end
            valid_out <= 1'b0;
        end else if (valid_in) begin
            // Shift the line buffers
            for (i = 0; i < COLS-1; i = i + 1) begin
                line_buffer[0][i] <= line_buffer[0][i+1];
                line_buffer[1][i] <= line_buffer[1][i+1];
                line_buffer[2][i] <= line_buffer[2][i+1];
            end
            line_buffer[0][COLS-1] <= line_buffer[1][COLS-1];
            line_buffer[1][COLS-1] <= line_buffer[2][COLS-1];
            line_buffer[2][COLS-1] <= pixel_in;

            // Update the sliding window
            window[0][0] <= window[0][1];
            window[0][1] <= window[0][2];
            window[0][2] <= line_buffer[0][COLS-1];
            window[1][0] <= window[1][1];
            window[1][1] <= window[1][2];
            window[1][2] <= line_buffer[1][COLS-1];
            window[2][0] <= window[2][1];
            window[2][1] <= window[2][2];
            window[2][2] <= line_buffer[2][COLS-1];

            // Compute Gx and Gy
            g_x <= (window[0][0] + window[0][1] + window[0][2]) -
                   (window[2][0] + window[2][1] + window[2][2]);
            g_y <= (window[0][0] + window[1][0] + window[2][0]) -
                   (window[0][2] + window[1][2] + window[2][2]);

            // Compute edge strength using mod sum approximation
            edge_strength <= (g_x[15] ? -g_x : g_x) + (g_y[15] ? -g_y : g_y);

            // Output processed pixel (clipping to 8 bits)
            processed_pixel_out <= (edge_strength > 255) ? 8'd255 : edge_strength[7:0];
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end

endmodule
