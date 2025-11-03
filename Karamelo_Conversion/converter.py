import pandas as pd
import numpy as np
# import glob.glob as glob


input_file = "karamelofiles/dump_p.0.dat"
output_file = "converted_data.csv"


def read_karamelo_file(file_path):
    with open(file_path, 'r') as f:
        lines = f.readlines()
        
    for  i, line in enumerate(lines):
        if line.startswith("ITEM: ATOMS"):
            header_line = line
            start_line = i + 1
            break
    
    header = header_line.strip().split()[2:]
    
    data = pd.read_csv(file_path, sep='\s+', skiprows=start_line, names=header)
    return data

def write_to_csv(data, output_file, columns=["x", "y", "z", "vx", "vy", "vz", "mass", "volume"]):
    if set(columns).issubset(data.columns):
        data = data[columns]
    else:
        raise ValueError("Some specified columns are not in the data.")
    data.to_csv(output_file, index=False)



twod_columns = ["x", "y", "vx", "vy", "mass", "volume", "type"]

if __name__ == "__main__":
    data = read_karamelo_file(input_file)
    write_to_csv(data, output_file, columns=twod_columns)