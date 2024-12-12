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

## Implementation

This implementation is done using **Icarus Verilog 12.0** for the hardware description and **Python 3.12.1** for the image processing and visualization. 

- The Verilog code performs the convolution of the Prewitt masks with the input image.
- The Python code handles the image processing, including loading, applying the convolution, and visualizing the results.

### Code Flow

1. **Image Input**: The input image is loaded in Python using libraries like OpenCV or PIL.
2. **Convolution**: In Verilog, the image data is processed with the Prewitt kernels for both vertical and horizontal masks.
3. **Edge Magnitude Calculation**: The magnitude of the gradient is computed and output as the edge-detected image.
4. **Visualization**: The result is visualized as the edge-detected image, showing the identified edges clearly.

### Python Scripts

#### img2bin.py
This script converts the input image (in JPG format) to a binary format (if it is not already in black and white). The input is a grayscale image, and the output is a `.txt` file that stores the pixel data in binary.

**Input**: `input_image.jpg`  
**Output**: `input_image.txt`

Command to run:
```bash
python img2bin.py input_image.jpg input_image.txt
```

#### Verilog Code for Prewitt

##### prewitt-ver.v (Vertical Prewitt)
This Verilog module implements the vertical Prewitt edge detection filter. The input is a binary representation of the image, and the output is the edge-detected result after applying the vertical Prewitt mask.

**Input**: `input_image.txt`  
**Output**: `output_image_ver.txt`

Command to run:
```bash
iverilog -o prewitt-ver.out prewitt-ver.v
vvp prewitt-ver.out
```

##### prewitt-hor.v (Horizontal Prewitt)
This Verilog module implements the horizontal Prewitt edge detection filter. The input is a binary representation of the image, and the output is the edge-detected result after applying the horizontal Prewitt mask.

**Input**: `input_image.txt`  
**Output**: `output_image_hor.txt`

Command to run:
```bash
iverilog -o prewitt-hor.out prewitt-hor.v
vvp prewitt-hor.out
```

#### Intermediate Files
Both `prewitt-ver.v` and `prewitt-hor.v` generate intermediate `.txt` files. These files store the result of applying the respective Prewitt masks (vertical or horizontal). The next step is to convert these text files back to images using Python scripts.

### Converting .txt to .jpg

#### bin2imghor.py
This Python script takes the output of the horizontal Prewitt operation (`output_image_hor.txt`) and converts it back into a `.jpg` image for visualization.

**Input**: `output_image_hor.txt`  
**Output**: `output_image_hor.jpg`

Command to run:
```bash
python bin2imghor.py output_image_hor.txt output_image_hor.jpg
```

#### bin2imgver.py
This Python script takes the output of the vertical Prewitt operation (`output_image_ver.txt`) and converts it back into a `.jpg` image for visualization.

**Input**: `output_image_ver.txt`  
**Output**: `output_image_ver.jpg`

Command to run:
```bash
python bin2imgver.py output_image_ver.txt output_image_ver.jpg
```

### Example Images

#### Vertical Gradient Detection
The following images show the input image and the output image after applying the vertical Prewitt mask.

![Input Image](input_image.jpg) ![Vertical Gradient Output](output_image_ver.jpg)

#### Horizontal Gradient Detection
The following images show the input image and the output image after applying the horizontal Prewitt mask.

![Input Image](input_image.jpg) ![Horizontal Gradient Output](output_image_hor.jpg)

