# Color Thresholding

Color thresholding is a technique used in image processing to segment an image based on specified color ranges, isolating regions of interest. It is similar to global thresholding but works with pixel color values (e.g., RGB) to filter out specific colors or ranges.

This is already covered in the global thresholding section of the provided link [here](https://github.com/Mummanajagadeesh/ImProVe/blob/main/3/global/README.md#colored-images). Please take a look for more details

- **`img2rgb.py`**: Splits the input colored image (`lena_org.png`) into three separate text files for the Red, Green, and Blue channels (`lena_r.txt`, `lena_g.txt`, `lena_b.txt`).
- **`global.v`**: Applies global thresholding to each channel separately, using the specified thresholds (e.g., R:64, G:128, B:192). Outputs processed text files (`lena_64r.txt`, `lena_128g.txt`, `lena_192b.txt`).
- **`rgb2img.py`**: Combines the processed text files for the three channels into a single image (`lena_global.jpg`).

**Outputs:**
For a colored image processed with thresholds R:64, G:128, B:192:

| **Input Image**      | **Output Image R:64, G:128, B:192** |
|-----------------------|------------------------|
| ![lena_org.png](lena_org.png) | ![lena_global.jpg](lena_global.jpg) |
