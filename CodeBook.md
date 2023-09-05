## Code Book

`run_analysis.R` gets, merges, and cleans the Human Activity raw dataset and returns a new dataset according to the project requirements.

1. **Download raw dataset**
    - Download raw dataset from url and unzip to `UCI HAR Dataset` folder

2. **Read raw datasets**
    - `features` <- `features.txt`: (561 x 2)
        - Lists the 561 features available
    - `activitylabels` <- `activity_labels.txt`: (6 x 2)
        - Links the class labels with their activity name
    - `subjecttest` <- `test/subject_test.txt`: (2947 x 1)
        - Each row identifies the subject who performed the activity for each window sample in testing
    - `xtest` <- `test/X_test.txt`: (2947 x 561)
        - Test set of 2947 recorded feature observations
    - `ytest` <- `test/y_test.txt`: (2947 x 1)
        - Test set of activity labels for each observation in `xtest`
    - `subjecttrain` <- `train/subject_train.txt`: (7352 x 1)
        - Each row identifies the subject who performed the activity for each window sample in training
    - `xtrain` <- `train/X_train.txt`: (7352 x 561)
        - Training set of 7352 recorded feature observations
    - `ytrain` <- `train/y_train.txt`: (7352 x 1)
        - Training set of activity labels for each observation in `xtrain`
        
3. **Merge test and training sets together**
    - `xdata` (10299 x 561): merging `xtest` and `xtrain` using `rbind()`
    - `ylabels` (10299 x 1): merging `ytest` and `ytrain` using `rbind()`
    - `subjects` (10299 x 1): merging `subjecttest` and `subjecttrain` using `rbind()`
    - `mergeddata` (10299 x 563): merging `subjects`, `ylabels`, and `xdata` using `cbind()`
    
4. **Extract measurements of mean and standard deviation**
    - `tidydata` (10299 x 88): subset of `mergeddata` using `dplyr::select()` on columns `subject`, `code`, and columns containing the strings "mean" and "str" using `dplyr::contains()`
    
5. **Use descriptive activity names instead of activity labels**
    - `code` column of `tidydata` replaced with corresponding `activity` value from `activitylabels` using `dplyr::mutate()`
    - `code` column of `tidydata` renamed to `activity` using `dplyr::rename()`
6. **Appropriately label data set with descriptive variable names**
    - rename columns using `gsub()`
        - `Acc` to `Accelerometer`
        - `Gyro` to `Gyroscope`
        - `Mag` to `Magnitude`
        - `BodyBody` to `Body`
        - `mean()` to `Mean`
        - `meanFreq()` to `Frequency
        - `std()` to `STD`
        - starting character `t` to `Time`
        - starting character `f` to `Frequency`
7. **Create second data set with average of each variable for each activity and each subject**
    - `meandata` (180 x 88): taking the mean of each column using `dplyr::summarise_all()`, after using `dplyr::group.by()` on `subject` and `activity`
    - write `meandata` to `meandata.txt` using `write.table()`
