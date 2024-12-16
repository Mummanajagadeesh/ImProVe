module image_cropping(
    input clk
);
    parameter ROWS = 512;         // Original image height
    parameter COLS = 512;         // Original image width
    parameter CROP_X1 = 100;      // Top-left x-coordinate of cropping area
    parameter CROP_Y1 = 100;      // Top-left y-coordinate of cropping area
    parameter CROP_X2 = 200;      // Bottom-right x-coordinate of cropping area
    parameter CROP_Y2 = 200;      // Bottom-right y-coordinate of cropping area

    integer input_file, output_file, status;
    integer i, j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1]; // Original image pixel data
    reg [7:0] cropped_pixel_data [0:2047][0:2047]; // Cropped image pixel data
    reg [7:0] temp_data;

    integer crop_rows, crop_cols;

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

        // Calculate dimensions of the cropped area
        crop_rows = CROP_Y2 - CROP_Y1 + 1;
        crop_cols = CROP_X2 - CROP_X1 + 1;

        // Initialize the cropped image data to 0
        for (i = 0; i < crop_rows; i = i + 1) begin
            for (j = 0; j < crop_cols; j = j + 1) begin
                cropped_pixel_data[i][j] = 0;
            end
        end

        // Perform cropping
        for (i = 0; i < crop_rows; i = i + 1) begin
            for (j = 0; j < crop_cols; j = j + 1) begin
                cropped_pixel_data[i][j] = pixel_data[CROP_Y1 + i][CROP_X1 + j];
            end
        end

        // Open output file
        output_file = $fopen("lena_crop_b.txt", "w");
        if (output_file == 0) begin
            $display("Error opening cropped_image.txt.");
            $finish;
        end

        // Write cropped pixel data to the output file
        for (i = 0; i < crop_rows; i = i + 1) begin
            for (j = 0; j < crop_cols; j = j + 1) begin
                if (j == crop_cols-1) begin
                    $fwrite(output_file, "%0d", cropped_pixel_data[i][j]);
                end else begin
                    $fwrite(output_file, "%0d ", cropped_pixel_data[i][j]);
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Image cropping completed with coordinates (%0d, %0d) to (%0d, %0d).", CROP_X1, CROP_Y1, CROP_X2, CROP_Y2);
        $finish;
    end
endmodule
