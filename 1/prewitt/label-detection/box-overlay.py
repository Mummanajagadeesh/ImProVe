from PIL import Image
import numpy as np

def overlay_red_channel(input_image_path, binary_image_path, output_image_path):
    # Load the input image
    input_image = Image.open(input_image_path).convert("RGB")

    # Load the binary image and ensure it's grayscale
    binary_image = Image.open(binary_image_path).convert("L")

    # Resize binary image to match input image size if needed
    binary_image = binary_image.resize(input_image.size, Image.Resampling.LANCZOS)

    # Convert images to numpy arrays
    input_np = np.array(input_image)
    binary_np = np.array(binary_image)

    # Normalize binary image to ensure 255 is treated as high-intensity
    binary_np = (binary_np > 128) * 255  # Threshold to create a binary mask

    # Modify the red channel where binary image is 255
    output_np = input_np.copy()
    output_np[binary_np == 255] = [255, 0, 0]  # Set to red color at those pixels

    # Convert back to image and save
    output_image = Image.fromarray(output_np, "RGB")
    output_image.save(output_image_path)

# File paths
input_image_path = "ocr_test_1.jpeg"
binary_image_path = "output_image.jpg"
output_image_path = "output_image_with_box.jpg"

# Overlay the images
overlay_red_channel(input_image_path, binary_image_path, output_image_path)

print(f"Overlay image saved as {output_image_path}")
