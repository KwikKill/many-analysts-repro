# beware whitespace issues

import pandas
import numpy as np 
import statsmodels.api as sm
from patsy import dmatrices
import csv
import scipy.stats as s  # Import scipy library
import matplotlib.pyplot as p  # Import for visualizations


def test_ratings():

    # Load data & create list of dicts
    data_reader = csv.DictReader(open('./data/crowdstorming.csv', 'r'))   # Open datafile
    data = []
    for c,row in enumerate(data_reader):    # Create list of dics from csv_reader
        data.append(row)

    # Check IRR of ratings
    rater1 = [float(row["rater1"]) for row in data if "NA" not in [row["rater1"],row["rater2"]]]
    rater2 = [float(row["rater2"]) for row in data if "NA" not in [row["rater1"],row["rater2"]]]
    # Print results of scipy's normality test (based off D'Agostino-Pearson normality test)
    print s.stats.normaltest(rater1, axis=0)
    print s.stats.normaltest(rater2, axis=0)
    # Histogram
    p.figure(1)
    n, bins, patches = p.hist(rater1,bins=5,range=(0,5))
    p.figure(2)
    n, bins, patches = p.hist(rater2,bins=5,range=(0,5))    
    p.show()
    # They are NOT normally distrbuted, so we'll use Spearman's rho
    print "Spearman: ", s.spearmanr(rater1,rater2)
    # Yes, highly correlated!

#test_ratings()  # run once, then comment out

#Load dataset
df = pandas.read_csv("./data/crowdstorming.csv")
keys = ['playerShort','refNum','games','goals','yellowCards','redCards','meanIAT','meanExp', 'rater1', 'rater2']
df = df[keys]

# Drop NA ratings and make an average
df = df.dropna(subset=['rater1','rater2'])
df['rating'] = (df['rater1'] + df['rater2'])
2

df['meanIAT'] = df['meanIAT'] * 100
df['meanExp'] = df['meanExp'] * 100

# Check variance and means for Poisson distribution
print "variance: ", df['redCards'].var()
print "mean: ", df['redCards'].mean()

# Test Question 1

print "QUESTION 1"

# Define x and y variables
y, X = dmatrices('redCards ~ rating + rating*games + rating*goals + rating*yellowCards + rating*meanIAT + rating*meanExp', data=df, return_type='dataframe')

# Create + fit poisson model
poisson_mod = sm.Poisson(y, X)
poisson_res = poisson_mod.fit()
print poisson_res.summary()

# Test Question 2a

print "QUESTION 2a"
print "len pre-drop: ", len(df)
df_2a = df.dropna(subset=['meanIAT'])
print "len pre-drop: ", len(df_2a)

# Define x and y variables
y, X = dmatrices('redCards ~ meanIAT + meanIAT*rating + meanIAT*games + meanIAT*goals + meanIAT*yellowCards + meanIAT*meanExp', data=df_2a, return_type='dataframe')

# Create + fit poisson model
poisson_mod = sm.Poisson(y, X)
poisson_res = poisson_mod.fit()
print poisson_res.summary()

# Test Question 2b

print "QUESTION 2b"

print "len pre-drop: ", len(df)
df_2b = df.dropna(subset=['meanExp'])
print "len pre-drop: ", len(df_2b)

# Define x and y variables
y, X = dmatrices('redCards ~ meanExp + meanExp*rating + meanExp*games + meanExp*goals + meanExp*yellowCards + meanExp*meanIAT', data=df_2b, return_type='dataframe')

# Create + fit poisson model
poisson_mod = sm.Poisson(y, X)
poisson_res = poisson_mod.fit()
print poisson_res.summary()
