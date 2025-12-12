#!/usr/bin/env python3
"""
Team 0 Analysis: One Dataset, Many Analysts
Research Question: Are soccer players with dark skin tone more likely than those 
with light skin tone to receive red cards from referees?

Analysis Approach:
1. Data preprocessing and cleaning
2. Exploratory data analysis
3. Statistical modeling (Poisson/Negative Binomial regression)
4. Visualization of results
"""

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from scipy import stats
import statsmodels.api as sm
from statsmodels.tools import add_constant
import warnings
warnings.filterwarnings('ignore')

# Set style for visualizations
sns.set_style("whitegrid")
plt.rcParams['figure.figsize'] = (12, 8)

def load_and_clean_data(filepath):
    """Load and preprocess the dataset."""
    print("=" * 80)
    print("LOADING AND CLEANING DATA")
    print("=" * 80)
    
    df = pd.read_csv(filepath)
    print(f"Initial dataset shape: {df.shape}")
    print(f"Total observations: {len(df):,}")
    
    # Create average skin tone rating
    df['skinTone'] = df[['rater1', 'rater2']].mean(axis=1)
    
    # Remove rows with missing skin tone ratings
    initial_count = len(df)
    df = df.dropna(subset=['skinTone'])
    print(f"Removed {initial_count - len(df):,} rows with missing skin tone ratings")
    
    # Create binary skin tone categories
    # Using median split: 0.25 to 0.5 as reference
    df['skinToneCategory'] = pd.cut(df['skinTone'], 
                                     bins=[0, 0.25, 0.5, 0.75, 1.0],
                                     labels=['Very Light', 'Light', 'Dark', 'Very Dark'],
                                     include_lowest=True)
    
    # Binary classification: light (0-0.5) vs dark (0.5-1.0)
    df['darkSkin'] = (df['skinTone'] > 0.5).astype(int)
    
    print(f"\nFinal dataset shape: {df.shape}")
    print(f"Players analyzed: {df['playerShort'].nunique():,}")
    
    return df

def exploratory_analysis(df):
    """Perform exploratory data analysis."""
    print("\n" + "=" * 80)
    print("EXPLORATORY DATA ANALYSIS")
    print("=" * 80)
    
    # Basic statistics
    print("\n1. SKIN TONE DISTRIBUTION")
    print("-" * 40)
    print(f"Mean skin tone: {df['skinTone'].mean():.3f}")
    print(f"Median skin tone: {df['skinTone'].median():.3f}")
    print(f"Std deviation: {df['skinTone'].std():.3f}")
    print(f"Range: [{df['skinTone'].min():.3f}, {df['skinTone'].max():.3f}]")
    
    print("\n2. SKIN TONE CATEGORIES")
    print("-" * 40)
    print(df['skinToneCategory'].value_counts().sort_index())
    print(f"\nDark skin (>0.5): {df['darkSkin'].sum():,} ({df['darkSkin'].mean()*100:.1f}%)")
    print(f"Light skin (≤0.5): {(1-df['darkSkin']).sum():,} ({(1-df['darkSkin'].mean())*100:.1f}%)")
    
    # Red card statistics
    print("\n3. RED CARD STATISTICS")
    print("-" * 40)
    print(f"Total red cards: {df['redCards'].sum():,}")
    print(f"Players with at least one red card: {(df['redCards'] > 0).sum():,}")
    print(f"Percentage with red cards: {(df['redCards'] > 0).mean()*100:.2f}%")
    print(f"Mean red cards per observation: {df['redCards'].mean():.4f}")
    print(f"Max red cards: {df['redCards'].max()}")
    
    # Red cards by skin tone
    print("\n4. RED CARDS BY SKIN TONE")
    print("-" * 40)
    
    # By binary classification
    light_df = df[df['darkSkin'] == 0]
    dark_df = df[df['darkSkin'] == 1]
    
    print("\nLight Skin (≤0.5):")
    print(f"  Total observations: {len(light_df):,}")
    print(f"  Total red cards: {light_df['redCards'].sum()}")
    print(f"  Mean red cards: {light_df['redCards'].mean():.4f}")
    print(f"  Red card rate: {(light_df['redCards'] > 0).mean()*100:.2f}%")
    
    print("\nDark Skin (>0.5):")
    print(f"  Total observations: {len(dark_df):,}")
    print(f"  Total red cards: {dark_df['redCards'].sum()}")
    print(f"  Mean red cards: {dark_df['redCards'].mean():.4f}")
    print(f"  Red card rate: {(dark_df['redCards'] > 0).mean()*100:.2f}%")
    
    # By category
    print("\n5. RED CARDS BY DETAILED CATEGORIES")
    print("-" * 40)
    category_stats = df.groupby('skinToneCategory', observed=True).agg({
        'redCards': ['count', 'sum', 'mean'],
        'games': 'sum'
    }).round(4)
    print(category_stats)
    
    # Calculate red cards per game
    print("\n6. RED CARDS PER GAME PLAYED")
    print("-" * 40)
    print("\nLight Skin (≤0.5):")
    light_rate = light_df['redCards'].sum() / light_df['games'].sum()
    print(f"  Red cards per game: {light_rate:.5f}")
    
    print("\nDark Skin (>0.5):")
    dark_rate = dark_df['redCards'].sum() / dark_df['games'].sum()
    print(f"  Red cards per game: {dark_rate:.5f}")
    
    print(f"\nRatio (Dark/Light): {dark_rate/light_rate:.3f}")
    
    return light_df, dark_df

