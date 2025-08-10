import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

# Création du DataFrame
data = {
    'uCode': ['BEN', 'BWA', 'CIV', 'CMR', 'DZA', 'GHA', 'SEN', 'TGO', 'TUN', 'ZMB'],
    'Rank_2000': [5, 8, 6, 2, 10, 4, 7, 3, 9, 1],
    'EI_2000': [53.84, 45.26, 50.27, 74.28, 20.84, 59.65, 45.37, 66.5, 33.77, 84.71],
    'Rank_2020': [4, 5, 6, 2, 10, 9, 7, 1, 8, 3],
    'EI_2020': [48.62, 46.67, 45.2, 71.6, 25.58, 30.49, 39.29, 72.42, 34.73, 71.17]
}
df = pd.DataFrame(data)

# Sort countries by EI 2000 (for an ordered chart)
df = df.sort_values('EI_2000', ascending=False)

# Chart parameters
bar_width = 0.35
index = np.arange(len(df))
colors = ['#1f77b4', '#ff7f0e']  # Bleu pour 2000, orange pour 2020

# Graphic design
plt.figure(figsize=(12, 6))

# Bars for 2000 and 2020
bars1 = plt.bar(index - bar_width/2, df['EI_2000'], bar_width,
                color=colors[0], label='2000', alpha=0.8)
bars2 = plt.bar(index + bar_width/2, df['EI_2020'], bar_width,
                color=colors[1], label='2020', alpha=0.8)

# labels and titles
plt.xlabel('Country (uCode)', fontsize=12)
plt.ylabel('Environmental Index (EI)', fontsize=12)
plt.title('Comparison of EI scores between 2000 and 2020', fontsize=14, fontweight='bold')
plt.xticks(index, df['uCode'], rotation=45, ha='right')
plt.legend()

# Adding values to bars (optional)
for bar in bars1 + bars2:
    height = bar.get_height()
    plt.text(bar.get_x() + bar.get_width()/2., height,
             f'{height:.1f}',
             ha='center', va='bottom', fontsize=9)

# adjustments
plt.grid(axis='y', linestyle='--', alpha=0.7)
plt.tight_layout()

# Save and display
plt.savefig('comparaison_EI_2000_2020.png', dpi=300, bbox_inches='tight')
plt.show()