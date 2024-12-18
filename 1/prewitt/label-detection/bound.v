module boundary_box_detector;

  // Parameters for the image dimensions
  parameter ROWS = 500;
  parameter COLS = 500;

  // File handles
  integer input_file, output_file;

  // Memory for storing the input image
  reg [7:0] input_image [0:ROWS-1][0:COLS-1];
  reg output_image [0:ROWS-1][0:COLS-1];

  // Temporary variables
  integer row, col;
  integer temp_pixel;
  integer min_row, max_row, min_col, max_col;
  reg visited [0:ROWS-1][0:COLS-1];
  integer current_area, max_area;
  integer best_min_row, best_max_row, best_min_col, best_max_col;

  // Task for flood fill to find contours
  task flood_fill;
    input integer r, c;
    output integer area;
    integer stack [0:ROWS*COLS-1][1:0];
    integer sp, sr, sc;
    begin
      area = 0;
      sp = 0;
      stack[sp][0] = r;
      stack[sp][1] = c;
      sp = sp + 1;

      while (sp > 0) begin
        sp = sp - 1;
        sr = stack[sp][0];
        sc = stack[sp][1];

        if (sr >= 0 && sr < ROWS && sc >= 0 && sc < COLS && !visited[sr][sc] && input_image[sr][sc] > 8'd0) begin
          visited[sr][sc] = 1;
          area = area + 1;

          if (sr < min_row) min_row = sr;
          if (sr > max_row) max_row = sr;
          if (sc < min_col) min_col = sc;
          if (sc > max_col) max_col = sc;

          // Push neighbors onto the stack
          stack[sp][0] = sr - 1; stack[sp][1] = sc; sp = sp + 1;
          stack[sp][0] = sr + 1; stack[sp][1] = sc; sp = sp + 1;
          stack[sp][0] = sr; stack[sp][1] = sc - 1; sp = sp + 1;
          stack[sp][0] = sr; stack[sp][1] = sc + 1; sp = sp + 1;
        end
      end
    end
  endtask

  initial begin
    // Initialize output image and visited array
    for (row = 0; row < ROWS; row = row + 1) begin
      for (col = 0; col < COLS; col = col + 1) begin
        output_image[row][col] = 1'b0;
        visited[row][col] = 1'b0;
      end
    end

    // Open the input file
    input_file = $fopen("sumapp.txt", "r");
    if (input_file == 0) begin
      $display("Error: Cannot open input_image.txt");
      $finish;
    end

    // Read the input file into memory
    for (row = 0; row < ROWS; row = row + 1) begin
      for (col = 0; col < COLS; col = col + 1) begin
        if (!$fscanf(input_file, "%d", temp_pixel)) begin
          $display("Error: Input file is not properly formatted");
          $finish;
        end
        input_image[row][col] = temp_pixel[7:0];
      end
    end

    $fclose(input_file);

    // Find the largest contour
    max_area = 0;
    for (row = 0; row < ROWS; row = row + 1) begin
      for (col = 0; col < COLS; col = col + 1) begin
        if (!visited[row][col] && input_image[row][col] > 8'd0) begin
          min_row = ROWS; max_row = 0; min_col = COLS; max_col = 0;
          flood_fill(row, col, current_area);

          if (current_area > max_area) begin
            max_area = current_area;
            best_min_row = min_row;
            best_max_row = max_row;
            best_min_col = min_col;
            best_max_col = max_col;
          end
        end
      end
    end

    // Mark the bounding box for the largest contour
    for (col = best_min_col; col <= best_max_col; col = col + 1) begin
      output_image[best_min_row][col] = 1'b1;
      output_image[best_max_row][col] = 1'b1;
    end
    for (row = best_min_row; row <= best_max_row; row = row + 1) begin
      output_image[row][best_min_col] = 1'b1;
      output_image[row][best_max_col] = 1'b1;
    end

    // Open the output file
    output_file = $fopen("output_image.txt", "w");
    if (output_file == 0) begin
      $display("Error: Cannot open output_image.txt");
      $finish;
    end

    // Write the output image to the file
    for (row = 0; row < ROWS; row = row + 1) begin
      for (col = 0; col < COLS; col = col + 1) begin
        $fwrite(output_file, "%d", output_image[row][col] ? 255 : 0);
        if (col < COLS - 1) $fwrite(output_file, " ");
      end
      $fwrite(output_file, "\n");
    end

    $fclose(output_file);
    $display("Largest bounding box detection complete. Output written to output_image.txt");
  end
endmodule
