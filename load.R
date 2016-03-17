library(tm)
library(SnowballC)
library(RColorBrewer)
library(wordcloud)

con <- file("data/en_US/sample.twitter.txt", "r")
twitterLines <- readLines(con)
close(con)

con <- file("data/en_US/sample.news.txt", "r")
newsLines <- readLines(con)
close(con)

con <- file("data/en_US/sample.blogs.txt", "r")
blogLines <- readLines(con)
close(con)

# Experiment with tm's corpus methods
twitter.corpus <- Corpus(VectorSource(twitterLines))
twitter.corpus <- tm_map(twitter.corpus, content_transformer(tolower))
twitter.corpus <- tm_map(twitter.corpus, removePunctuation)
twitter.corpus <- tm_map(twitter.corpus, removeNumbers)
#twitter.corpus <- tm_map(twitter.corpus, function(x) removeWords(x, stopwords("english")))
twitter.tdm <- TermDocumentMatrix(twitter.corpus)
twitter.m <- as.matrix(twitter.tdm)
twitter.v <- sort(rowSums(twitter.m),decreasing=TRUE)
twitter.d <- data.frame(word = names(twitter.v),freq=twitter.v)
#table(twitter.d$freq)

pal2 <- brewer.pal(8,"Dark2")
wordcloud(twitter.d$word,twitter.d$freq, scale=c(8,.2),min.freq=3,
          max.words=Inf, random.order=FALSE, rot.per=.15, colors=pal2)

# How many unique words do you need to capture 50% of the total word usage?
sum(twitter.d$freq[1:46]) >= length(twitter.d$word)*.5
# 90%?
sum(twitter.d$freq[1:141]) >= length(twitter.d$word)*.5
# TODO is there a functional way to do this?

# TODO How do we get 2-grams and 3-grams?
# http://stackoverflow.com/questions/8161167/what-algorithm-i-need-to-find-n-grams

# Sample the data and create a subset for training
# This is done with the unix command shuf -n 1000 en_US.blogs.txt > sample.blogs.txt
# I sample 3000 lines from Twitter so that the word count for each is ~35,000

#TODO filter profanity

# Figure out word frequency (This is better done with TermDocumentMatrix)
#words <- strsplit(twitterLines, "\\s")
#words <- lapply(words, str_replace_all, "\\W*$", "")
#words <- lapply(words, str_replace_all, "^\\W*", "")
#words <- unlist(words)

print(length(twitter.d$word))