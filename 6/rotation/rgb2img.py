import numpy as np
from PIL import Image

def text_to_image_rgb(input_text_path_r, input_text_path_g, input_text_path_b, output_image_path):
    # Read the red channel from the text file
    with open(input_text_path_r, 'r') as file_r:
        lines_r = file_r.readlines()
    red_channel = [list(map(int, line.split())) for line in lines_r]

    # Read the green channel from the text file
    with open(input_text_path_g, 'r') as file_g:
        lines_g = file_g.readlines()
    green_channel = [list(map(int, line.split())) for line in lines_g]

    # Read the blue channel from the text file
    with open(input_text_path_b, 'r') as file_b:
        lines_b = file_b.readlines()
    blue_channel = [list(map(int, line.split())) for line in lines_b]

    # Convert the lists to numpy arrays
    red_array = np.array(red_channel, dtype=np.int32)
    green_array = np.array(green_channel, dtype=np.int32)
    blue_array = np.array(blue_channel, dtype=np.int32)

    # Stack the channels to form the final RGB image array
    img_array = np.stack((red_array, green_array, blue_array), axis=-1)

    # Clip values to the range [0, 255]
    img_array = np.clip(img_array, 0, 255).astype(np.uint8)

    # Create an image from the numpy array
    img = Image.fromarray(img_array, 'RGB')

    # Save the image
    img.save(output_image_path)
    print(f"Image saved as {output_image_path}")

# Example usage
text_to_image_rgb('lena_rot_r.txt', 'lena_rot_g.txt', 'lena_rot_b.txt', 'lena_rot.jpg')
