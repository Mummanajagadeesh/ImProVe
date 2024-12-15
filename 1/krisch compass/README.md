# Krisch Compass Edge Detection
The Krisch Compass is an edge detection technique that also uses eight compass directions (North, South, East, West, Northwest, Northeast, Southwest, Southeast) to detect edges in an image. This method is similar to the Robinson Compass, but it employs different kernels, designed to highlight edges in a more refined manner by detecting changes in pixel intensity across various orientations. The directionality of the kernels allows the detection of edges in all the compass directions, making it particularly effective for capturing edges in images where the orientation may vary.

## What is the Krisch Compass Edge Detection?
The Krisch Compass edge detection method is an extension of the concept of directional edge detection, which uses eight different kernels corresponding to compass directions to identify edges at multiple orientations. The key difference between the Krisch Compass and other edge detection methods (like the Sobel or Prewitt operators) is its use of eight directional kernels that highlight edges in a variety of orientations, giving it the ability to detect fine details and nuanced changes in the image's structure.

This method is useful when you want to detect edges in images where orientation and finer directional differences matter. It is commonly used in applications such as texture segmentation, pattern recognition, and when working with images that contain edges at various angles or in non-rectangular orientations.

By convolving each of these eight kernels with the image, the Krisch Compass can detect edge information from multiple directions. This allows for comprehensive edge detection, which can be particularly useful when analyzing images where edge directionality plays an important role in the final analysis.

### Kernels for the Krisch Compass

The Krisch compass uses the following 8 kernels for edge detection:

**N (North)**:

$$
\begin{bmatrix}
-3 & -3 & 5 \\
-3 & 0 & 5 \\
-3 & -3 & 5
\end{bmatrix}
$$

**S (South)**:

$$
\begin{bmatrix}
-3 & -3 & -3 \\
-3 & 0 & 5 \\
-3 & 5 & 5
\end{bmatrix}
$$

**E (East)**:

$$
\begin{bmatrix}
-3 & -3 & -3 \\
-3 & 0 & 5 \\
-3 & 5 & 5
\end{bmatrix}
$$

**W (West)**:

$$
\begin{bmatrix}
-3 & -3 & -3 \\
-3 & 0 & 5 \\
-3 & 5 & 5
\end{bmatrix}
$$

**NW (Northwest)**:

$$
\begin{bmatrix}
-3 & -3 & 5 \\
-3 & 0 & 5 \\
-3 & -3 & 5
\end{bmatrix}
$$

**NE (Northeast)**:

$$
\begin{bmatrix}
-3 & -3 & 5 \\
-3 & 0 & 5 \\
-3 & -3 & 5
\end{bmatrix}
$$

**SW (Southwest)**:

$$
\begin{bmatrix}
-3 & -3 & 5 \\
-3 & 0 & 5 \\
-3 & -3 & 5
\end{bmatrix}
$$

**SE (Southeast)**:

$$
\begin{bmatrix}
-3 & -3 & -3 \\
-3 & 0 & 5 \\
-3 & 5 & 5
\end{bmatrix}
$$

---

### Process of Edge Detection

1. **Convolution**: The image is convolved with each of the eight kernels. This involves sliding each kernel over the image, multiplying the kernel values by the corresponding pixel values, and summing the results to compute a new value for each pixel.

2. **Thresholding**: After convolution, the resulting values are thresholded at 127 to produce a binary image. Any pixel value above 127 becomes 255 (white), and any pixel value below 127 becomes 0 (black), which highlights the edges detected in each direction.

3. **Edge Magnitude**: After applying all eight kernels, the magnitude of the edge in each direction is calculated. The final image may represent the edge magnitude in one direction, or the maximum gradient magnitude can be used to combine the information from all eight directions.

---

### Output Files

For each direction, we generate the following files:

1. **Image Files**: The output images for each direction after applying the Krisch compass kernels:
   - `output_image_X_kc.jpg` where X represents the direction (n, s, e, w, nw, ne, se, sw).

2. **Text Files**: The binary data for each processed image:
   - `output_image_X_kc.txt`, which contains the raw binary data.

For each direction, the image and text files will be saved:

- `output_image_n_kc.jpg`
- `output_image_s_kc.jpg`
- `output_image_e_kc.jpg`
- `output_image_w_kc.jpg`
- `output_image_nw_kc.jpg`
- `output_image_ne_kc.jpg`
- `output_image_sw_kc.jpg`
- `output_image_se_kc.jpg`

---

### Example Execution for One Direction (e.g., East)

1. **Convolution**: The East kernel (E) is applied to the image, resulting in edge detection for that direction.

2. **Thresholding**: The image is thresholded at 127 to produce a binary edge map.

3. **Output**: The resulting binary image is saved as `output_image_e_kc.jpg`, and the binary values are saved in `output_image_e_kc.txt`.

---

### Visual Output

The results of applying the Krisch compass kernels to the image are shown below. Each kernel highlights edges in a specific direction:

- **East Direction (E)**:

![Original](input_image.jpg) ![East Edge Detection](output_image_e_kc.jpg)

- **South Direction (S)**:

![Original](input_image.jpg) ![South Edge Detection](output_image_s_kc.jpg)

- **West Direction (W)**:

![Original](input_image.jpg) ![West Edge Detection](output_image_w_kc.jpg)

- **North Direction (N)**:

![Original](input_image.jpg) ![North Edge Detection](output_image_n_kc.jpg)

- **Northwest Direction (NW)**:

![Original](input_image.jpg) ![Northwest Edge Detection](output_image_nw_kc.jpg)

- **Northeast Direction (NE)**:

![Original](input_image.jpg) ![Northeast Edge Detection](output_image_ne_kc.jpg)

- **Southwest Direction (SW)**:

![Original](input_image.jpg) ![Southwest Edge Detection](output_image_sw_kc.jpg)

- **Southeast Direction (SE)**:

![Original](input_image.jpg) ![Southeast Edge Detection](output_image_se_kc.jpg)

---

### Binary Edge Detection (Threshold 127)

Additionally, the binary edge maps for each direction, after applying the 127 threshold to the gradient magnitudes, are provided. The file paths for each direction are as follows:

- **East Direction**: `output_image_e_kc.jpg`  
- **South Direction**: `output_image_s_kc.jpg`  
- **West Direction**: `output_image_w_kc.jpg`  
- **North Direction**: `output_image_n_kc.jpg`  
- **Northwest Direction**: `output_image_nw_kc.jpg`  
- **Northeast Direction**: `output_image_ne_kc.jpg`  
- **Southwest Direction**: `output_image_sw_kc.jpg`  
- **Southeast Direction**: `output_image_se_kc.jpg`

---

This implementation uses **Icarus Verilog 12.0** for hardware description and **Python 3.12.1** for image processing and visualization. The Verilog code performs the convolution of the Krisch compass kernels with the input image and calculates the edge strengths. Python handles the conversion between image formats, binary data handling, and visualization of the results.

### Execution Steps

1. **Convert Image to Binary** (img2bin.py)
2. **Apply Krisch Compass Kernels** using Verilog
3. **Thresholding and Magnitude Calculation** 
4. **Convert Binary Outputs to Images** (bin2img.py)
