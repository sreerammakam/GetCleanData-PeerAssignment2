## Peer Assignment2, reading Train and Test datasets and merging into one file with the required measures – std and mean.

## Step1, selecting the two colums with stg and mean into a new data frame
# Using feature.txt file to get the names and subset to features having mean or std in their names
dataset_features <- read.table("features.txt")
subset_features <- grep("std|mean", dataset_features $V2)

## Step2, read train and test folders having X axis files
# Get the train and test feature sets and subset only the desired features
dataset_train <- read.table("train/X_train.txt")
subset_train_features <- dataset_train[,subset_features]
dataset_test <- read.table("test/X_test.txt")
subset_test_features <- dataset_test[,subset_features]

## Step3, merging the two datasets into 1 using rbind function
merged_dataset_features <- rbind(subset_train_features, subset_test_features)

## Step4
# Attach column names to merged dataset
colnames(merged_dataset_features) <- dataset_features[subset_features, 2]

## Step 5
# Read and combine the train and test activity codes for the Y axis
y.train.dataset <- read.table("train/y_train.txt")
y.test.dataset <- read.table("test/y_test.txt")
y.total.dataset <- rbind(y.train.dataset, y.test.dataset)

## Step 6
# Get activity labels and attach to activity codes
activity.labels <- read.table("activity_labels.txt")
y.total.dataset$activity <- factor(y.total.dataset$V1, levels = activity.labels$V1, labels = activity.labels$V2)

# Step 7
# Get and combine the train and test subject ids
train.subjects <- read.table("train/subject_train.txt")
test.subjects <- read.table("test/subject_test.txt")
total.subjects <- rbind(train.subjects, test.subjects)

# Step 8
# Combine and name subjects and activity names
subjects.and.activities <- cbind(total.subjects, total.activities$activity)
colnames(subjects.and.activities) <- c("subject.id", "activity")

# Step 9
# Combine with measures of interest for finished desired data frame
activity.frame <- cbind(subjects.and.activities, merged_dataset_features)

# Compute New Result
# From the set produced for analysis, compute and report means of 
# all measures, grouped by subject_id and by activity.
result.frame <- aggregate(activity.frame[,3:81], by = list(activity.frame$subject.id, activity.frame$activity), FUN = mean)
colnames(result.frame)[1:2] <- c("subject.id", "activity")
write.table(result.frame, file="new_mean_measures.txt", row.names = FALSE)
