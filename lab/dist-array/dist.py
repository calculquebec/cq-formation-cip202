from sys import argv, exit

import numpy as np
import pandas as pd

if len(argv) != 2:
    print('usage: python3 dist.py <output-csv-filename>')
    exit(1)

output_filename = argv[1]

mean = np.random.rand()
std = np.random.rand() + 0.5
dist = np.random.normal(mean, std, size = 1000)
df = pd.DataFrame(dist)

df.to_csv(output_filename)
print(f'Random normal distribution writen to {output_filename}.')
print(df.describe())
