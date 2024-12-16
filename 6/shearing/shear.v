module image_shearing(
    input clk
);
    parameter ROWS = 242;         // Original image height
    parameter COLS = 247;         // Original image width
    parameter SHEAR_X = 0.3;      // Horizontal shear factor
    parameter SHEAR_Y = 0.4;      // Vertical shear factor

    integer input_file, output_file, status;
    integer i, j, sheared_i, sheared_j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1]; // Original image pixel data
    reg [7:0] sheared_pixel_data [0:1023][0:1023]; // Sheared image pixel data (maximum size 1024x1024 for safety)
    reg [7:0] temp_data;

    initial begin
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

        // Initialize the sheared image data to 0
        for (i = 0; i < ROWS + $rtoi(COLS * SHEAR_Y); i = i + 1) begin
            for (j = 0; j < COLS + $rtoi(ROWS * SHEAR_X); j = j + 1) begin
                sheared_pixel_data[i][j] = 0;
            end
        end

        // Perform shearing transformation
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                // Calculate new sheared coordinates
                sheared_i = i + $rtoi(j * SHEAR_Y);
                sheared_j = j + $rtoi(i * SHEAR_X);

                // Check if mapped coordinates are within bounds
                if (sheared_i >= 0 && sheared_i < ROWS + $rtoi(COLS * SHEAR_Y) &&
                    sheared_j >= 0 && sheared_j < COLS + $rtoi(ROWS * SHEAR_X)) begin
                    sheared_pixel_data[sheared_i][sheared_j] = pixel_data[i][j];
                end
            end
        end

        // Open output file
        output_file = $fopen("output_image.txt", "w");
        if (output_file == 0) begin
            $display("Error opening sheared_image.txt.");
            $finish;
        end

        // Write sheared pixel data to the output file
        for (i = 0; i < ROWS + $rtoi(COLS * SHEAR_Y); i = i + 1) begin
            for (j = 0; j < COLS + $rtoi(ROWS * SHEAR_X); j = j + 1) begin
                if (j == COLS + $rtoi(ROWS * SHEAR_X) - 1) begin
                    $fwrite(output_file, "%0d", sheared_pixel_data[i][j]);
                end else begin
                    $fwrite(output_file, "%0d ", sheared_pixel_data[i][j]);
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Image shearing completed with shear factors SHEAR_X = %0.2f and SHEAR_Y = %0.2f.", SHEAR_X, SHEAR_Y);
        $finish;
    end
endmodule
