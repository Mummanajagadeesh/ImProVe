# Prewitt Operator in Edge Detection

The Prewitt operator is a discrete differentiation operator used in edge detection. It is based on convolving an image with a pair of kernels (masks) to compute the gradient in the horizontal and vertical directions. These gradients provide information about the rate of change in intensity at each pixel, which helps in detecting edges.

## Mathematical Definition

The Prewitt operator uses two kernels to approximate the gradient of an image in the horizontal and vertical directions. The horizontal and vertical masks are defined as follows:

For the vertical mask, \( G_y \):

$$
G_y = \begin{bmatrix}
-1 & 0 & 1 \\
-1 & 0 & 1 \\
-1 & 0 & 1
\end{bmatrix}
$$

For the horizontal mask, \( G_x \):

$$
G_x = \begin{bmatrix}
-1 & -1 & -1 \\
 0 &  0 &  0 \\
 1 &  1 &  1
\end{bmatrix}
$$

Where:
- The vertical mask detects edges that are aligned vertically (up-down).
- The horizontal mask detects edges that are aligned horizontally (left-right).

## Process of Edge Detection

1. **Apply Convolution**: The Prewitt operator is applied to the image by convolving the image with the masks. For each pixel in the image, the neighborhood around it is multiplied by the kernel, and the results are summed up. This results in two images: one for the vertical gradient (\( G_y \)) and one for the horizontal gradient (\( G_x \)).

2. **Magnitude Calculation**: The magnitude of the gradient at each pixel is computed by combining the results of the horizontal and vertical gradients:

$$
G = \sqrt{G_x^2 + G_y^2}
$$

3. **Thresholding**: To identify the edges, the magnitude is thresholded. Pixels with gradients above a certain threshold are considered part of the edge, while others are discarded.

---

## New Steps Added

### Combined Prewitt Operator (Fixed Threshold)

In this approach, we combine the magnitudes from both the vertical and horizontal gradients to determine the edge strength at each pixel. The combined edge strength is then truncated to a maximum value of 255 (fixed-point threshold). This ensures that any values above 255 are capped.

1. **Magnitude Calculation**: The combined magnitude is calculated as:

$$
Edge_{strength} = \sqrt{G_x^2 + G_y^2}
$$

2. **Truncation**: If the calculated edge strength exceeds 255, it is set to 255.

3. **Output**: The final image is generated using the truncated edge strengths.

**Code Files:**
- **prewitt.v**: This Verilog code calculates the combined edge strength and truncates values above 255.
- **Output Files**: 
  - `output_image_combined.jpg`: This is the resulting image after applying the combined Prewitt operator and thresholding.
  - `output_image_combined.txt`: The raw binary data of the processed image.

---

### Dynamic Normalization

In this process, we normalize the edge strength by dividing each pixel’s edge strength by the maximum edge strength in the image and then scaling it to fit within the range of 0 to 255. This ensures that the maximum edge strength is 255.

1. **Edge Strength Normalization**: 

$$
Edge_{norm} = \frac{Edge_{strength}}{Max_{value}} \times 255
$$

2. **Output**: The final image is generated after normalizing the edge strengths.

**Code Files:**
- **prewitt-dynamic.v**: This Verilog code calculates the edge strengths and applies dynamic normalization.
- **Output Files**:
  - `output_image_combined_dynamic.jpg`: The resulting image after applying dynamic normalization.
  - `output_image_combined_dynamic.txt`: The raw binary data of the normalized image.


---

## Implementation

This implementation is done using **Icarus Verilog 12.0** for the hardware description and **Python 3.12.1** for the image processing and visualization. 

- The Verilog code performs the convolution of the Prewitt masks with the input image and calculates the combined edge strength.
- The Python code handles the image processing, including loading, applying the convolution, truncation, normalization, and visualizing the results.

### Code Flow

The following is a step-by-step breakdown of the process using different code files:

