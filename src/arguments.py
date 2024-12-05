import argparse

def parse_arguments():
    parser = argparse.ArgumentParser(description="Plot battery charge and current vs time from a CSV file.")
    parser.add_argument(
        "-i", "--input", 
        type=str, 
        required=True, 
        help="Path to the input CSV file containing battery data."
    )
    parser.add_argument(
        "-o", "--output", 
        type=str, 
        help="Path to the folder where the graph will be saved. Defaults to the input file's folder."
    )
    return parser.parse_args()