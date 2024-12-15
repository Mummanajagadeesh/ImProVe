# Roberts Cross Edge Detection
The Roberts Cross operator is an edge detection technique used to detect areas of rapid intensity change in an image. It is one of the earliest edge detection methods and operates by calculating the gradient in diagonal directions. This operator highlights edges effectively by using simple 2x2 convolution kernels, making it computationally efficient and suitable for basic edge detection tasks.

## What is the Roberts Cross Operator?
The Roberts Cross operator is a gradient-based edge detection method designed to identify edges by computing the approximate gradient magnitude at each pixel. Unlike other operators like Sobel or Prewitt, which detect gradients in horizontal and vertical directions, the Roberts Cross operator focuses on diagonal gradients. Its simplicity makes it well-suited for applications that require minimal computational resources or where real-time performance is essential.

This operator works best on grayscale images and is typically used for applications like shape detection, feature extraction, and image segmentation in computer vision and digital image processing. Due to its small kernel size, the Roberts Cross operator is particularly useful for detecting fine details or high-frequency components in images.

## Mathematical Definition

The Roberts Cross operator uses two 2x2 kernels to approximate the gradient of an image in diagonal directions.

For the positive diagonal mask \( G_x \):

$$
G_x = \begin{bmatrix}
 1 & 0 \\
 0 & -1
\end{bmatrix}
$$

For the negative diagonal mask \( G_y \):

$$
G_y = \begin{bmatrix}
 0 & 1 \\
 -1 & 0
\end{bmatrix}
$$

Where:
- The \( G_x \) mask detects edges along the positive diagonal (top-left to bottom-right).
- The \( G_y \) mask detects edges along the negative diagonal (top-right to bottom-left).

## Process of Edge Detection

1. **Apply Convolution**: The Roberts Cross operator is applied by convolving the image with the positive and negative diagonal masks. For each pixel, the surrounding neighborhood is multiplied by the kernel, and the results are summed up to create two gradient images: one for the positive diagonal gradient and one for the negative diagonal gradient.

2. **Magnitude Calculation**: The magnitude of the gradient at each pixel is calculated by combining the results of the positive and negative diagonal gradients:

$$
G = \sqrt{G_x^2 + G_y^2}
$$

3. **Thresholding**: To identify edges, the magnitude is thresholded. Pixels with gradients above a certain threshold are considered part of the edge, while others are discarded.

---

## Code Implementation

### Files and Functions

1. **combine.py** – This script processes both positive and negative mask images, finds the edge strength for each pixel, and generates the output images.
   - **Input**: `input_image.txt` (binary representation of the image)
   - **Output**: 
     - `output_image_pos_rc.jpg` (image with positive diagonal edges detected)
     - `output_image_neg_rc.jpg` (image with negative diagonal edges detected)
     - `output_image_combined.jpg` (combined result of both positive and negative edge detections)

2. **pos-roberts-kernel-kernel.txt** – Contains the positive mask for the Roberts Cross operator.
3. **neg-roberts-kernel-kernel.txt** – Contains the negative mask for the Roberts Cross operator.

### Process Flow

1. **Image Conversion to Binary**: 
   Convert the input image to a binary format for further processing.
   
   ```bash
   python img2bin.py input_image.jpg input_image.txt
   ```

2. **Apply Roberts Cross (Positive and Negative Masks)**:
   Run the convolution of the input image with the positive and negative masks to detect edges.

   - Positive Mask Application:
   ```bash
   python combine.py pos-roberts-kernel-kernel.txt input_image.txt output_image_pos_rc.jpg
   ```
   
   - Negative Mask Application:
   ```bash
   python combine.py neg-roberts-kernel-kernel.txt input_image.txt output_image_neg_rc.jpg
   ```

3. **Combine the Results**:
   Combine the positive and negative gradient images to create the final output.

   ```bash
   python combine.py combined input_image.txt output_image_combined.jpg
   ```

### Input and Output Files

- **Input Images**:
  - `input_image.jpg`: The original input image.
  
- **Output Images**:
  - `output_image_pos_rc.jpg`: Result after applying the positive Roberts Cross mask.
  - `output_image_neg_rc.jpg`: Result after applying the negative Roberts Cross mask.
  - `output_image_combined.jpg`: Final result after combining both positive and negative edge detections.

---

### Example Output Images

Here are the results from applying the Roberts Cross edge detection:

#### Positive Roberts Cross Edge Detection

![Input Image](input_image.jpg) ![Positive Roberts Cross Output](output_image_pos_rc.jpg)

#### Negative Roberts Cross Edge Detection

![Input Image](input_image.jpg) ![Negative Roberts Cross Output](output_image_neg_rc.jpg)

#### Combined Roberts Cross Edge Detection

![Input Image](input_image.jpg) ![Combined Roberts Cross Output](output_image_combined.jpg)

### Visual Comparison of Edge Detection

The following table shows the comparison between the original and edge-detected images for the Lena image:

| Original Image          | Positive Mask Output  | Negative Mask Output  | Combined Output       |
|-------------------------|-----------------------|-----------------------|-----------------------|
| ![Lena Original](lena_org.png) | ![Lena Pos RC](lena_pos_rc.jpg) | ![Lena Neg RC](lena_neg_rc.jpg) | ![Lena Combined](lena_combined.jpg) |

---

## Implementation

This implementation uses Python 3.12.1 for image processing and combines it with the `combine.py` script to compute edge strength using Roberts Cross masks. 

- **combine.py** reads the text file representations of images and applies convolution using the positive and negative masks for edge detection.
- The resulting edge images are saved and visualized for analysis.

### Steps to Run

1. **Convert Image to Binary**:
   ```bash
   python img2bin.py input_image.jpg input_image.txt
   ```

2. **Apply Positive Roberts Cross**:
   ```bash
   python combine.py pos-roberts-kernel-kernel.txt input_image.txt output_image_pos_rc.jpg
   ```

3. **Apply Negative Roberts Cross**:
   ```bash
   python combine.py neg-roberts-kernel-kernel.txt input_image.txt output_image_neg_rc.jpg
   ```

4. **Combine Both Masks**:
   ```bash
   python combine.py combined input_image.txt output_image_combined.jpg
   ```

5. **View Results**: 
   After running the above steps, the edge-detected images can be viewed in their respective output files.

---

## Conclusion

Roberts Cross is a simple yet powerful edge detection technique that highlights diagonal edges in an image. By applying both positive and negative diagonal masks, you can detect edges in both directions and combine them for a complete edge map. This implementation offers an efficient way to extract edge features from images, useful in various computer vision tasks.
