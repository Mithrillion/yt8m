require(ggplot2)
require(reshape2)
require(plyr)
# require(dplyr)

label.names <- read.csv("../label_names.csv")
head(label.names)

video.labels <- read.csv("../train_labels.csv", header = F)
head(video.labels)

colnames(video.labels) <- c("video_id", "video_class")
head(video.labels)

char.labels <- as.character(video.labels$video_class)
head(char.labels)

split.labels <- sapply(char.labels, function(x) strsplit(x, " "))
head(split.labels)

# now we combine all tags for a global count
all.labels <- do.call(c, split.labels)
head(all.labels)
length(all.labels)

label.counts <- table(all.labels)
label.counts <- sort(label.counts, decreasing = T)
label.counts

label.names.with.counts <- label.names
label.names.with.counts['counts'] <- label.counts[as.character(label.names.with.counts[['label_id']])]
head(label.names.with.counts)

# first visualise the top video tags overall
ggplot(data = label.names.with.counts[1:15,], aes(x = reorder(label_name, -counts), y = counts)) + geom_bar(stat = "identity")

# now we convert the video.labels table into long format
video.labels.split <- video.labels

# experiment on small set first
small.split <- head(video.labels.split)
small.split
temp.row <- sapply(small.split, function(x) strsplit(as.character(x), " "))
temp.row[1, ]
temp.row[1, ][[1]]
temp.row[1, ][[2]]
as.matrix(temp.row[1, ][[2]])
matrix(as.vector(temp.row[1, ][[1]]), as.matrix(temp.row[1, ][[2]]))

temp.row
temp.expand <- apply(temp.row, 1, function(r) {
  df <- data.frame(rep(r[[1]], length(r[[2]])))
  colnames(df)[1] <- 'video_id'
  df['label'] <- r[2]
  df
})
temp.expand
temp.reduced <- do.call(rbind, temp.expand)
temp.reduced

# now work on the real set
video.labels.long <- do.call(rbind, apply(sapply(video.labels.split, function(x) strsplit(as.character(x), " ")), 1, function(r) {
  df <- data.frame(rep(r[[1]], length(r[[2]])))
  colnames(df)[1] <- 'video_id'
  df['label'] <- r[2]
  df
}))
