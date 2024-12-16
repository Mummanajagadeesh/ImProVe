module image_translation(
    input clk
);
    parameter ROWS = 512;         // Original image height
    parameter COLS = 512;         // Original image width
    parameter TRANSLATE_X = -50;   // Translation amount in X-direction (positive or negative)
    parameter TRANSLATE_Y = 40;   // Translation amount in Y-direction (positive or negative)

    integer input_file, output_file, status;
    integer i, j, translated_i, translated_j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1]; // Original image pixel data
    reg [7:0] translated_pixel_data [0:ROWS-1][0:COLS-1]; // Translated image pixel data
    reg [7:0] temp_data;

    initial begin
        // Open input file
        input_file = $fopen("lena_b.txt", "r");
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

        // Initialize the translated image data to 0 (black)
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                translated_pixel_data[i][j] = 0;
            end
        end

        // Perform translation transformation
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                // Calculate new translated coordinates
                translated_i = i + TRANSLATE_Y;
                translated_j = j + TRANSLATE_X;

                // Check if translated coordinates are within bounds of the original image size
                if (translated_i >= 0 && translated_i < ROWS && translated_j >= 0 && translated_j < COLS) begin
                    translated_pixel_data[translated_i][translated_j] = pixel_data[i][j];
                end
            end
        end

        // Open output file
        output_file = $fopen("lena_translate_b.txt", "w");
        if (output_file == 0) begin
            $display("Error opening translated_image.txt.");
            $finish;
        end

        // Write translated pixel data to the output file
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (j == COLS-1) begin
                    $fwrite(output_file, "%0d", translated_pixel_data[i][j]);
                end else begin
                    $fwrite(output_file, "%0d ", translated_pixel_data[i][j]);
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Image translation completed with TRANSLATE_X = %0d and TRANSLATE_Y = %0d.", TRANSLATE_X, TRANSLATE_Y);
        $finish;
    end
endmodule
