import numpy as np
import math

def read_matrix_from_file(filename):
    """
    Reads a matrix from a text file where each row of the matrix is on a new line
    and values are space-separated. Replaces any non-numeric 'x' with 0.
    """
    with open(filename, 'r') as file:
        return np.array([[float(num) if num != 'x' else 0 for num in line.split()] for line in file])

def truncate_to_byte_range(matrix):
    """
    Truncate values to whole numbers and ensure they fall within the range 0-255.
    """
    matrix = np.floor(matrix)  # Truncate decimal part
    matrix = np.clip(matrix, 0, 255)  # Clamp values to the range 0-255
    return matrix.astype(int)

def calculate_pixel_matrix(pos_file, neg_file, output_file):
    """
    Calculates the pixel matrix based on the formula:
    pixel[i][j] = sqrt(pos[i][j] ** 2 + neg[i][j] ** 2)
    Then truncates results to whole numbers within 0-255.
    """
    # Read matrices from input files
    pos = read_matrix_from_file(pos_file)
    neg = read_matrix_from_file(neg_file)

    # Ensure both matrices have the same shape
    if pos.shape != neg.shape:
        raise ValueError("Input matrices must have the same dimensions")

    # Calculate the resulting pixel matrix
    pixel_matrix = np.sqrt(np.power(pos, 2) + np.power(neg, 2))

    # Truncate to byte range
    pixel_matrix = truncate_to_byte_range(pixel_matrix)

    # Save the resulting matrix to the output file
    with open(output_file, 'w') as file:
        for row in pixel_matrix:
            file.write(' '.join(map(str, row)) + '\n')

if __name__ == "__main__":
    # File paths
    pos_file = "lena_pos_rc.txt"
    neg_file = "lena_neg_rc.txt"
    output_file = "lena_combined.txt"

    # Calculate and save the matrix
    calculate_pixel_matrix(pos_file, neg_file, output_file)
    print(f"Pixel matrix saved to {output_file}")
