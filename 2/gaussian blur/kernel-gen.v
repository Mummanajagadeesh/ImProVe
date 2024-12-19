module gaussian_blur;
    // Parameters for image dimensions and kernel size
    parameter integer IMG_WIDTH = 247;  // Width of the image (modify as needed)
    parameter integer IMG_HEIGHT = 242; // Height of the image (modify as needed)
    parameter integer KERNEL_SIZE = 3;  // Gaussian kernel size (3x3)

    // Gaussian kernel coefficients (3x3 normalized) - hardcoded as Verilog does not support real arrays as parameters
    real GAUSSIAN_KERNEL[0:2][0:2];
    
    // File handles
    integer input_file, output_file;
    integer i, j, m, n, idx;

    // Memory to hold the image and result
    reg [7:0] image[0:IMG_HEIGHT-1][0:IMG_WIDTH-1];
    real blurred_image[0:IMG_HEIGHT-1][0:IMG_WIDTH-1];

    // Temporary storage for pixel value and sum
    real pixel_sum;
    reg [7:0] temp_pixel;

    initial begin
        // Initialize the Gaussian kernel
        GAUSSIAN_KERNEL[0][0] = 0.0625; GAUSSIAN_KERNEL[0][1] = 0.125;  GAUSSIAN_KERNEL[0][2] = 0.0625;
        GAUSSIAN_KERNEL[1][0] = 0.125;  GAUSSIAN_KERNEL[1][1] = 0.25;   GAUSSIAN_KERNEL[1][2] = 0.125;
        GAUSSIAN_KERNEL[2][0] = 0.0625; GAUSSIAN_KERNEL[2][1] = 0.125;  GAUSSIAN_KERNEL[2][2] = 0.0625;

        // Open input and output files
        input_file = $fopen("input_image.txt", "r");
        output_file = $fopen("output_image.txt", "w");

        // Check if files are opened successfully
        if (input_file == 0) begin
            $display("Error: Cannot open input_image.txt");
            $finish;
        end

        if (output_file == 0) begin
            $display("Error: Cannot open output_image.txt");
            $finish;
        end

        // Read the input image into memory
        for (i = 0; i < IMG_HEIGHT; i = i + 1) begin
            for (j = 0; j < IMG_WIDTH; j = j + 1) begin
                idx = $fscanf(input_file, "%d", temp_pixel);
                image[i][j] = temp_pixel;
            end
        end

        // Apply Gaussian blur
        for (i = 1; i < IMG_HEIGHT-1; i = i + 1) begin
            for (j = 1; j < IMG_WIDTH-1; j = j + 1) begin
                pixel_sum = 0.0;
                // Convolve with the Gaussian kernel
                for (m = 0; m < KERNEL_SIZE; m = m + 1) begin
                    for (n = 0; n < KERNEL_SIZE; n = n + 1) begin
                        pixel_sum = pixel_sum + image[i+m-1][j+n-1] * GAUSSIAN_KERNEL[m][n];
                    end
                end
                // Store the blurred value
                blurred_image[i][j] = pixel_sum;
            end
        end

        // Write the blurred image to the output file
        for (i = 0; i < IMG_HEIGHT; i = i + 1) begin
            for (j = 0; j < IMG_WIDTH; j = j + 1) begin
                $fwrite(output_file, "%d", $rtoi(blurred_image[i][j]));
                if (j < IMG_WIDTH-1) $fwrite(output_file, " "); // Add space between pixels
            end
            $fwrite(output_file, "\n"); // Add a newline at the end of each row
        end

        // Close the files
        $fclose(input_file);
        $fclose(output_file);

        $display("Gaussian blur completed. Output written to output_image.txt");
        $finish;
    end
endmodule
