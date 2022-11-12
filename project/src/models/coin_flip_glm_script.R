library(caret)
library(data.table)
library(Metrics)
library(glmnet)
library(plotmo)
library(lubridate)

train <- fread('./project/volume/data/interim/train.csv')
test <- fread('./project/volume/data/interim/test.csv')
samp <- fread('./project/volume/data/raw/samp_sub.csv')

train_y <- train$result

dummies <- dummyVars(result ~ ., data = train)
train<-predict(dummies, newdata = train)
test<-predict(dummies, newdata = test)

train<-data.table(train)
test<-data.table(test)

########################
# Use cross validation #
########################
train<-as.matrix(train)
test<-as.matrix(test)

gl_model<-cv.glmnet(train, train_y, alpha = 1,family="gaussian")

bestlam<-gl_model$lambda.min


####################################
# fit the model to all of the data #
####################################

#now fit the full model

#fit a logistic model
gl_model<-glmnet(train, train_y, alpha = 1,family="gaussian")

plot_glmnet(gl_model)

#save model
saveRDS(gl_model,"./project/volume/models/gl_model.model")

test<-as.matrix(test)

#use the full model
pred<-predict(gl_model,s=bestlam, newx = test)

bestlam
predict(gl_model,s=bestlam, newx = test,type="coefficients")
gl_model

samp$result <- pred
fwrite(samp,"./project/volume/data/processed/submit_glm_cv.csv")


##############################
# Logistic Model before 9.19 #
##############################

# glm_model<-glm(result~.,family=binomial,data=train)
# summary(glm_model)
# coef(glm_model)

# saveRDS(dummies,"./project/volume/models/coin_flip_glm.dummies")
# saveRDS(glm_model,"./project/volume/models/coin_flip_glm.model")


# test$result<-predict(glm_model,newdata = test,type="response")
# submit<-test[,.(id, result)]
# fwrite(submit,"./project/volume/data/processed/submit_glm.csv")


