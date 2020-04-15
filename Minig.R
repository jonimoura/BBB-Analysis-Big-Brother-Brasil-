#Setting directory
setwd('D:/R/Mining_Twitter')

#API Twitter
api_key <- "EtT46PxqlzeLGW4vZRm65AonA"
api_secret_key <- "pYDbN3YGAkAe9PDvWwnmJ0kGAkqqNTxYxghIsK3CNI3ddTwKG6"
access_token <- "808835322004041730-DJp4SeI267Uv4n3r2cJspdSup0Gy9wN"
access_token_secret <- "jLNmSbGdXEMFfyL5LUq8RXrGXnxKTsvDKYEOY8K38NQsC"

#Load Libraries
library("rtweet")
library("openssl")
library("NLP")
library("httpuv")
library("tm")
library("stringr")
library("dplyr")
library("ROAuth")
library("base64enc")
library("base64url")
library("base64")


## authenticate via web browser
token <- create_token(
  app = "rstatsjournalismresearch",
  consumer_key = api_key,
  consumer_secret = api_secret_key)

## authenticate via web browser
token <- create_token(
  app = "rstatsjournalismresearch",
  consumer_key = api_key,
  consumer_secret = api_secret_key,
  access_token = access_token,
  access_secret = access_token_secret)

## check to see if the token is loaded
library(rtweet)


#Getting Tweets
tweets <- search_tweets(q = "#BBB", n = 10000, lang = "pt", include_rts = FALSE)
save_as_csv(tweets, "tweets_data.csv", prepend_ids=TRUE, fileEncoding="UTF-8")


#If token is invalid run this and restart the session
#file.remove(".httr-oauth")

#Build Corpus
library(NLP)
library(tm)

corpus <- iconv(tweets$text, from="UTF-8", to ="latin1//TRANSLIT")
corpus <- Corpus(VectorSource(corpus))
inspect(corpus[1:5])

#Clean text
corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
inspect(corpus[1:5])

#Remove words in english?
cleanset <- tm_map(corpus, removeWords, stopwords('english'))
#Remove URL bur before create an URL function
removeURL <- function(x) gsub('http[[:alnum:]]*','', x)
cleanset <- tm_map(cleanset, content_transformer(removeURL))
inspect(cleanset[1:5])

cleanset <- tm_map(cleanset, stripWhitespace)
inspect(cleanset[1:5])



#Remove Words
cleanset <- tm_map(cleanset, removeWords, c('eles', 'k', 'ª','bbb', 'o'))
cleanset <- tm_map(cleanset, removeWords, c('jf','kk', 'kkk', 'kkkk'))
cleanset <- tm_map(cleanset, removeWords, c('q', 'que'))
cleanset <- tm_map(cleanset, removeWords, c('você','ser', 'os', 'da', 'das', 'na', 'nas'))
cleanset <- tm_map(cleanset, removeWords, c('mais','mas', 'em', 'um', 'uma'))
cleanset <- tm_map(cleanset, removeWords, c('ã©','ã©', 'é'))
cleanset <- tm_map(cleanset, removeWords, c('quem','por','gente', 'isso','essa','ele','ela','muito'))
cleanset <- tm_map(cleanset, removeWords, c('sei','desse','bigbrother','muito'))
cleanset <- tm_map(cleanset, removeWords, c('com','tem','bbbb','ainda', 'vez', 'fez', 'meu', 'pelo', 'quer'))
cleanset <- tm_map(cleanset, removeWords, c('casa','para','sendo','pra','vou', 'vcs', 'redebbb', 'bbbo', 'big'))
cleanset <- tm_map(cleanset, removeWords, c('que','vai','já','tá','esse','bbboo','é','pro','não','assim', 'cada'))
cleanset <- tm_map(cleanset, stripWhitespace)

inspect(cleanset[1:5])

#Term Document Matrix
tdm <- TermDocumentMatrix(cleanset)
tdm
tdm <- as.matrix(tdm)
tdm[1:10, 1:20]

#Bar Plot
w <- rowSums(tdm)
w <- subset(w, w>=50)
barplot(w,
        las = 2,
        col = rainbow(50))

#Wordcloud
library(RColorBrewer)
library(wordcloud)
w <- sort(rowSums(tdm), decreasing = TRUE)
set.seed(111)
wordcloud(words = names(w),
          freq = w,
          max.words = 100,
          random.order = F,
          min.freq = 20,
          colors = brewer.pal(6, 'Dark2'),
          scale = c(5, 0.3),
          rot.per = 0.3)

