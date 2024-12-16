import numpy as np
from PIL import Image

def text_to_image_rgb(input_text_path_r, input_text_path_g, input_text_path_b, output_image_path):
    def read_channel(file_path):
        """Reads a text file and converts it to a 2D numpy array."""
        with open(file_path, 'r') as file:
            lines = file.readlines()
        channel = []
        for line in lines:
            row = []
            for value in line.split():
                if value == 'x':
                    row.append(-1)  # Mark as invalid
                else:
                    row.append(int(value))
            channel.append(row)
        return np.array(channel, dtype=np.int32)

    # Read channels and mark invalid values
    red_channel = read_channel(input_text_path_r)
    green_channel = read_channel(input_text_path_g)
    blue_channel = read_channel(input_text_path_b)

    # Determine invalid positions
    invalid_positions = (red_channel == -1) | (green_channel == -1) | (blue_channel == -1)

    # Replace invalid positions with 0 in all channels
    red_channel[invalid_positions] = 0
    green_channel[invalid_positions] = 0
    blue_channel[invalid_positions] = 0

    # Stack the channels to form the final RGB image array
    img_array = np.stack((red_channel, green_channel, blue_channel), axis=-1)

    # Clip values to the range [0, 255]
    img_array = np.clip(img_array, 0, 255).astype(np.uint8)

    # Create an image from the numpy array
    img = Image.fromarray(img_array, 'RGB')

    # Save the image
    img.save(output_image_path)
    print(f"Image saved as {output_image_path}")

# Example usage
if __name__ == "__main__":
    text_to_image_rgb('lena_hor_r.txt', 'lena_hor_g.txt', 'lena_hor_b.txt', 'lena_hor.jpg')
