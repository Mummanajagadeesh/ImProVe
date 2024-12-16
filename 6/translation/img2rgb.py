from PIL import Image
import numpy as np

def image_to_text_rgb(input_image_path, output_text_path_r, output_text_path_g, output_text_path_b):
    # Open the image and convert it to RGB mode
    img = Image.open(input_image_path).convert('RGB')

    # Convert the image to a NumPy array
    img_array = np.array(img)

    # Separate the red, green, and blue channels
    red_channel = img_array[:, :, 0]
    green_channel = img_array[:, :, 1]
    blue_channel = img_array[:, :, 2]

    # Write the red channel to the output text file
    with open(output_text_path_r, 'w') as file_r:
        for row in red_channel:
            file_r.write(" ".join(map(str, row)) + "\n")

    # Write the green channel to the output text file
    with open(output_text_path_g, 'w') as file_g:
        for row in green_channel:
            file_g.write(" ".join(map(str, row)) + "\n")

    # Write the blue channel to the output text file
    with open(output_text_path_b, 'w') as file_b:
        for row in blue_channel:
            file_b.write(" ".join(map(str, row)) + "\n")

# Example usage
image_to_text_rgb('lena_org.png', 'lena_r.txt', 'lena_g.txt', 'lena_b.txt')