module image_reflection(
    input clk
);
    parameter ROWS = 512;         // Original image height
    parameter COLS = 512;         // Original image width
    parameter REFLECT_MODE = 10;  // Reflection mode: 01 for vertical, 10 for horizontal

    integer input_file, output_file, status;
    integer i, j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1]; // Original image pixel data
    reg [7:0] reflected_pixel_data [0:ROWS-1][0:COLS-1]; // Reflected image pixel data
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

        // Initialize the reflected image data to 0
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                reflected_pixel_data[i][j] = 0;
            end
        end

        // Perform reflection based on REFLECT_MODE
        if (REFLECT_MODE == 01) begin
            // Vertical reflection
            for (i = 0; i < ROWS; i = i + 1) begin
                for (j = 0; j < COLS; j = j + 1) begin
                    reflected_pixel_data[i][j] = pixel_data[ROWS-1-i][j];
                end
            end
        end else if (REFLECT_MODE == 10) begin
            // Horizontal reflection
            for (i = 0; i < ROWS; i = i + 1) begin
                for (j = 0; j < COLS; j = j + 1) begin
                    reflected_pixel_data[i][j] = pixel_data[i][COLS-1-j];
                end
            end
        end else begin
            $display("Invalid REFLECT_MODE. Use 01 for vertical or 10 for horizontal reflection.");
            $finish;
        end

        // Open output file
        output_file = $fopen("lena_hor_b.txt", "w");
        if (output_file == 0) begin
            $display("Error opening reflected_image.txt.");
            $finish;
        end

        // Write reflected pixel data to the output file
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (j == COLS-1) begin
                    $fwrite(output_file, "%0d", reflected_pixel_data[i][j]);
                end else begin
                    $fwrite(output_file, "%0d ", reflected_pixel_data[i][j]);
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Image reflection completed with REFLECT_MODE = %0d.", REFLECT_MODE);
        $finish;
    end
endmodule
