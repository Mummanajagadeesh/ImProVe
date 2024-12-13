module sobel_edge_detection_combined(
    input clk
);
    parameter ROWS = 242;  
    parameter COLS = 247;  

    integer input_file, output_file, status;
    integer i, j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1];
    reg [7:0] processed_pixel_data [0:ROWS-1][0:COLS-1];
    reg signed [15:0] g_x, g_y;
    reg signed [15:0] edge_strength;
    reg [7:0] temp_data;  

    initial begin
        input_file = $fopen("input_image.txt", "r");
        if (input_file == 0) begin
            $display("Error opening input_image.txt.");
            $finish;
        end

        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                status = $fscanf(input_file, "%d", temp_data);  
                if (status != 1) begin
                    $display("Error reading pixel data at (%0d, %0d).", i, j);
                    $finish;
                end
                pixel_data[i][j] = temp_data;  
            end
        end
        $fclose(input_file);

        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (i == 0 || i == ROWS-1 || j == 0 || j == COLS-1) begin
                    processed_pixel_data[i][j] = 0;  
                end else begin
                    // Horizontal Sobel Mask: [ -1  -2  -1 ]
                    //                           [  0   0   0 ]
                    //                           [  1   2   1 ]

                    // Vertical Sobel Mask:   [ -1  0  1 ]
                    //                           [ -2  0  2 ]
                    //                           [ -1  0  1 ]

                    g_x = (pixel_data[i-1][j-1] * -1) + (pixel_data[i-1][j] * -2) + (pixel_data[i-1][j+1] * -1) +
                          (pixel_data[i][j-1] * 0) + (pixel_data[i][j] * 0) + (pixel_data[i][j+1] * 0) +
                          (pixel_data[i+1][j-1] * 1) + (pixel_data[i+1][j] * 2) + (pixel_data[i+1][j+1] * 1);

                    g_y = (pixel_data[i-1][j-1] * -1) + (pixel_data[i-1][j] * 0) + (pixel_data[i-1][j+1] * 1) +
                          (pixel_data[i][j-1] * -2) + (pixel_data[i][j] * 0) + (pixel_data[i][j+1] * 2) +
                          (pixel_data[i+1][j-1] * -1) + (pixel_data[i+1][j] * 0) + (pixel_data[i+1][j+1] * 1);

                    edge_strength = (g_x * g_x) + (g_y * g_y);  
                    edge_strength = $sqrt(edge_strength); 
                    if (edge_strength > 255) edge_strength = 255;

                    processed_pixel_data[i][j] = edge_strength[7:0]; 
                end
            end
        end

        output_file = $fopen("output_image_combined.txt", "w");
        if (output_file == 0) begin
            $display("Error opening output_image_combined.txt.");
            $finish;
        end

        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (j == COLS-1) begin
                    $fwrite(output_file, "%0d", processed_pixel_data[i][j]); 
                end else begin
                    $fwrite(output_file, "%0d ", processed_pixel_data[i][j]);  
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Edge detection completed with combined gradient.");
        $finish;
    end
endmodule
