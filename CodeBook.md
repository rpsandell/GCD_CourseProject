## **Variables Contained in *tidy_data.txt*

# Columns 1 and 2 contain:
  * **Subject**: an integer in the range 1–30, each corresponding to one of thirty distinct experimental subjects.
  * **Activity**: a factor with six different possible values, corresponding to the state of the subject when measurements in columns 3–68 were taken.
    - SITTING
    - STANDING
    - LAYING
    - WALKING
    - WALKING_DOWNSTAIRS
    - WALKING_UPSTAIRS

# Columns 3–68 contain: 
  * floating point numbers in the range -1 to 1, corresponding to measurements taken on a given subject in a given activity state. These values are means of a series of measurements taken on each subject in a given state. 
  * the column labels correspond to the mean and standard deviation of one of 17 different measurements; eight of these different measurements are taken along three distinct axes (indicated here with XYZ):
    - tBodyAcc-XYZ
    - tGravityAcc-XYZ
    - tBodyAccJerk-XYZ
    - tBodyGyro-XYZ
    - tBodyGyroJerk-XYZ
    - tBodyAccMag
    - tGravityAccMag
    -tBodyAccJerkMag
    - tBodyGyroMag
    - tBodyGyroJerkMag
    - fBodyAcc-XYZ
    - fBodyAccJerk-XYZ
    - fBodyGyro-XYZ
    - fBodyAccMag
    - fBodyAccJerkMag
    - fBodyGyroMag
    - fBodyGyroJerkMag

Intermediate dataframes created in the process of preparing the tidy data file contain many addition columns, representing other statistics taken across these measurement types. See further the features_info.txt file in the UCI HAR Dataset.