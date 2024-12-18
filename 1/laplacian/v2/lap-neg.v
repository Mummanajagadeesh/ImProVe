module negative_laplacian_filter(
    input clk
);
    parameter ROWS = 242;  
    parameter COLS = 247;  

    integer input_file, output_file, status;
    integer i, j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1];
    reg [7:0] processed_pixel_data [0:ROWS-1][0:COLS-1];
    reg signed [15:0] laplacian_sum;
    reg [7:0] temp_data;

    initial begin
        // Open input file
        input_file = $fopen("input_image.txt", "r");
        if (input_file == 0) begin
            $display("Error opening input_image.txt.");
            $finish;
        end

        // Read pixel data from file
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

        // Apply Negative Laplacian filter
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                // Handle boundary pixels
                if (i == 0 || i == ROWS-1 || j == 0 || j == COLS-1) begin
                    processed_pixel_data[i][j] = 0;
                end else begin
                    // Apply negative Laplacian matrix
                    laplacian_sum = ( 4 * pixel_data[i][j] ) -  // Center
                                    ( pixel_data[i-1][j  ] +  // Top center
                                      pixel_data[i  ][j-1] +  // Left
                                      pixel_data[i  ][j+1] +  // Right
                                      pixel_data[i+1][j  ] ); // Bottom center

                    // Clamp the result to 0-255
                    if (laplacian_sum < 0) laplacian_sum = 0;
                    if (laplacian_sum > 255) laplacian_sum = 255;

                    processed_pixel_data[i][j] = laplacian_sum[7:0];
                end
            end
        end

        // Write processed data to output file
        output_file = $fopen("output_image_neg.txt", "w");
        if (output_file == 0) begin
            $display("Error opening output_image_negative_laplacian.txt.");
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

        $display("Negative Laplacian filter applied successfully.");
        $finish;
    end
endmodule
