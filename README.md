# Many Analysts Reproducibility and Replicability Report

## Introduction

This repository contains the reproducibility and replicability report for the "Many Analysts" study. The goal is to assess whether the original study's results can be reproduced using the same data and methods, and whether similar results can be obtained when varying certain factors.

The many analysts study involves multiple analysts independently analyzing the same dataset to answer a specific research question : "Are soccer players with dark skin tone more likely than those with light skin tone to receive red cards from referees?"

This report is structured into two main sections: Reproducibility and Replicability.

**Our Contribution (Team 30)**: We used Large Language Models (LLMs) to generate a new analysis that replicates the "Many Analysts" experiment using the same dataset. This tests whether modern AI (end of 2025) can independently conduct statistical research similar to the original 29 human teams. See the [Replicability section](#replicability) for our Team 30 analysis.

## Reproducibility

### How to Reproduce the Results

To reproduce the results of the original study, we set up a controlled dockerized environment and used the provided data and scripts.
Below are the steps to reproduce the results:

1. **Requirements**  
   - To run the reproducibility setup, ensure you have the following installed:
     - Docker
   - This was test only with linux operating systems so it may not work on Windows or MacOS.

2. **Setting Up the Environment**  
   - To create a reproducible environment using Docker, you can launch the code for most teams with the following commands:  
    ```bash
    docker build -t {name} .
    ```

3. **Reproducing Results**  
   - To run the analysis and reproduce the results, execute the following command in each team directory:
     ```bash
     docker run -it -v ../../data/CrowdstormingDataJuly1st.csv:{file_path_inside_container} {name}
     ```
     To make the run easier with volume names and file paths, you can use the provided makefile with `make` in each team directory.

### Encountered Issues and Improvements
- We faced several issues during the reproduction process, including:
  - Choosing which team to focus on, as some teams had incomplete or non-functional code.
  - Finding the right versions of R, outdated libraries, and dependencies required by the original code. Every team had different versions and setups, making it challenging to create a unified environment.
  - Difficulty installing R packages due to the R package manager's not handling older package versions well. 
  - Missing code segments, particularly related to data cleaning, which hindered full reproduction of some analyses.
  - Compatibility issues with certain libraries, such as the "Car" library, which conflicted with other dependencies.
  - Missing knowledge in statistical methods and how to transform code outputs into the specific statistics mentioned in the original paper.
- To fix these issues, we:
  - Focused on teams with more complete and functional codebases, mostly arround teams using R as programming language.
  - Spent significant time installing older versions of R and required libraries. We created some [Docker images](https://hub.docker.com/r/thebloodman/r-old) with R between versions 3.0.2 and 3.3.3 to accommodate different team requirements.
  - Made necessary code modifications to ensure compatibility with the installed library versions.

### Is the Original Study Reproducible?
- Success or failure of reproducing the study for the selected teams :
| Team | Status     | Comment                                   |
  |--------------------|---------------------|--------------------------------------------|  | 3        | Not reproducible       | We can't figure out how to use "stan"  |
  | 5        | Not reproducible       | "Car" library has a lot of compatibility issues with other libraries, there is an error in the code |
  | 7        | Reproducible           | With great effort to find old libraries and some changes to the code we output a png |
  | 9        | Not reproducible       | We are missing code               |
  | 12       | Not reproducible       | We are missing the "data cleaning" code |
  | 13       | Sort of Reproducible   | Too many output....                     |
  | 25       | Sort of Reproducible   | Added missing library imports             |
  | 27       | Sort of Reproducible   | Python is better than R                  |
  | 28       | Sort of Reproducible   | Running for a LOOONG time but no output  |
- 7 :
  - The code outputs a png file instead of a value as written in the paper.
  - We couldn't find the "1.71" correlation value mentioned in the original paper nor the [1.70, 1.72] confidence interval.
  - We assume the output png is correct as it seems to visually matches the value but there might be an alternative code not provided to compute the exact value.
  - /!\ We lacked knowledge in statistics to fully understand and transform the output.
- 13 :
  - The code runs successfully and produces results... but the result is 340k lines of text which is impractical to analyze.
  - We tried to filter the output to find the relevant values but couldn't locate the specific statistics mentioned in the original paper.
  - /!\ We lacked knowledge in statistics to fully understand and transform the output.
- 25 :
  - The code run and the output seems correct. There might be a post processing step not provided to format the output as in the paper.
  - We couldn't find the "1.42" correlation value mentioned in the original paper nor the [1.19, 1.71] confidence interval.
  - /!\ We lacked knowledge in statistics to fully understand and transform the output.
- 27 :
  - The code run and the output seems correct. There might be a post processing step not provided to format the output as in the paper.
  - We couldn't find the "2.93" correlation value mentioned in the original paper nor the [0.11, 78.66] confidence interval.
  - /!\ We lacked knowledge in statistics to fully understand and transform the output.
- 28 :
  - The code runs for a very long time without producing any output. We had to switch to a more powerful machine to get it to finish and it still took several hours.
  - Once completed, we couldn't find the "1.38" correlation value mentioned in the original paper nor the [1.12, 1.71] confidence interval.
  - /!\ We lacked knowledge in statistics to fully understand and transform the output.

For most of the teams we attempted to reproduce, we were only partially successful. While we managed to run the code in several cases, we often could not extract the specific statistics reported in the original study due to missing code segments, output formats, or lack of statistical expertise and because the paper only provided the final results without detailed intermediate steps.

## Replicability

### Team 30: LLM-Generated Replication Experiment

**Replication Goal**: The original "Many Analysts" study (Silberzahn et al., 2018) had 29 independent research teams analyze the same dataset to answer one question. We replicate this experiment by adding a "30th team" - but because of our knowledge in stats, this team is entirely AI-generated using Large Language Models. This tests whether modern AI can independently conduct statistical research comparable to human researchers.

***Files**:
- `team-30.py` - Complete Python analysis script
- `team-30-analysis.png` - Visualizations of results
- `TEAM-30-REPORT.md` - Detailed analysis report with full methodology and findings
- `requirements.txt` - Python package dependencies

**Methodology**:
1. **Dataset**: 124,621 player-referee observations from 1,585 players
2. **Skin Tone Measurement**: Average of two independent rater scores (0=very light, 1=very dark)
3. **Classification**: Light (≤0.5) vs Dark (>0.5) skin tone
4. **Statistical Methods**:
   - Descriptive statistics and exploratory data analysis
   - Mann-Whitney U test (non-parametric comparison)
   - Chi-square test of independence
   - Poisson regression (controlling for games played)
   - Negative Binomial regression (accounting for overdispersion)

**Key Findings**:
- **Light skin players** (84% of sample):
  - Red card rate: 1.24%
  - Red cards per game: 0.00419
- **Dark skin players** (16% of sample):
  - Red card rate: 1.32%
  - Red cards per game: 0.00465
- **Statistical Significance**: YES (p < 0.001)
  - Poisson model: 35.5% higher red card incidence for darker skin tone (IRR=1.36, p=0.0003)
  - Negative Binomial model: 34.2% higher incidence (IRR=1.34, p=0.0006)
  - Ratio (Dark/Light): 1.11x red cards per game

**Replication Findings**:

**YES** - Our LLM-generated analysis finds statistically significant evidence that soccer players with darker skin tone are more likely to receive red cards from referees (p < 0.001, 34-36% higher incidence).

**Comparison to Original Study**:
- **Original 29 teams**: 20 found significant positive effects (69%), 9 found non-significant effects (31%), 0 found negative effects
- **Team 30 (LLM)**: Finds significant positive effect, **aligning with the majority of human teams**
- **Effect size**: Team 30's 34-36% increase is in the upper range of original findings (typical range: 10-40%)
- **Methods**: Uses modern count regression (Poisson/Negative Binomial), similar to several original teams but with Python instead of R

**Does This Replicate the Original Study?**

**YES** - The LLM-generated analysis successfully replicates the core finding that skin tone is associated with red card decisions. The AI independently:
1. Selected appropriate statistical methods (count regression models)
2. Controlled for relevant confounders (games played)
3. Found results consistent with the majority of human analysts
4. Identified similar methodological limitations

This demonstrates that by 2025, LLMs can conduct statistical analyses that reach similar conclusions to human researchers.

However, human oversight remains essential for validating statistical choices, ensuring ethical considerations, and contextualizing findings within the broader literature.

**Critical Disclaimer**: As the authors of this experiment, we lack advanced training in statistical analysis and cannot independently verify the correctness of the model selection, assumptions, diagnostics, or interpretations. This analysis represents an exploration of LLM capabilities but should **not be considered peer-reviewed or validated**. Statistical experts should critically examine:
- Model appropriateness for this data structure
- Proper handling of clustering/repeated measures
- Validity of diagnostics
- Completeness of confounding variable considerations
- Accuracy of effect size interpretations

**Limitations**:
1. Observational data - causation cannot be definitively established
2. Skin tone measured by raters viewing photos, not objective measurement
3. Potential confounding variables (playing style, position, league)
4. Red cards are rare events (only 1.26% of observations)
5. Multiple observations per player may introduce clustering effects

**How to Run**:
```bash
# Using Docker and Make (recommended, like other teams)
make

# Or manually with Docker
docker build -t repro-30 .
docker run -v $(pwd)/dataset/data/CrowdstormingDataJuly1st.csv:/app/dataset/data/CrowdstormingDataJuly1st.csv repro-30

# Or directly with Python
pip install -r requirements.txt
python team-30.py
```

**Requirements**:
- Docker (for reproducible containerized execution)
- Or Python 3.x with: pandas, numpy, matplotlib, seaborn, scipy, statsmodels

### Variability Factors

The "Many Analysts" paradigm demonstrates how analytical choices affect results. Our Team 30 replication shows one particular set of choices made by an LLM. Future work could explore:

  | Variability Factor | Possible Values     | Impact on Team 30                                   |
  |--------------------|---------------------|----------------------------------------------------|
  | Skin Tone Threshold | 0.25, 0.5, 0.75    | We used 0.5; different cutoffs may change effect size |
  | Statistical Model   | OLS, Logistic, Poisson, NB | We used Poisson/NB; others might give different results |
  | Control Variables   | Games only, +Position, +League | We only controlled for games; more controls could reduce effect |
  | LLM Model          | GPT-4, Claude, Gemini | Different AI models might make different analytical choices |

- **Constraints Across Factors**:  
  - Document any constraints or interdependencies among variability factors.  
    For example:
    - Random Seed must align with dataset splits for consistent results.
    - Hardware constraints may limit the choice of GPU-based factors.

**Output**:
- Console: Full statistical results and findings
- File: `team-30-analysis.png` (6-panel visualization)
- Documentation: `TEAM-30-REPORT.md` (detailed analysis)

**Interpretation**: See the comparison to original study findings above.

## Conclusion
- Findings from the reproducibility and replicability sections :
  - **Reproducibility :**
    - the first challenge was to choose which team to focus on as some had incomplete or non functional code. We mostly focused on teams using R as programming language as they were the most numerous and had the most complete code. We also chose a team using python as it was a pretty straightforward code to run.
    - We then had trouble finding the right versions of R, outdated libraries and dependencies required by the original code. Every team had different versions and setups, making it challenging to create a unified environment. We spent significant time installing older versions of R and required libraries. We created some [Docker images](https://hub.docker.com/r/thebloodman/r-old) with R between versions 3.0.2 and 3.3.3 to accommodate different team requirements. R packages were also hard to install as the R package manager doesn't handle older package versions well.
    - Most teams if not all were missing code segments, particularly related to data cleaning, which hindered full reproduction of some analyses but also output transformation to get the exact statistics mentioned in the original paper. The values provided in the paper was correlation values with confidence intervals but most teams outputted either plots or huge text outputs that were hard to analyze.
    - We also lacked knowledge in statistics to fully understand and transform the outputs (we are not statisticians but code writers after all).
  - **Replicability :**
    - We created a new "team 30" using LLMs to replicate the "Many Analysts" experiment.
    - we mostly used AI-generated code to solve this analysis problem and we found statistically significant evidence that soccer players with darker skin tone are more likely to receive red cards from referees (p < 0.001, 34-36% higher incidence).
    - This aligns with the majority of human teams in the original study, demonstrating that modern LLMs can conduct statistical analyses comparable to human researchers
- Limitations of our work :
  - Time constraints limited the depth of our reproducibility and replicability efforts.
  - Lack of expertise in certain statistical methods hindered our ability to fully interpret and transform outputs.
  - Incomplete codebases from original teams made it challenging or event impossible for certain teams to achieve full reproducibility.
  - we had a very limited exploration of variability factors due to time constraints or material limitations (we only used linux systems with CPU, no GPU, same version of R,...).
