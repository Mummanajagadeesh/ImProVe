import matplotlib.pyplot as plt
import numpy as np
import sys

def read_pixel_values(file_path):
    """
    Reads pixel intensity values (0-255) from the input file.
    File format: space-separated or newline-separated numbers.
    """
    try:
        with open(file_path, 'r') as f:
            # Read all the values, split by whitespace, and convert to integers
            values = [int(value) for value in f.read().split()]
            return values
    except FileNotFoundError:
        print(f"Error: File '{file_path}' not found.")
        sys.exit(1)
    except ValueError:
        print("Error: File contains non-integer or invalid values.")
        sys.exit(1)

def plot_and_save_histogram(values, output_path):
    """
    Plots the histogram of pixel intensity values and saves it as an image.
    """
    # Define the histogram bins for pixel values (0-255)
    bins = np.arange(0, 257)  # 256 bins for pixel intensities

    # Create histogram plot
    plt.figure(figsize=(10, 6))
    plt.hist(values, bins=bins, color='gray', edgecolor='black')
    plt.title("Pixel Intensity Histogram")
    plt.xlabel("Pixel Intensity (0-255)")
    plt.ylabel("Frequency")
    plt.grid(axis='y', linestyle='--', alpha=0.7)

    # Save the plot as an image
    plt.savefig(output_path)
    print(f"Histogram saved as '{output_path}'")
    plt.close()

def main():
    input_file = 'otsu.txt'  # Input file name
    output_file = 'hist_otsu.jpg'        # Output histogram image file

    # Read pixel intensity values
    print("Reading pixel values from input file...")
    pixel_values = read_pixel_values(input_file)

    # Plot and save histogram
    print("Generating and saving histogram...")
    plot_and_save_histogram(pixel_values, output_file)

if __name__ == "__main__":
    main()
