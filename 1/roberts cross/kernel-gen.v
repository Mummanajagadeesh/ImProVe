module general_kernel_application(
    input clk
);
    parameter ROWS = 512;  // Number of rows in the input image
    parameter COLS = 512;  // Number of columns in the input image
    parameter K_ROWS = 2;  // Number of rows in the kernel
    parameter K_COLS = 2;  // Number of columns in the kernel

    integer input_file, kernel_file, output_file, status;
    integer i, j, ki, kj;

    reg signed [7:0] pixel_data [0:ROWS-1][0:COLS-1];     // Input image pixels
    reg signed [7:0] kernel_data [0:K_ROWS-1][0:K_COLS-1]; // Kernel values
    reg signed [15:0] result_pixel_data [0:ROWS-1][0:COLS-1]; // Resulting image
    reg signed [15:0] normalized_pixel_data [0:ROWS-1][0:COLS-1]; // Normalized result
    reg signed [7:0] temp_data;   // Temporary variable for reading input
    reg signed [7:0] kernel_value; // Temporary variable for kernel values
    reg signed [15:0] sum;        // Accumulator for kernel application

    integer k_center_row = K_ROWS >> 1; // Kernel center row
    integer k_center_col = K_COLS >> 1; // Kernel center column

    initial begin
        // Read input image
        input_file = $fopen("input_image.txt", "r");
        if (input_file == 0) begin
            $display("Error: Cannot open input_image.txt.");
            $finish;
        end

        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                status = $fscanf(input_file, "%d", temp_data);
                if (status != 1) begin
                    $display("Error: Unable to read pixel data at (%0d, %0d).", i, j);
                    $finish;
                end
                pixel_data[i][j] = temp_data;
            end
        end
        $fclose(input_file);

        // Read kernel data
        kernel_file = $fopen("neg-roberts-cross-kernel.txt", "r");
        if (kernel_file == 0) begin
            $display("Error: Cannot open kernel.txt.");
            $finish;
        end

        for (ki = 0; ki < K_ROWS; ki = ki + 1) begin
            for (kj = 0; kj < K_COLS; kj = kj + 1) begin
                status = $fscanf(kernel_file, "%d", kernel_value);
                if (status != 1) begin
                    $display("Error: Unable to read kernel data at (%0d, %0d).", ki, kj);
                    $finish;
                end
                kernel_data[ki][kj] = kernel_value;
            end
        end
        $fclose(kernel_file);

        // Apply kernel to image
        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (i < k_center_row || i >= ROWS - k_center_row || 
                    j < k_center_col || j >= COLS - k_center_col) begin
                    // Boundary pixels are set to 0 (zero-padding)
                    result_pixel_data[i][j] = 0;
                end else begin
                    sum = 0;
                    for (ki = 0; ki < K_ROWS; ki = ki + 1) begin
                        for (kj = 0; kj < K_COLS; kj = kj + 1) begin
                            sum = sum + pixel_data[i - k_center_row + ki][j - k_center_col + kj] * kernel_data[ki][kj];
                        end
                    end
                    // Clamp result to 8-bit range and normalize
                    sum = sum < 0 ? -sum : sum;  // Take absolute value for magnitude
                    if (sum > 255) begin
                        normalized_pixel_data[i][j] = 255;
                    end else begin
                        normalized_pixel_data[i][j] = sum;
                    end
                end
            end
        end

        // Write output image
        output_file = $fopen("lena_neg_rc.txt", "w");
        if (output_file == 0) begin
            $display("Error: Cannot open output_image_kernel_applied.txt.");
            $finish;
        end

        for (i = 0; i < ROWS; i = i + 1) begin
            for (j = 0; j < COLS; j = j + 1) begin
                if (j == COLS - 1) begin
                    $fwrite(output_file, "%0d", normalized_pixel_data[i][j]);
                end else begin
                    $fwrite(output_file, "%0d ", normalized_pixel_data[i][j]);
                end
            end
            $fwrite(output_file, "\n");
        end
        $fclose(output_file);

        $display("Kernel application completed successfully.");
        $finish;
    end
endmodule
