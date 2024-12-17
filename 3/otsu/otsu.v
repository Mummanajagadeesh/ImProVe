module otsu_threshold;

  // File Handles
  integer input_file, output_file;
  integer scan_status;  // File scan status
  integer i, j;

  // Image Parameters
  parameter WIDTH = 512;   // Image width
  parameter HEIGHT = 512;  // Image height
  parameter MAX_INTENSITY = 255;

  reg [7:0] image_data[0:WIDTH*HEIGHT-1]; // 8-bit grayscale image
  reg [31:0] histogram[0:MAX_INTENSITY];  // Histogram for intensity levels
  reg [7:0] threshold;                    // Calculated threshold value
  
  // Variables for Otsu's Method
  real weight_bg, weight_fg;              // Background and foreground weights
  real mean_bg, mean_fg;                  // Means for background and foreground
  real variance, max_variance;            // Variance for Otsu's threshold
  integer total_pixels, sum_intensity, pixel_count;

  initial begin
    // Initialize histogram
    for (i = 0; i <= MAX_INTENSITY; i = i + 1)
      histogram[i] = 0;

    // Open input image file
    input_file = $fopen("lena_b.txt", "r");
    if (input_file == 0) begin
      $display("Error: Cannot open input file.");
      $finish;
    end
    
    // Read input file data into image_data
    i = 0;
    while (!$feof(input_file) && i < WIDTH*HEIGHT) begin
      scan_status = $fscanf(input_file, "%d", image_data[i]);
      if (scan_status != 1) begin
        $display("Error: Invalid file format.");
        $finish;
      end
      i = i + 1;
    end
    total_pixels = i;
    $fclose(input_file);
    
    // Step 1: Calculate Histogram
    for (i = 0; i < total_pixels; i = i + 1) begin
      histogram[image_data[i]] = histogram[image_data[i]] + 1;
    end

    // Step 2: Otsu's Method - Calculate Threshold
    threshold = 0;
    max_variance = 0.0;  // Start with zero variance
    
    sum_intensity = 0;
    for (i = 0; i <= MAX_INTENSITY; i = i + 1)
      sum_intensity = sum_intensity + i * histogram[i]; // Total intensity

    pixel_count = 0; // Number of background pixels so far
    for (j = 0; j <= MAX_INTENSITY; j = j + 1) begin
      pixel_count = pixel_count + histogram[j]; // Cumulative background pixels
      
      if (pixel_count == 0 || pixel_count == total_pixels) begin
        // Skip invalid cases (no operation)
      end else begin
        weight_bg = pixel_count * 1.0 / total_pixels;
        weight_fg = 1.0 - weight_bg;

        mean_bg = 0;
        mean_fg = 0;

        // Compute means for background and foreground
        for (i = 0; i <= j; i = i + 1)
          mean_bg = mean_bg + i * histogram[i];
        mean_bg = mean_bg / pixel_count;

        for (i = j + 1; i <= MAX_INTENSITY; i = i + 1)
          mean_fg = mean_fg + i * histogram[i];
        mean_fg = mean_fg / (total_pixels - pixel_count);

        // Compute intra-class variance
        variance = weight_bg * weight_fg * (mean_bg - mean_fg) * (mean_bg - mean_fg);

        // Check for maximum variance
        if (variance > max_variance) begin
          max_variance = variance;
          threshold = j;
        end
      end
    end

    $display("Calculated Threshold: %d", threshold);

    // Step 3: Apply Threshold and Write to Output File
    output_file = $fopen("lena_otsu_b.txt", "w");
    if (output_file == 0) begin
      $display("Error: Cannot open output file.");
      $finish;
    end

    for (i = 0; i < HEIGHT; i = i + 1) begin
      for (j = 0; j < WIDTH; j = j + 1) begin
        if (image_data[i*WIDTH + j] > threshold)
          $fwrite(output_file, "255 ");  // Foreground (white)
        else
          $fwrite(output_file, "0 ");    // Background (black)
      end
      $fwrite(output_file, "\n");  // Newline for each row
    end
    $fclose(output_file);

    $display("Thresholding complete. Output saved to output_image.txt.");
    $finish;
  end

endmodule
