import os
import pandas as pd
import matplotlib.pyplot as plt

# Define input and output paths
csv_file = "battery_log.csv"  # Path to your CSV file
graph_folder = "graph"       # Folder where the graphs will be saved

# Create the graph folder if it doesn't exist
if not os.path.exists(graph_folder):
    os.makedirs(graph_folder)

# Read the CSV data into a pandas DataFrame
df = pd.read_csv(csv_file)

# Convert necessary columns to appropriate data types
df['Timestamp'] = pd.to_datetime(df['Timestamp'])
df['Current (µA)'] = df['Current (µA)'].apply(pd.to_numeric, errors='coerce')
df['Charge (µAh)'] = df['Charge (µAh)'].apply(pd.to_numeric, errors='coerce')

# Convert Charge from µAh to mAh (1 mAh = 1000 µAh)
df['Charge (mAh)'] = df['Charge (µAh)'] / 1000.0

# Create the plot
plt.figure(figsize=(10, 6))

# Plot Charge vs. Time
plt.plot(df['Timestamp'], df['Charge (mAh)'], label='Charge (mAh)', color='blue', linestyle='-', marker='o')

# Plot Current vs. Time
plt.plot(df['Timestamp'], df['Current (µA)'] / 1000.0, label='Current (A)', color='red', linestyle='-', marker='x')

# Label the axes
plt.xlabel('Time')
plt.ylabel('Value')
plt.title('Battery Charge and Current vs Time')

# Add a legend to the plot
plt.legend()

# Rotate the x-axis labels for better readability
plt.xticks(rotation=45)

# Improve layout
plt.tight_layout()

# Save the plot as an image in the 'graphs' folder
output_image_path = os.path.join(graph_folder, 'charge_and_current_vs_time.png')
plt.savefig(output_image_path)

# Show the plot (optional)
plt.show()

print(f"Graph saved to: {output_image_path}")
