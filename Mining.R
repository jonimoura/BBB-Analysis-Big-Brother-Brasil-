#Setting directory
setwd('___your directory_____')

#API Twitter
api_key <- "XXXXX"
api_secret_key <- "XXXXX"
access_token <- "XXXXXX"
access_token_secret <- "XXXXX"

#Load Libraries
library("rtweet")
library("ROAuth")

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

