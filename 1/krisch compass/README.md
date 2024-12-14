# Robinson Compass Edge Detection

The Robinson compass is an edge detection method that uses eight compass directions (N, S, E, W, NW, NE, SW, SE) to detect edges in an image. This method highlights directional changes in pixel intensity, which is key to identifying edges. Each direction is associated with a unique kernel, and the image is convolved with these kernels to detect edges in the corresponding direction.

In this implementation, we apply these eight kernels to a binary image with a threshold of 127. The resulting edge information is then saved in both text and image formats.

## Kernels for the Robinson Compass

The Robinson compass uses the following 8 kernels for edge detection:



It seems like the issue with the LaTeX rendering is specific to how the non-North direction masks are written or how your Markdown renderer handles them. The North mask is rendering correctly, so the issue might be related to inconsistencies in the other matrix definitions.

Here's a potential fix for the LaTeX sections:

1. Ensure uniform formatting for all matrices.
2. Remove unnecessary blank spaces or incorrect characters.
3. Make sure the Markdown renderer supports LaTeX and the correct syntax is being used.

Here’s the corrected version of the kernel definitions for all directions:


## Kernels for the Robinson Compass

The Robinson compass uses the following 8 kernels for edge detection:

**N (North)**:

  $$
  \begin{bmatrix}
  -1 & 0 & 1 \\
  -2 & 0 & 2 \\
  -1 & 0 & 1
  \end{bmatrix}
  $$

**S (South)**:

  $$
  \begin{bmatrix}
  1 & 0 & -1 \\
  2 & 0 & -2 \\
  1 & 0 & -1
  \end{bmatrix}
  $$

**E (East)**:

  $$
  \begin{bmatrix}
  1 & 2 & 1 \\
  0 & 0 & 0 \\
  -1 & -2 & -1
  \end{bmatrix}
  $$

**W (West)**:

  $$
  \begin{bmatrix}
  -1 & -2 & -1 \\
  0 & 0 & 0 \\
  1 & 2 & 1
  \end{bmatrix}
  $$

**NW (Northwest)**:

  $$
  \begin{bmatrix}
  0 & 1 & 2 \\
  -1 & 0 & 1 \\
  -2 & -1 & 0
  \end{bmatrix}
  $$

**NE (Northeast)**:

  $$
  \begin{bmatrix}
  2 & 1 & 0 \\
  1 & 0 & -1 \\
  0 & -1 & -2
  \end{bmatrix}
  $$

**SW (Southwest)**:

  $$
  \begin{bmatrix}
  0 & -1 & -2 \\
  1 & 0 & -1 \\
  2 & 1 & 0
  \end{bmatrix}
  $$

**SE (Southeast)**:

  $$
  \begin{bmatrix}
  -2 & -1 & 0 \\
  -1 & 0 & 1 \\
  0 & 1 & 2
  \end{bmatrix}
  $$



### Recommendations:

1. Test your Markdown file on a renderer that fully supports LaTeX (like GitHub, Jupyter Notebook, or Pandoc).
2. If you're embedding the Markdown in a larger HTML file or a specific Markdown parser, verify that MathJax or KaTeX is properly configured to render LaTeX equations.

Let me know if you continue to face issues, and I can assist further!


These eight kernels correspond to the directions: North, South, East, West, Northwest, Northeast, Southwest, and Southeast.

---

## Process of Edge Detection

1. **Convolution**: The image is convolved with each of the eight kernels. This involves sliding each kernel over the image, multiplying the kernel values by the corresponding pixel values, and summing the results to compute a new value for each pixel.

2. **Thresholding**: After convolution, the resulting values are thresholded at 127 to produce a binary image. Any pixel value above 127 becomes 255 (white), and any pixel value below 127 becomes 0 (black), which highlights the edges detected in each direction.

3. **Edge Magnitude**: After applying all eight kernels, the magnitude of the edge in each direction is calculated. The final image may represent the edge magnitude in one direction, or the maximum gradient magnitude can be used to combine the information from all eight directions.

---

### Output Files

For each direction, we generate the following files:

1. **Image Files**: The output images for each direction after applying the Robinson compass kernels:
   - `output_image_X_rc.jpg` where X represents the direction (n, s, e, w, nw, ne, se, sw).

2. **Text Files**: The binary data for each processed image:
   - `output_image_X_rc.txt`, which contains the raw binary data.

For each direction, the image and text files will be saved:

- `output_image_n_rc.jpg`
- `output_image_s_rc.jpg`
- `output_image_e_rc.jpg`
- `output_image_w_rc.jpg`
- `output_image_nw_rc.jpg`
- `output_image_ne_rc.jpg`
- `output_image_sw_rc.jpg`
- `output_image_se_rc.jpg`

---

### Example Execution for One Direction (e.g., East)

1. **Convolution**: The East kernel (E) is applied to the image, resulting in edge detection for that direction.

2. **Thresholding**: The image is thresholded at 127 to produce a binary edge map.

3. **Output**: The resulting binary image is saved as `output_image_e_rc.jpg`, and the binary values are saved in `output_image_e_rc.txt`.

---

### Visual Output

The results of applying the Robinson compass kernels to the image are shown below. Each kernel highlights edges in a specific direction:

- **East Direction (E)**:

![Original](input_image.jpg) ![East Edge Detection](output_image_e_rc.jpg)

- **South Direction (S)**:

![Original](input_image.jpg) ![South Edge Detection](output_image_s_rc.jpg)

- **West Direction (W)**:

![Original](input_image.jpg) ![West Edge Detection](output_image_w_rc.jpg)

- **North Direction (N)**:

![Original](input_image.jpg) ![North Edge Detection](output_image_n_rc.jpg)

- **Northwest Direction (NW)**:

![Original](input_image.jpg) ![Northwest Edge Detection](output_image_nw_rc.jpg)

- **Northeast Direction (NE)**:

![Original](input_image.jpg) ![Northeast Edge Detection](output_image_ne_rc.jpg)

- **Southwest Direction (SW)**:

![Original](input_image.jpg) ![Southwest Edge Detection](output_image_sw_rc.jpg)

- **Southeast Direction (SE)**:

![Original](input_image.jpg) ![Southeast Edge Detection](output_image_se_rc.jpg)

---

### Binary Edge Detection (Threshold 127)

Additionally, the binary edge maps for each direction, after applying the 127 threshold to the gradient magnitudes, are provided. The file paths for each direction are as follows:

- **East Direction**: `output_image_e_rc.jpg`  
- **South Direction**: `output_image_s_rc.jpg`  
- **West Direction**: `output_image_w_rc.jpg`  
- **North Direction**: `output_image_n_rc.jpg`  
- **Northwest Direction**: `output_image_nw_rc.jpg`  
- **Northeast Direction**: `output_image_ne_rc.jpg`  
- **Southwest Direction**: `output_image_sw_rc.jpg`  
- **Southeast Direction**: `output_image_se_rc.jpg`

---

This implementation uses **Icarus Verilog 12.0** for hardware description and **Python 3.12.1** for image processing and visualization. The Verilog code performs the convolution of the Robinson compass kernels with the input image and calculates the edge strengths. Python handles the conversion between image formats, binary data handling, and visualization of the results.

### Execution Steps

1. **Convert Image to Binary** (img2bin.py)
2. **Apply Robinson Compass Kernels** using Verilog
3. **Thresholding and Magnitude Calculation** 
4. **Convert Binary Outputs to Images** (bin2img.py)

