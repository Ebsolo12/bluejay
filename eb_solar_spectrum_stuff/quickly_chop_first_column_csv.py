import pandas as pd

# File path
file_path = r'C:\Users\pbt92\Downloads\sorce_ssi_l3.csv'

# Read CSV file
df = pd.read_csv(file_path)

# Drop the first column
df = df.iloc[:, 1:]

# Rewrite the file
df.to_csv(file_path, index=False)

print(f"File '{file_path}' has been updated with the first column removed.")
