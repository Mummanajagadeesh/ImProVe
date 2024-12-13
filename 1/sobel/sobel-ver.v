module sobel_edge_detection(
    input clk
);
    parameter ROWS = 242;  
    parameter COLS = 247;  

    integer input_file, output_file, status;
    integer i, j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1];
    reg [7:0] processed_pixel_data [0:ROWS-1][0:COLS-1];
    reg signed [15:0] sum_y, edge_strength;
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
                    processed_pixel_data[i][j] = 0;  // No processing at borders
                end else begin
                    // Vertical Sobel Mask: [ -1  0  1 ]
                    //                           [ -2  0  2 ]
                    //                           [ -1  0  1 ]

                    sum_y = (pixel_data[i-1][j-1] * -1) + (pixel_data[i-1][j] * 0) + (pixel_data[i-1][j+1] * 1) +
                            (pixel_data[i][j-1] * -2) + (pixel_data[i][j] * 0) + (pixel_data[i][j+1] * 2) +
                            (pixel_data[i+1][j-1] * -1) + (pixel_data[i+1][j] * 0) + (pixel_data[i+1][j+1] * 1);

                    edge_strength = $abs(sum_y);  
                    if (edge_strength > 255) edge_strength = 255;

                    processed_pixel_data[i][j] = edge_strength[7:0];  
                end
            end
        end

        output_file = $fopen("output_image_ver.txt", "w");
        if (output_file == 0) begin
            $display("Error opening output_image.txt.");
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

        $display("Edge detection completed.");
        $finish;
    end
endmodule
