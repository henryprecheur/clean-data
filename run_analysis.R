features = read.table("features.txt")
activity_labels = read.table("activity_labels.txt")

load.dataset = function(path) {
        # First we read the feature values
        x = read.table(sprintf("%s/X_%s.txt", path, path))
        # Rename the columns of the value set to be meaningfull labels instead
        # of V1, V2, V3...
        colnames(x) = features$V2

        # Only get the mean & std values as required by the assignement
        x = x[,grep("(mean|std)\\(\\)", colnames(x))]

        # Load the activity label index
        y = read.table(sprintf("%s/y_%s.txt", path, path))

        # Add an index so we can reorder the data after the merge
        y$orderid = 1:nrow(y)

        activities = merge(activity_labels, y)
        # Re-order the activities so it match the subjects & values
        activities = activities[order(activities$orderid),]

        subjects = read.table(sprintf("%s/subject_%s.txt", path, path))
        # y = read.table(sprintf("%s/y_%s.txt", path, path))
        data.frame(
                   "subject_id"=subjects$V1,
                   "activity"=activities$V2,
                   x
        )
}

# Load the 2 datasets
test = load.dataset("test")
train = load.dataset("train")

# Concatenate the data together
rbind(test, train)
