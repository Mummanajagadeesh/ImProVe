import numpy as np

# Define the path to the text files
file_paths = {
    "n": "output_image_n_kc.txt",
    "e": "output_image_e_kc.txt",
    "w": "output_image_w_kc.txt",
    "s": "output_image_s_kc.txt",
    "ne": "output_image_ne_kc.txt",
    "nw": "output_image_nw_kc.txt",
    "se": "output_image_se_kc.txt",
    "sw": "output_image_sw_kc.txt"
}

# Load the text files into numpy arrays
def load_edge_data(file_path):
    with open(file_path, "r") as file:
        data = file.read().splitlines()
        # Replace 'x' with 0 and convert the data into a 2D numpy array
        return np.array([
            [0 if value == 'x' else int(value) for value in line.split()] 
            for line in data
        ])

# Load all the edge detection results
edges = {direction: load_edge_data(file_paths[direction]) for direction in file_paths}

# Ensure that all images have the same size
height, width = edges["n"].shape

# Initialize a matrix for the combined edge strength
edge_strength = np.zeros((height, width), dtype=float)

# Compute the combined edge strength (Euclidean norm of the 8 directions)
for i in range(height):
    for j in range(width):
        # Calculate the squared sum of the edge values for all 8 directions
        edge_sum = 0
        for direction in edges:
            value = edges[direction][i][j]
            # Ignore "don't care" values (if any, e.g., if the value is marked as 0)
            if value != 0:
                edge_sum += value ** 2
        # Calculate the square root to get the combined edge strength for this pixel
        edge_strength[i][j] = np.sqrt(edge_sum)

# Normalize the edge strength matrix to the range [0, 255]
min_val = np.min(edge_strength)
max_val = np.max(edge_strength)
norm_edge_strength = 255 * (edge_strength - min_val) / (max_val - min_val)

# Apply threshold of 127 (binary thresholding)
thresholded_edge_strength = np.where(norm_edge_strength >= 127, 255, 0)

# Save the resulting thresholded edge strength to output_image_combined.txt
with open("output_image_combined.txt", "w") as output_file:
    for row in thresholded_edge_strength.astype(int):
        output_file.write(" ".join(map(str, row)) + "\n")

# Optionally, save the final thresholded image as a .jpg file (using matplotlib)
import matplotlib.pyplot as plt
plt.imshow(thresholded_edge_strength, cmap='gray')
plt.axis('off')  # Hide axis labels
plt.savefig("output_image_combined.jpg", bbox_inches='tight', pad_inches=0)

print("Edge strength combined image has been saved to output_image_combined.txt and output_image_combined.jpg")
