install.packages("wordcloud")
install.packages("RColorBrewer")
install.packages("tm")
library(wordcloud)
library(RColorBrewer)
library(tm)

wd <- getwd() #get working directory
filename <- paste0(wd,"/txt/blackrock.txt") #you can replace lazard.txt with blackrock.txt or nzs.txt or your own text file
corpus_txt <- Corpus(VectorSource(readLines(filename)))
#corpus pre-processing and cleanup
corpus_txt <- tm_map(corpus_txt, removeNumbers)
corpus_txt <- tm_map(corpus_txt, removePunctuation)
corpus_txt <- tm_map(corpus_txt, stripWhitespace)
corpus_txt <- tm_map(corpus_txt, content_transformer(tolower))
more_stop_words <- readLines(paste0(wd,"/txt/stopwords.txt")) #additional stop words on top of tm package's inbuilt stop words directory
corpus_txt <- tm_map(corpus_txt, removeWords, c(more_stop_words, stopwords("english")))

dtm <- TermDocumentMatrix(corpus_txt) 
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
df <- data.frame(word = names(words),freq=words)
#it's better to open a new device so that wordcloud does not get stripped due to the plot window size
dev.new(width = 1000, height = 1000, unit = "px")
wordcloud(words = df$word, freq = df$freq, min.freq = 1,
          max.words=100, random.order=FALSE, rot.per=0.15,           
          colors=brewer.pal(8, "Oranges"), font = 15)