def statistical_tests(df, light_df, dark_df):
    """Perform statistical tests."""
    print("\n" + "=" * 80)
    print("STATISTICAL TESTS")
    print("=" * 80)
    
    # 1. Mann-Whitney U test (non-parametric)
    print("\n1. MANN-WHITNEY U TEST")
    print("-" * 40)
    print("Comparing red card distributions between light and dark skin players")
    statistic, p_value = stats.mannwhitneyu(light_df['redCards'], 
                                             dark_df['redCards'], 
                                             alternative='two-sided')
    print(f"U-statistic: {statistic:.2f}")
    print(f"P-value: {p_value:.6f}")
    print(f"Result: {'Significant' if p_value < 0.05 else 'Not significant'} at α=0.05")
    
    # 2. Chi-square test for independence
    print("\n2. CHI-SQUARE TEST")
    print("-" * 40)
    print("Testing independence between skin tone and receiving any red card")
    
    contingency = pd.crosstab(df['darkSkin'], df['redCards'] > 0)
    chi2, p_value_chi, dof, expected = stats.chi2_contingency(contingency)
    print(f"Chi-square statistic: {chi2:.4f}")
    print(f"Degrees of freedom: {dof}")
    print(f"P-value: {p_value_chi:.6f}")
    print(f"Result: {'Significant' if p_value_chi < 0.05 else 'Not significant'} at α=0.05")
    
    # 3. Poisson Regression
    print("\n3. POISSON REGRESSION MODEL")
    print("-" * 40)
    print("Predicting red cards from skin tone (controlling for games played)")
    
    # Prepare data for regression
    model_df = df[['redCards', 'skinTone', 'games']].dropna()
    X = add_constant(model_df[['skinTone', 'games']])
    y = model_df['redCards']
    
    # Fit Poisson model
    poisson_model = sm.Poisson(y, X).fit(disp=False)
    print(poisson_model.summary())
    
    # Extract key results
    skin_coef = poisson_model.params['skinTone']
    skin_pval = poisson_model.pvalues['skinTone']
    
    print("\n" + "=" * 40)
    print("KEY FINDING:")
    print(f"Skin tone coefficient: {skin_coef:.4f}")
    print(f"P-value: {skin_pval:.6f}")
    print(f"Incidence Rate Ratio (IRR): {np.exp(skin_coef):.4f}")
    print(f"Interpretation: A one-unit increase in skin tone rating is associated")
    print(f"with a {(np.exp(skin_coef)-1)*100:.2f}% change in red card incidence")
    print(f"Result: {'Significant' if skin_pval < 0.05 else 'Not significant'} at α=0.05")
    print("=" * 40)
    
    # 4. Negative Binomial Regression (for overdispersion)
    print("\n4. NEGATIVE BINOMIAL REGRESSION MODEL")
    print("-" * 40)
    print("Alternative model accounting for potential overdispersion")
    
    nb_model = sm.NegativeBinomial(y, X).fit(disp=False)
    print(nb_model.summary())
    
    # Extract key results
    skin_coef_nb = nb_model.params['skinTone']
    skin_pval_nb = nb_model.pvalues['skinTone']
    
    print("\n" + "=" * 40)
    print("KEY FINDING (Negative Binomial):")
    print(f"Skin tone coefficient: {skin_coef_nb:.4f}")
    print(f"P-value: {skin_pval_nb:.6f}")
    print(f"Incidence Rate Ratio (IRR): {np.exp(skin_coef_nb):.4f}")
    print(f"Result: {'Significant' if skin_pval_nb < 0.05 else 'Not significant'} at α=0.05")
    print("=" * 40)
    
    return poisson_model, nb_model

