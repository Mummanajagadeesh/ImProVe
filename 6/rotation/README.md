# Image Rotation Using Verilog  

This project demonstrates image rotation by a specified angle using Verilog. The input image is transformed using a geometric rotation matrix, with intermediate steps to handle pixel shifting and boundary conditions.  

## Workflow  

### 1. Input Image Preparation  
- **`img2bin.py`**  
  Converts the input image (`input_image.jpg`) into a black-and-white pixel data text file (`input_image.txt`).  

### 2. Image Rotation  
- **`rotate.v`**  
  Accepts the pixel data from `input_image.txt`, applies a rotation transformation, and outputs the resulting data to `output_image.txt`.  

### 3. Output Image Reconstruction  
- **`bin2img.py`**  
  Converts the rotated pixel data from `output_image.txt` back into an image (`output_image.jpg`).  

---

## Mathematical Details  

### 1. Translate Pixel Coordinates to Image Center  

Each pixel \((j, i)\) is initially represented in the image's coordinate system. To facilitate rotation, the pixel is translated so that the center of the image becomes the origin:  

$$
x_{\text{shifted}} = j - \text{center}_x
$$

$$
y_{\text{shifted}} = i - \text{center}_y
$$  

Here, the center coordinates are computed as:  

$$
\text{center}_x = \frac{\text{COLS} - 1}{2}, \quad \text{center}_y = \frac{\text{ROWS} - 1}{2}
$$  

### 2. Apply the Rotation Matrix  

The rotation transformation uses the 2D rotation matrix:  

### Matrix Definitions

**Rotation Matrix (R)**:

$$ 
R = 
\begin{bmatrix}
\cos(\theta) & \sin(\theta) \\
-\sin(\theta) & \cos(\theta)
\end{bmatrix}
$$

**Original Pixel Coordinates (P)**:

$$ 
P = 
\begin{bmatrix}
x_{\text{shifted}} \\
y_{\text{shifted}}
\end{bmatrix}
$$

**Rotated Pixel Coordinates (P')**:

$$ 
P' = 
\begin{bmatrix}
x' \\
y'
\end{bmatrix}
$$

**Rotation Equation**:

Using these defined matrices, the rotation of the pixel coordinates is expressed as:

$$
P' = R \cdot P
$$


Breaking this down into components:  

$$
x_{\text{rotated}} = x_{\text{shifted}} \cdot \cos(\theta) - y_{\text{shifted}} \cdot \sin(\theta)
$$  
$$
y_{\text{rotated}} = x_{\text{shifted}} \cdot \sin(\theta) + y_{\text{shifted}} \cdot \cos(\theta)
$$  

### 3. Translate Back to Original Image Coordinates  

After rotation, the pixel coordinates are translated back to the original image space:  

$$
j' = \text{round}(x_{\text{rotated}} + \text{center}_x)
$$ 

$$
i' = \text{round}(y_{\text{rotated}} + \text{center}_y)
$$  

### 4. Check Bounds  

Ensure that the rotated coordinates \((i', j')\) fall within the image dimensions:  

$$
0 \leq i' < \text{ROWS}, \quad 0 \leq j' < \text{COLS}
$$  

If the rotated coordinates are out of bounds, the pixel value defaults to zero.  

---

## Outputs  

Below are the visual results of rotating the input image by different angles. The original and rotated images are displayed side-by-side:  

| Original Image           | 30° Rotated Image          | 45° Rotated Image          | 60° Rotated Image          | 90° Rotated Image          |  
|---------------------------|----------------------------|----------------------------|----------------------------|----------------------------|  
| ![Input Image](input_image.jpg) | ![30° Rotated](30deg.jpg) | ![45° Rotated](45deg.jpg) | ![60° Rotated](60deg.jpg) | ![90° Rotated](90deg.jpg) |  

---



