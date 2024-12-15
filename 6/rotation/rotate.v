module image_rotate(
    input clk
);
    parameter ROWS = 242;  
    parameter COLS = 247;  
    parameter ANGLE = 60; // Rotation angle in degrees

    integer input_file, output_file, status;
    integer i, j, new_i, new_j;
    reg [7:0] pixel_data [0:ROWS-1][0:COLS-1];
    reg [7:0] rotated_pixel_data [0:ROWS-1][0:COLS-1];
    reg [7:0] temp_data;  

    real rad_angle;  // Angle in radians
    real center_x, center_y;  // Center of the image
    real x_shifted, y_shifted;  // Shifted coordinates for rotation
    real rotated_x, rotated_y;  // Rotated coordinates

    initial begin
        rad_angle = ANGLE * 3.14159 / 180.0; // Convert angle to radians
        center_x = (COLS - 1) / 2.0;  // Center X-coordinate
        center_y = (ROWS - 1) / 2.0;  // Center Y-coordinate

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

        // Initialize the rotated image data to 0
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                rotated_pixel_data[i][j] = 0;
            end
        end

        // Perform rotation
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                // Translate pixel coordinates to origin (centered at 0,0)
                x_shifted = j - center_x;
                y_shifted = i - center_y;

                // Apply rotation matrix
                rotated_x = x_shifted * $cos(rad_angle) - y_shifted * $sin(rad_angle);
                rotated_y = x_shifted * $sin(rad_angle) + y_shifted * $cos(rad_angle);

                // Translate back to original image coordinates
                new_j = $rtoi(rotated_x + center_x);
                new_i = $rtoi(rotated_y + center_y);

                // Check if the new coordinates are within bounds
                if (new_i >= 0 && new_i < ROWS && new_j >= 0 && new_j < COLS) begin
                    rotated_pixel_data[new_i][new_j] = pixel_data[i][j];
                end
            end
        end

        // Open output file
        output_file = $fopen("output_image.txt", "w");
        if (output_file == 0) begin
            $display("Error opening output_image.txt.");
            $finish;
        end

        // Write rotated pixel data to the output file
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (j == COLS-1) begin
                    $fwrite(output_file, "%0d", rotated_pixel_data[i][j]); 
                end else begin
                    $fwrite(output_file, "%0d ", rotated_pixel_data[i][j]);  
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Image rotation completed by %0d degrees.", ANGLE);
        $finish;
    end
endmodule