def create_visualizations(df, light_df, dark_df):
    """Create visualizations of the results."""
    print("\n" + "=" * 80)
    print("CREATING VISUALIZATIONS")
    print("=" * 80)
    
    fig, axes = plt.subplots(2, 3, figsize=(18, 12))
    fig.suptitle('Analysis: Skin Tone and Red Cards in Soccer', fontsize=16, fontweight='bold')
    
    # 1. Distribution of skin tone ratings
    axes[0, 0].hist(df['skinTone'], bins=50, edgecolor='black', alpha=0.7, color='steelblue')
    axes[0, 0].axvline(df['skinTone'].mean(), color='red', linestyle='--', 
                       linewidth=2, label=f'Mean: {df["skinTone"].mean():.3f}')
    axes[0, 0].axvline(df['skinTone'].median(), color='orange', linestyle='--', 
                       linewidth=2, label=f'Median: {df["skinTone"].median():.3f}')
    axes[0, 0].set_xlabel('Skin Tone Rating (0=Very Light, 1=Very Dark)')
    axes[0, 0].set_ylabel('Frequency')
    axes[0, 0].set_title('Distribution of Skin Tone Ratings')
    axes[0, 0].legend()
    axes[0, 0].grid(True, alpha=0.3)
    
    # 2. Red cards by skin tone category
    category_means = df.groupby('skinToneCategory', observed=True)['redCards'].mean()
    colors = ['#e8f4f8', '#a8d8ea', '#6bb6d6', '#2e7d99']
    bars = axes[0, 1].bar(range(len(category_means)), category_means, 
                          color=colors, edgecolor='black')
    axes[0, 1].set_xticks(range(len(category_means)))
    axes[0, 1].set_xticklabels(category_means.index, rotation=45, ha='right')
    axes[0, 1].set_ylabel('Mean Red Cards')
    axes[0, 1].set_title('Mean Red Cards by Skin Tone Category')
    axes[0, 1].grid(True, alpha=0.3, axis='y')
    
    # Add value labels on bars
    for bar in bars:
        height = bar.get_height()
        axes[0, 1].text(bar.get_x() + bar.get_width()/2., height,
                       f'{height:.4f}', ha='center', va='bottom', fontsize=9)
    
    # 3. Box plot: Red cards by dark/light skin
    data_for_box = [light_df['redCards'], dark_df['redCards']]
    bp = axes[0, 2].boxplot(data_for_box, labels=['Light Skin\n(≤0.5)', 'Dark Skin\n(>0.5)'],
                            patch_artist=True)
    bp['boxes'][0].set_facecolor('#a8d8ea')
    bp['boxes'][1].set_facecolor('#2e7d99')
    axes[0, 2].set_ylabel('Red Cards')
    axes[0, 2].set_title('Red Cards Distribution: Light vs Dark Skin')
    axes[0, 2].grid(True, alpha=0.3, axis='y')
    
    # 4. Scatter plot: Skin tone vs red cards (with jitter)
    jitter_x = df['skinTone'] + np.random.normal(0, 0.02, len(df))
    jitter_y = df['redCards'] + np.random.normal(0, 0.05, len(df))
    axes[1, 0].scatter(jitter_x, jitter_y, alpha=0.3, s=10, color='steelblue')
    
    # Add trend line
    z = np.polyfit(df['skinTone'], df['redCards'], 1)
    p = np.poly1d(z)
    x_line = np.linspace(df['skinTone'].min(), df['skinTone'].max(), 100)
    axes[1, 0].plot(x_line, p(x_line), "r--", linewidth=2, label='Trend')
    
    axes[1, 0].set_xlabel('Skin Tone Rating')
    axes[1, 0].set_ylabel('Red Cards')
    axes[1, 0].set_title('Relationship: Skin Tone vs Red Cards')
    axes[1, 0].legend()
    axes[1, 0].grid(True, alpha=0.3)
    
    # 5. Red card rate comparison
    light_rate = (light_df['redCards'] > 0).mean() * 100
    dark_rate = (dark_df['redCards'] > 0).mean() * 100
    
    bars = axes[1, 1].bar(['Light Skin\n(≤0.5)', 'Dark Skin\n(>0.5)'], 
                          [light_rate, dark_rate],
                          color=['#a8d8ea', '#2e7d99'], edgecolor='black')
    axes[1, 1].set_ylabel('Percentage with at least 1 Red Card')
    axes[1, 1].set_title('Red Card Rate: Light vs Dark Skin')
    axes[1, 1].grid(True, alpha=0.3, axis='y')
    
    # Add value labels
    for bar in bars:
        height = bar.get_height()
        axes[1, 1].text(bar.get_x() + bar.get_width()/2., height,
                       f'{height:.2f}%', ha='center', va='bottom', fontsize=10)
    
    # 6. Red cards per 100 games
    light_per_100 = (light_df['redCards'].sum() / light_df['games'].sum()) * 100
    dark_per_100 = (dark_df['redCards'].sum() / dark_df['games'].sum()) * 100
    
    bars = axes[1, 2].bar(['Light Skin\n(≤0.5)', 'Dark Skin\n(>0.5)'], 
                          [light_per_100, dark_per_100],
                          color=['#a8d8ea', '#2e7d99'], edgecolor='black')
    axes[1, 2].set_ylabel('Red Cards per 100 Games')
    axes[1, 2].set_title('Red Card Rate per Game Played')
    axes[1, 2].grid(True, alpha=0.3, axis='y')
    
    # Add value labels
    for bar in bars:
        height = bar.get_height()
        axes[1, 2].text(bar.get_x() + bar.get_width()/2., height,
                       f'{height:.3f}', ha='center', va='bottom', fontsize=10)
    
    plt.tight_layout()
    
    # Save figure
    output_file = 'team-30-analysis.png'
    plt.savefig(output_file, dpi=300, bbox_inches='tight')
    print(f"\nVisualization saved as: {output_file}")
    
    return fig

