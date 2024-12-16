module adaptive_threshold;
    // Parameters for the size of the image
    parameter ROWS = 512;       // Change based on your input image dimensions
    parameter COLS = 512;
    parameter WINDOW_SIZE = 5;  // Size of the neighborhood (e.g., 7x7 window)

    // File handles
    integer input_file, output_file;
    integer i, j, m, n, pixel_value, scan_result, sum, count;

    // Memory to store the image
    reg [7:0] image[0:ROWS-1][0:COLS-1];
    reg [7:0] output_image[0:ROWS-1][0:COLS-1];

    initial begin
        // Open input and output files
        input_file = $fopen("lena_b.txt", "r");
        output_file = $fopen("lena_adap_b.txt", "w");

        if (input_file == 0) begin
            $display("Error: Cannot open input_image.txt");
            $finish;
        end

        if (output_file == 0) begin
            $display("Error: Cannot open output_image.txt");
            $finish;
        end

        // Read the image data from the input file
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                scan_result = $fscanf(input_file, "%d", pixel_value);
                if (scan_result != 1) begin
                    $display("Error reading pixel at row %d, col %d", i, j);
                    $finish;
                end
                image[i][j] = pixel_value[7:0]; // Store 8-bit pixel value
            end
        end

        // Close the input file after reading
        $fclose(input_file);

        // Apply adaptive thresholding
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                sum = 0;
                count = 0;

                // Compute the sum of the local window
                for (m = -WINDOW_SIZE/2; m <= WINDOW_SIZE/2; m = m + 1) begin
                    for (n = -WINDOW_SIZE/2; n <= WINDOW_SIZE/2; n = n + 1) begin
                        if ((i + m >= 0) && (i + m < ROWS) && (j + n >= 0) && (j + n < COLS)) begin
                            sum = sum + image[i + m][j + n];
                            count = count + 1;
                        end
                    end
                end

                // Calculate the local mean
                pixel_value = (count != 0) ? (sum / count) : image[i][j];

                // Apply threshold based on local mean
                output_image[i][j] = (image[i][j] >= pixel_value) ? 8'd255 : 8'd0;
            end
        end

        // Write the processed image data to the output file
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                $fwrite(output_file, "%d ", output_image[i][j]);
            end
            $fwrite(output_file, "\n");
        end

        // Close the output file after writing
        $fclose(output_file);

        $finish;
    end
endmodule
