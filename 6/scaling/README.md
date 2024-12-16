# Image Scaling/Resizing  

This project demonstrates image scaling and resizing for both grayscale and colored images using Verilog. The scaling process adjusts the image dimensions based on specified vertical (M) and horizontal (N) scaling factors.  

## Workflow  

- **`img2bin.py`**: Converts the input image (`input_image.jpg`) into a grayscale pixel data text file (`input_image.txt`) or three separate text files for the red, green, and blue channels for colored images.  
- **`scale.v`**: Reads the pixel data from the input text file(s), applies scaling transformations using the specified M (vertical) and N (horizontal) scaling factors, and outputs the scaled data to text file(s).  
- **`bin2img.py`**: Converts the scaled pixel data back into an image file (e.g., `.jpg` or `.png`).  

---

## Mathematical Details  

### Scaling Transformation  

The scaling process maps each pixel in the input image to its corresponding position in the scaled output image using the specified vertical (M) and horizontal (N) scaling factors.  

For each pixel $$(j, i)$$ in the input image:  

$$
j' = j \cdot N, \quad i' = i \cdot M
$$  

The output image dimensions are determined as follows:  

$$
\text{Output Width} = \text{Input Width} \cdot N, \quad \text{Output Height} = \text{Input Height} \cdot M
$$  

### Nearest Neighbor Interpolation  

During the scaling process, nearest neighbor interpolation is used to assign pixel values to the scaled image. This involves mapping the integer coordinates of the input pixel to the nearest corresponding coordinate in the output image.  

---

## Outputs  

### Grayscale Images  

The following table demonstrates the effects of scaling with different vertical (M) and horizontal (N) factors:  

| Input Image               | 2H1V Scaled Image          | 2V1H Scaled Image          | 2H2V Scaled Image          |  
|---------------------------|----------------------------|----------------------------|----------------------------|  
| ![Input Image](input_image.jpg) | ![2H1V Scaled](2h1v_scaled.jpg) | ![2V1H Scaled](2v1h_scaled.jpg) | ![2H2V Scaled](2h2v_scaled.jpg) |  

---

### Colored Images  

For colored images, the scaling process is applied independently to the red, green, and blue channels and then combined to produce the final image.  

| Original Image           | 4V3H Scaled Image          |  
|---------------------------|----------------------------|  
| ![Original Image](lena_org.png) | ![4V3H Scaled](lena_scale.jpg) |  


