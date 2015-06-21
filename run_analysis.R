# Instructions:
  # You should create one R script called run_analysis.R that does the following. 
  # Merges the training and the test sets to create one data set.
  # Extracts only the measurements on the mean and standard deviation for each measurement. 
  # Uses descriptive activity names to name the activities in the data set. These are the six activity names that correspond to the integers 1-6.
  # Appropriately labels the data set with descriptive variable names. These are descriptive names for the columns, given in the features.txt file.
  # From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

# Data downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

# Training labels in y_train.txt correspond to one of
  # 1 WALKING
  # 2 WALKING_UPSTAIRS
  # 3 WALKING_DOWNSTAIRS
  # 4 SITTING
  # 5 STANDING
  # 6 LAYING
# as indicated in activity_labels.txt. 

# The entire process of the analysis is scripted under a single function call to which only a directory name (where the data set will be downloaded) is required.
# Alternatively, the directories can be changed manually, at lines 27, 28, and 33, and one can run the code one line at a time from line 25.
# Alternatively, if the user has already downloaded and unzipped the data, set the working directory to whatever directory contains the data, and step through the code from line 33.

run_analysis <- function(directory="~/Downloads"){
# Step 0: Acquiring the data. 
data.url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" # Link to data.
download.file(url=data.url, paste(directory, destfile="/UCI_HAR_DataSet.zip", sep=""), method="curl") # Download data. If running OS X 10.10.3, this should send the zip folder to the Downloads folder in your main user directory.
setwd(directory) # Set working directory to the directory where data is downloaded.
unzip("UCI_HAR_DataSet.zip", exdir="./") # Unzip data.

# From here, the working directory is assumed to be ".../UCI HAR Dataset/", and that are files are within the directories that result from unzipping the directory.

setwd(paste(directory, "/UCI HAR Dataset", sep="")) # Sets the working directory to where the downloaded data lives on the system.
wd <- getwd() # Gets the current working directory, assumed to be ".../UCI Har Dataset/", wherever that lives on your system.

# Step 1: Creating Merged Data

  setwd(paste(wd, "/train", sep="")) # Sets the current directory to the ".../UCI HAR Dataset/train/"
  train.data <- read.table("X_train.txt") # Reads in the training data.
  setwd(paste(wd, "/test", sep="")) # Sets the current directory to the ".../UCI HAR Dataset/test/"
  test.data <- read.table("X_test.txt") # Reads in the test data.
  merged.data <- rbind(train.data, test.data) # Creates a new dataframe by binding train.data and test.data along rows.
    # merged.data should contain 10299 rows and 561 variables (compare the "Number of Attributes" information at "http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones")


# Step 2: Add feature labels, and extract only the measurements on the mean and standard deviation for each measurement.
# This effectively accomplishes the "Appropriately labels the data set with descriptive variable names" requirement as well.

  setwd(wd) # Return to the main "UCI HAR Dataset" directory
  features <- read.table("features.txt") # Reads in the feature labels file
  feature.names <- as.vector(features$V2) # Extract the second column, containing the feature label names
  names(merged.data) <- feature.names # Add the column labels from the feature names vector. 
  meanSDcolumns <- grep("(mean\\(\\))|(std\\(\\))", names(merged.data)) # Use a regular expression to extract which column names refer to only to means and SDs. 
    # NB that a grep() in R requires a double escape "\\".  
  merged.data.new <- merged.data[, meanSDcolumns] # extract only the columns identified by the regular expression. 


# Note that every row (observation) in the merged training and test data is unique. This can be checked by running:
  # nrow(unique(merged.data)) == nrow(merged.data).

# Step 3: Add descriptive activity names.
# This requires reading in the text files containing the numeric code of each activity for each row in the training and testing data.

  setwd(paste(wd, "/train", sep=""))
  train.activities <- read.table("y_train.txt") # Read in the file with the numeric code for activities for each row of training data.
  setwd(paste(wd, "/test", sep=""))
  test.activities <- read.table("y_test.txt") # Read in the file with the numeric code for activities for each row of test data.
  merged.activities <- rbind(train.activities, test.activities) # Merge the two dataframes of numeric codes into a single frame.
    # The following six lines use the regular expression search and replace function gsub() to replace the numeric codes with the descriptive activity names given in activity_labels.txt
  merged.activities <- gsub("1", "WALKING", merged.activities$V1) # Must refer to column explicitly. Henceforth, merged.activities is a vector.
  merged.activities <- gsub("2", "WALKING_UPSTAIRS", merged.activities)
  merged.activities <- gsub("3", "WALKING_DOWNSTAIRS", merged.activities)
  merged.activities <- gsub("4", "SITTING", merged.activities)
  merged.activities <- gsub("5", "STANDING", merged.activities)
  merged.activities <- gsub("6", "LAYING", merged.activities)
  merged.data.withActivities <- cbind(merged.activities, merged.data.new) # Bind the vector with activity names for each row to the measurement data


# Step 4: Add labels for the experimental subjects.
# This requires reading in the text files containing the numeric code of each subject for each row in the training and testing data.

  setwd(paste(wd, "/train", sep="")) 
  train.subjects <- read.table("subject_train.txt") # Read in the file with the numeric code for subjects for each row of training data.
  setwd(paste(wd, "/test", sep=""))
  test.subjects <- read.table("subject_test.txt") # Read in the file with the numeric code for subjects for each row of test data.
  subjects.merged <- rbind(train.subjects, test.subjects) # Merge the two dataframes of numeric codes for subjects into a single frame.
  merged.data.Activities.Subjects <- cbind(subjects.merged, merged.data.withActivities) # Bind the dataframe with subject numbers to the main dataframe


names(merged.data.Activities.Subjects)[1:2] <- c("Subjects", "Activities") # Rename columns with Subjects and Activities

measurement.names <- names(merged.data.Activities.Subjects)[3:68] # Save the column names for the 66 different measurements
tidy.data <- data.frame() # Initialize and empty data frame that will ultimately hold all of the tidy data

for(Subject in as.vector(unique(merged.data.Activities.Subjects$Subjects))){ # Iterate over each of the 30 different possible subjects
  for(Activity in as.vector(unique(merged.data.Activities.Subjects$Activities))){ # Iterate over each of the 6 different possible activities
    temp.data <- merged.data.Activities.Subjects[which(merged.data.Activities.Subjects$Subjects == Subject & merged.data.Activities.Subjects$Activities == Activity), ] # Extract the rows with combination of Subject i and Activities j
    temp.data.means <- as.data.frame(sapply(temp.data[, 3:68], mean)) # Get the mean of each measurement
    temp.data.means <- as.data.frame(t(temp.data.means[,-2])) # Invert the rows of the previous data frame into columns
    names(temp.data.means) <- measurement.names # Add the column labels of measurements back
    temp.frame <- cbind(Subject, Activity, temp.data.means) # Make a temporary dataframe of 1 row and 68 columns by adding by the Subject and Activity columns
    tidy.data <- rbind(tidy.data, temp.frame) # Bind the data of the particular subejct/activity combination to the master tidy.data dataframe
  }
}

tidy.data <- tidy.data[order(tidy.data$Subject, tidy.data$Activity), ] # Order the rows by Subject first, Activity second. 
# Resulting tidy.data should have 180 rows (30x6 Subject and Activity combindations) and 68 columns (Subject, Activity, and 66 measurement columns).
setwd(wd) # Return to the main UCI HAR Dataset directory
write.table(tidy.data, file="tidy_data.txt", sep="\t", row.names=FALSE) # Write out the ordered dataframe without row names. 
# tidy_data.txt is now available in the main UCI HAR Dataset directory.
}
