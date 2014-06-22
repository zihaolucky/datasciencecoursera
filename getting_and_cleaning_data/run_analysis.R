getdata <- function(type){
    features <- read.table('features.txt',stringsAsFactors = F)
    X <- read.table(sprintf('%s/X_%s.txt',type,type),col.names = features[,2])
    y <- read.table(sprintf('%s/y_%s.txt',type,type),col.names = c('activityCode'))
    subject <- read.table(sprintf('%s/subject_%s.txt',type,type),col.names = c('subject'))
    cbind(X,y,subject)
}

train <- getdata('train')
test <- getdata('test')
data <- rbind(train,test)
colfilter <- grep('mean|std|activity|subject',colnames(data))
data <- data[colfilter]

activity_labels <- read.table('activity_labels.txt',col.names<-c('activityCode','activity'))

data.merged <- merge(x = data, y = activity_labels, by = 'activityCode')
data.grouped <- aggregate(. ~ activity + subject, data = data.merged, FUN = mean)

write.table(data.merged, 'cleaned_data.txt', row.names = F)
write.table(data.grouped, 'avg_stat.txt', row.names = F)
