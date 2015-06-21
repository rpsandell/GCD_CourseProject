## **README for "Getting and Cleaning Data" Course Project**

**Files contained in this repository:**
  * run_analysis.R -- a script containing a single function ```run_analysis()```, which accepts a directory as an input, where data will be downloaded and code for producing the tidy data run. Alternatively, the user can run the individual lines of code within the function.
  * tidy_data.txt -- a tab-delimited text file that is the output of the function contained in run_analysis.R.
  * CodeBook.md -- information on variables contained in tidy_data.txt.

# **Objective:**  *Create a tidy data based on wearable computing data collected from Samsung Galaxy S smartphones available at the UCI Machine Learning Repository.*

**Desired properties of the tidy data set:**
  * has a descriptive label for each predictor variable.
  * reduced to only to predictory variables relating to means and standard deviations.
  * contains a single row for each possible subject and activity combination; each predictor variable for that combination is the mean of all data points in the raw data with that combination of subject and activity.

**Process followed in run_analysis.R:**
  0. Downloads and unzips wearable computing data.
  1. Merges testing and training data by binding together dataframes read in from *X_train.txt* and *X_test.txt.*
  2. Adds all predictor variable labels from *features.t* as the column names for the merged data.
  3. Uses a regular expression to identify predictor variables relating to mean and standard deviation data.
  4. Adds a column with activity labels by adding the corresponding numeric codes contained in *y_train.txt* and *y_test.txt* (using the same merging procedure as in 1. above), and using a regular expression search and replace function to replace those numeric codes (1–6) with labels ("WALKING", "SITTING", etc.).
  5. Adds labels for experimental subjects from *subject_train.txt* and and *subject_test.txt* (using the same merging procedure as in 1. above).
  6. Iterates over the full dataset to create temporary dataframes with each possible subject/activity combination, take the mean of each predictor variable, and insert the resulting single row into a dataframe for the tidy data.
  7. Order the tidy dataframe by subject and activity.
  8. Write out the dataframe as a tab-delimited text file, *tidy_data.txt*.



