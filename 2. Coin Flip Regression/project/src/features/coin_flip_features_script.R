library(data.table)

DT<-fread('./project/volume/data/raw/train_file.csv')
test <- fread('./project/volume/data/raw/test_file.csv')
test$result <- -1

fwrite(DT,'./project/volume/data/interim/train.csv')
fwrite(test,'./project/volume/data/interim/test.csv')
