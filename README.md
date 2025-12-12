# Many Analysts Reproducibility and Replicability Report

## Introduction

This repository contains the reproducibility and replicability report for the "Many Analysts" study. The goal is to assess whether the original study's results can be reproduced using the same data and methods, and whether similar results can be obtained when varying certain factors.

The many analysts study involves multiple analysts independently analyzing the same dataset to answer a specific research question : "Are soccer players with dark skin tone more likely than those with light skin tone to receive red cards from referees?"

This report is structured into two main sections: Reproducibility and Replicability.

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
- To fix these issues, we:
  - Focused on teams with more complete and functional codebases, mostly arround teams using R as programming language.
  - Spent significant time installing older versions of R and required libraries. We created some [Docker images](https://hub.docker.com/r/thebloodman/r-old) with R between versions 3.0.2 and 3.3.3 to accommodate different team requirements.
  - Made necessary code modifications to ensure compatibility with the installed library versions.

-------- TODO --------

### Is the Original Study Reproducible?
- Success or failure of reproducing the study for the selected teams :
| Team | Status     | Comment                                   |
  |--------------------|---------------------|--------------------------------------------|
  | 3        | Not reproducible       | We can't figure out how to use "stan"  |
  | 5        | Not reproducible       | "Car" library has a lot of compatibility issues with other libraries, there is an error in the code |
  | 7        | Sort of Reproducible   | With great effort to find old libraries and some changes to the code we output a png |
  | 9        | Not reproducible       | We are missing code               |
  | 12       | Not reproducible       | We are missing the "data cleaning" code |
  | 13       | Sort of Reproducible   | Too many output....                     |
  | 25       | Reproducible           | Added missing library imports             |
  | 27       | Reproducible           | Python is better than R                  |
  | 28       | Not reproducible       | Running for a LOOONG time but no output  |
-------- TODO --------
- 7 :
  - The code outputs a png file instead of a value as written in the paper.
  - We couldn't find the "1.71" correlation value mentioned in the original paper.
  - We assume the output png is correct as it seems to visually matches the value but there might be an alternative code not provided to compute the exact value.
- 13 :
  - The code runs successfully and produces results... but the result is 340k lines of text which is impractical to analyze.
  - We tried to filter the output to find the relevant values but couldn't locate the specific statistics mentioned in the original paper.
- 25 :
- 27 :

## Replicability

### Variability Factors
- **List of Factors**: Identify all potential sources of variability (e.g., dataset splits, random seeds, hardware).
  | Variability Factor | Possible Values     | Relevance                                   |
  |--------------------|---------------------|--------------------------------------------|
  | Random Seed        | [0, 42, 123]       | Impacts consistency of random processes    |
  | Hardware           | CPU, GPU (NVIDIA)  | May affect computation time and results    |
  | Dataset Version    | v1.0, v1.1         | Ensures comparability across experiments   |

- **Constraints Across Factors**:  
  - Document any constraints or interdependencies among variability factors.  
    For example:
    - Random Seed must align with dataset splits for consistent results.
    - Hardware constraints may limit the choice of GPU-based factors.

- **Exploring Variability Factors via CLI (Bonus)**  
   - Provide instructions to use the command-line interface (CLI) to explore variability factors and their combinations:  
     ```bash
     python explore_variability.py --random-seed 42 --hardware GPU --dataset-version v1.1
     ```
   - Describe the functionality and parameters of the CLI:
     - `--random-seed`: Specify the random seed to use.
     - `--hardware`: Choose between CPU or GPU.
     - `--dataset-version`: Select the dataset version.


### Replication Execution
1. **Instructions**  
   - Provide detailed steps or commands for running the replication(s):  
     ```bash
     bash scripts/replicate_experiment.sh
     ```

2. **Presentation and Analysis of Results**  
   - Include results in text, tables, or figures.
   - Analyze and compare with the original study's findings.

### Does It Confirm the Original Study?
- Summarize the extent to which the replication supports the original study’s conclusions.
- Highlight similarities and differences, if any.

## Conclusion
- Recap findings from the reproducibility and replicability sections.
- Discuss limitations of your work