1. **img2bin.py** – Converts the input image (in `.jpg` format) into a binary `.txt` format for further processing. The input image should already be in black-and-white (BW); if not, it must be converted beforehand.
   - **Input**: `input_image.jpg`
   - **Output**: `input_image.txt`

2. **prewitt-ver.v** – Implements the vertical Prewitt operator. This Verilog file reads the binary image and applies the vertical Prewitt mask.
   - **Input**: `input_image.txt`
   - **Output**: `output_image_ver.txt`

3. **prewitt-hor.v** – Implements the horizontal Prewitt operator. This Verilog file reads the binary image and applies the horizontal Prewitt mask.
   - **Input**: `input_image.txt`
   - **Output**: `output_image_hor.txt`

4. **prewitt.v** – Implements the combined Prewitt operator, where the edge strength is calculated and truncated to 255.
   - **Input**: `input_image.txt`
   - **Output**: `output_image_combined.txt`

5. **prewitt-dynamic.v** – Implements the dynamic normalization of edge strength.
   - **Input**: `input_image.txt`
   - **Output**: `output_image_combined_dynamic.txt`

6. **bin2img.py** – Converts the binary `.txt` files (output from the Verilog simulations) back into `.jpg` images.
   - **bin2img.py** – Converts `output_image_combined.txt` to `output_image_combined.jpg`.
   - **bin2img.py** – Converts `output_image_combined_dynamic.txt` to `output_image_combined_dynamic.jpg`.

### Execution Steps

The following steps are executed in sequence to complete the edge detection process:

1. **Convert Image to Binary (img2bin.py)**

   ```bash
   python .\img2bin.py
   ```

   Converts the input image (`input_image.jpg`) to the binary file format (`input_image.txt`).

2. **Vertical Prewitt Operation (prewitt-ver.v)**

   ```bash
   iverilog -o prewitt-v .\prewitt-ver.v
   vvp .\prewitt-v
   ```

   The Verilog code (`prewitt-ver.v`) is compiled using `iverilog` to create the executable `prewitt-v`. The `vvp` command runs the simulation, generating `output_image_ver.txt`.

3. **Horizontal Prewitt Operation (prewitt-hor.v)**

   ```bash
   iverilog -o prewitt-h .\prewitt-hor.v
   vvp .\prewitt-h
   ```

   The Verilog code (`prewitt-hor.v`) is compiled to create the executable `prewitt-h`. The `vvp` command generates `output_image_hor.txt`.

4. **Combined Prewitt (prewitt.v)**

   ```bash
   iverilog -o prewitt .\prewitt.v
   vvp .\prewitt
   ```

   This Verilog code applies the combined Prewitt operator and generates `output_image_combined.txt`.

5. **Dynamic Normalization (prewitt-dynamic.v)**

   ```bash
   iverilog -o prewitt-dynamic .\prewitt-dynamic.v
   vvp .\prewitt-dynamic
   ```

   This Verilog code applies dynamic normalization and generates `output_image_combined_dynamic.txt`.

6. **Convert Binary Outputs to Images**

   ```bash
   python .\bin2img.py
   ```

   Converts `output_image_combined.txt` and `output_image_combined_dynamic.txt` to `.jpg` images.

---

### Vertical Gradient Detection
The following images show the input image and the output image after applying the vertical Prewitt mask.

![Input Image](input_image.jpg) ![Vertical Gradient Output](output_image_ver.jpg)

### Horizontal Gradient Detection
The following images show the input image and the output image after applying the horizontal Prewitt mask.

![Input Image](input_image.jpg) ![Horizontal Gradient Output](output_image_hor.jpg)

### Combined Prewitt Edge Detection (Fixed Threshold)
The following image shows the input image and the output image after applying the combined Prewitt operator with fixed threshold truncation.

![Input Image](input_image.jpg) ![Combined Prewitt Output](output_image_combined.jpg)

### Dynamic Normalization of Edge Detection
The following image shows the input image and the output image after applying dynamic normalization to the combined Prewitt operator.

![Input Image](input_image.jpg) ![Dynamic Normalized Output](output_image_combined_dynamic.jpg)
