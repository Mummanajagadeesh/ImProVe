module image_scaling(
    input clk
);
    parameter ROWS = 242;         // Original image height
    parameter COLS = 247;         // Original image width
    parameter SCALE_VER = 2.0;    // Vertical scaling factor
    parameter SCALE_HOR = 2.0;    // Horizontal scaling factor

    integer input_file, output_file, status;
    integer i, j, scaled_i, scaled_j;
    integer new_ROWS, new_COLS;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1]; // Original image pixel data
    reg [7:0] scaled_pixel_data [0:1023][0:1023]; // Scaled image pixel data (maximum size 1024x1024 for safety)
    reg [7:0] temp_data;

    initial begin
        // Calculate new dimensions of the scaled image
        new_ROWS = $rtoi(ROWS * SCALE_VER);
        new_COLS = $rtoi(COLS * SCALE_HOR);

        // Open input file
        input_file = $fopen("input_image.txt", "r");
        if (input_file == 0) begin
            $display("Error opening input_image.txt.");
            $finish;
        end

        // Read pixel data from the input file
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

        // Initialize the scaled image data to 0
        for (i = 0; i < new_ROWS; i = i + 1) begin
            for (j = 0; j < new_COLS; j = j + 1) begin
                scaled_pixel_data[i][j] = 0;
            end
        end

        // Perform scaling
        for (i = 0; i < new_ROWS; i = i + 1) begin
            for (j = 0; j < new_COLS; j = j + 1) begin
                // Map scaled image coordinates back to original image coordinates
                scaled_i = $rtoi(i / SCALE_VER);
                scaled_j = $rtoi(j / SCALE_HOR);

                // Check if mapped coordinates are within the bounds of the original image
                if (scaled_i >= 0 && scaled_i < ROWS && scaled_j >= 0 && scaled_j < COLS) begin
                    scaled_pixel_data[i][j] = pixel_data[scaled_i][scaled_j];
                end
            end
        end

        // Open output file
        output_file = $fopen("output_image.txt", "w");
        if (output_file == 0) begin
            $display("Error opening scaled_image.txt.");
            $finish;
        end

        // Write scaled pixel data to the output file
        for (i = 0; i < new_ROWS; i = i + 1) begin
            for (j = 0; j < new_COLS; j = j + 1) begin
                if (j == new_COLS-1) begin
                    $fwrite(output_file, "%0d", scaled_pixel_data[i][j]);
                end else begin
                    $fwrite(output_file, "%0d ", scaled_pixel_data[i][j]);
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Image scaling completed with vertical scale %0.2f and horizontal scale %0.2f.", SCALE_VER, SCALE_HOR);
        $finish;
    end
endmodule