def generate_report(df, light_df, dark_df, poisson_model, nb_model):
    """Generate a summary report."""
    print("\n" + "=" * 80)
    print("FINAL REPORT: TEAM 0 ANALYSIS")
    print("=" * 80)
    
    print("\nRESEARCH QUESTION:")
    print("Are soccer players with dark skin tone more likely than those with")
    print("light skin tone to receive red cards from referees?")
    
    print("\n" + "-" * 80)
    print("METHODOLOGY:")
    print("-" * 80)
    print("1. Dataset: CrowdstormingDataJuly1st.csv")
    print(f"2. Sample size: {len(df):,} player-referee observations")
    print(f"3. Players analyzed: {df['playerShort'].nunique():,}")
    print("4. Skin tone measurement: Average of two independent raters (0-1 scale)")
    print("5. Classification: Light (≤0.5) vs Dark (>0.5) skin tone")
    print("6. Statistical methods:")
    print("   - Descriptive statistics")
    print("   - Mann-Whitney U test")
    print("   - Chi-square test of independence")
    print("   - Poisson regression (controlling for games played)")
    print("   - Negative Binomial regression")
    
    print("\n" + "-" * 80)
    print("KEY FINDINGS:")
    print("-" * 80)
    
    # Calculate key statistics
    light_mean = light_df['redCards'].mean()
    dark_mean = dark_df['redCards'].mean()
    light_rate = (light_df['redCards'] > 0).mean() * 100
    dark_rate = (dark_df['redCards'] > 0).mean() * 100
    light_per_game = light_df['redCards'].sum() / light_df['games'].sum()
    dark_per_game = dark_df['redCards'].sum() / dark_df['games'].sum()
    
    print(f"\n1. DESCRIPTIVE STATISTICS:")
    print(f"   Light skin players: {len(light_df):,} observations")
    print(f"   - Mean red cards: {light_mean:.4f}")
    print(f"   - Red card rate: {light_rate:.2f}%")
    print(f"   - Red cards per game: {light_per_game:.5f}")
    print(f"   Dark skin players: {len(dark_df):,} observations")
    print(f"   - Mean red cards: {dark_mean:.4f}")
    print(f"   - Red card rate: {dark_rate:.2f}%")
    print(f"   - Red cards per game: {dark_per_game:.5f}")
    print(f"   Ratio (Dark/Light): {dark_mean/light_mean:.3f}x")
    
    print(f"\n2. REGRESSION ANALYSIS:")
    skin_coef = poisson_model.params['skinTone']
    skin_pval = poisson_model.pvalues['skinTone']
    irr = np.exp(skin_coef)
    
    print(f"   Poisson Model:")
    print(f"   - Skin tone coefficient: {skin_coef:.4f}")
    print(f"   - P-value: {skin_pval:.6f}")
    print(f"   - Incidence Rate Ratio: {irr:.4f}")
    print(f"   - Effect: {(irr-1)*100:+.2f}% change per unit increase in skin tone")
    
    skin_coef_nb = nb_model.params['skinTone']
    skin_pval_nb = nb_model.pvalues['skinTone']
    irr_nb = np.exp(skin_coef_nb)
    
    print(f"   Negative Binomial Model:")
    print(f"   - Skin tone coefficient: {skin_coef_nb:.4f}")
    print(f"   - P-value: {skin_pval_nb:.6f}")
    print(f"   - Incidence Rate Ratio: {irr_nb:.4f}")
    print(f"   - Effect: {(irr_nb-1)*100:+.2f}% change per unit increase in skin tone")
    
    print("\n" + "-" * 80)
    print("CONCLUSION:")
    print("-" * 80)
    
    if skin_pval < 0.05 or skin_pval_nb < 0.05:
        print("✓ YES - The analysis provides evidence that soccer players with darker")
        print("  skin tone are more likely to receive red cards from referees.")
        print(f"  The effect is statistically significant (p < 0.05) and suggests")
        print(f"  approximately {(max(irr, irr_nb)-1)*100:.1f}% higher red card incidence")
        print("  for dark skin players compared to light skin players.")
    else:
        print("✗ NO - The analysis does not provide sufficient statistical evidence")
        print("  that skin tone significantly affects red card decisions.")
        print("  While descriptive differences exist, they are not statistically")
        print("  significant at the α=0.05 level.")
    
    print("\n" + "-" * 80)
    print("LIMITATIONS AND CONSIDERATIONS:")
    print("-" * 80)
    print("1. Observational data - causation cannot be definitively established")
    print("2. Skin tone is measured by raters viewing photos, not objective measure")
    print("3. Confounding variables may exist (e.g., playing style, position, league)")
    print("4. Red cards are rare events, leading to many zeros in the data")
    print("5. Multiple observations per player may introduce clustering effects")
    print("6. Referee bias (implicit or explicit) cannot be directly measured")
    
    print("\n" + "=" * 80)
    print("ANALYSIS COMPLETE")
    print("=" * 80)

def main():
    """Main analysis pipeline."""
    print("\n")
    print("=" * 80)
    print("TEAM 0: ONE DATASET, MANY ANALYSTS")
    print("Soccer, Skin Tone, and Red Cards Analysis")
    print("=" * 80)
    
    # File path
    filepath = '/data/CrowdstormingDataJuly1st.csv'
    
    # 1. Load and clean data
    df = load_and_clean_data(filepath)
    
    # 2. Exploratory analysis
    light_df, dark_df = exploratory_analysis(df)
    
    # 3. Statistical tests
    poisson_model, nb_model = statistical_tests(df, light_df, dark_df)
    
    # 4. Create visualizations
    fig = create_visualizations(df, light_df, dark_df)
    
    # 5. Generate final report
    generate_report(df, light_df, dark_df, poisson_model, nb_model)
    
    print("\nAll outputs generated successfully!")
    print("- Visualization: team-30-analysis.png")

if __name__ == "__main__":
    main()
