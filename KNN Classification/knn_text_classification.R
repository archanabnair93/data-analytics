
# Author: Archana Balachandran

# Installing and loading required packages

install.packages("tm")
library(tm)
install.packages("SnowballC")
library(SnowballC)
install.packages("wordcloud")
library(wordcloud)
install.packages("class")
library(class)

# Saving the directory source for sci.space.test folder to Temp1 - 394 files
Temp1 <- DirSource("//Mac/Home/Documents/R/win-library/3.3/tm/texts/sci.space.test")
Temp1$filelist[1:100] #verifying that the correct file path is displayed

# Saving the directory source for rec.autos test folder to Temp2 -396 files
Temp2 <- DirSource("//Mac/Home/Documents/R/win-library/3.3/tm/texts/rec.autos.test")

# Saving the directory source for sci.space.train folder to Temp3 - 593 files
Temp3 <- DirSource("//Mac/Home/Documents/R/win-library/3.3/tm/texts/sci.space.train")

# Saving the directory source for rec.autos.train folder to Temp4 - 594 files
Temp4 <- DirSource("//Mac/Home/Documents/R/win-library/3.3/tm/texts/rec.autos.train")

# TASK a 

# Creating the corpus for sci.space.train with 100 elements/files
Doc1.Train <- Corpus(URISource(Temp3$filelist[1:100]),readerControl=list(reader=readPlain))

# Creating the corpus for sci.space.test with 100 elements/files
Doc1.Test <- Corpus(URISource(Temp1$filelist[1:100]),readerControl=list(reader=readPlain))

# Creating the corpus for rec.autos.train with 100 elements/files
Doc2.Train <- Corpus(URISource(Temp4$filelist[1:100]),readerControl=list(reader=readPlain))

# Creating the corpus for rec.autos.test with 100 elements/files
Doc2.Test <- Corpus(URISource(Temp2$filelist[1:100]),readerControl=list(reader=readPlain))

# TASK b : Merging all of 4 Corpora into 1 Corpus so all pre processing steps can be implemented at once and create one DTM.

# Obtaining merged corpus


Doc.Corpus<-c(Doc1.Train,Doc1.Test,Doc2.Train,Doc2.Test)

# TASK c :Implementing Preprocessing 
# NOTE:  original Doc.Corpus is preserved for backtracking purposes, doc.tranf will undergo transformations

# converting the text to lowercase
# removing numbers and punctuation
# removing stop words, stemming, and identifying synonyms

getTransformations()
content_transformer()

#Studying a sample document to understand what patterns to eliminate
doc.tranf[[1]]$content[1:10]

#To apply transformations across all documents within a corpus, using tm_map()

# 1 Transforming to lower case
doc.tranf <-tm_map(Doc.Corpus,content_transformer(tolower))
doc.tranf[[1]]$content[1:10]

# 2 Transforming @,-,: to white space
transform.char<-content_transformer(function(x,pattern) gsub(pattern," ",x))
doc.tranf <-tm_map(doc.tranf, transform.char,"@|:|-")
doc.tranf[[1]]$content[1:10]

# Stripping whitespace
doc.tranf <-tm_map(doc.tranf, stripWhitespace)
doc.tranf[[1]]$content[1:10]

# 3 Removing punctuation - removes , and .
doc.tranf <- tm_map(doc.tranf,removePunctuation)
doc.tranf[[1]]$content[1:10]



# 4 Removing stop words

doc.tranf <- tm_map(doc.tranf,removeWords,stopwords("english"))
doc.tranf[[1]]$content[1:10]

# 5. Removing numbers
doc.tranf <- tm_map(doc.tranf,removeNumbers)
doc.tranf[[1]]$content[1:10]

# Performing STEMMING
doc.tranf <-tm_map(doc.tranf,stemDocument)
doc.tranf[[1]]$content[1:10]




# TASK d: CREATING DOCUMENT TERM MATRIX

# A document-term matrix is a matrix with documents as the rows, 
# terms as the columns, and a count of the frequency of words as the cells. 
# In the tm package, DocumentTermMatrix() is used to create this matrix. 
# To inspect the document-term matrix, inspect() is used.
# SOURCE: onlinecampus.bu.edu/CS688/module3

?DocumentTermMatrix


dtm = DocumentTermMatrix(doc.tranf, 
                                   control = list(minWordLength = 2,
                                                  minDocFreq = 5)) 
inspect(dtm)
# exploring the documentterm matrix
freq<-colSums(as.matrix(dtm)) # Term frequencies
ord<-order(freq) # Ordering frequencies
freq[tail(ord)] # most frequent terms
findFreqTerms(dtm,lowfreq = 400) # finding frequent terms having at least 200  occurrences
set.seed(123)
wordcloud(names(freq),freq,min.freq = 200, colors = brewer.pal(5,"Accent"))

# Removing Sparse terms from DocumentTermMatrix with sparse=0.60
removeSparseTerms(dtm, 0.60)
?removeSparseTerms

#saving dtm as simple matrix
matdtm <- as.matrix(dtm)
write.csv(matdtm,file="dtm.csv")
ncol(matdtm)

# TASK e: Splitting Document Term Matrix into training and testing datasets
# Splitting DocumentTermMatrix into train dataset and verifying
matdtm[c(1:100),]
train.dataset<-rbind(matdtm[c(1:100),],matdtm[c(201:300),])
View(train.dataset[c(1:200),c(1:4)])

# Splitting DocumentTermMatrix into test dataset and verifying

test.dataset <-rbind(matdtm[c(101:200),],matdtm[c(301:400),])
View(test.dataset[c(1:200),c(1:4)])

#TASK f: CREATING tags using rep()

nrow(test.dataset)
nrow(train.dataset)
ncol(test.dataset)
ncol(train.dataset)
Tags <- factor(c(rep("Sci",100),rep("Rec",100)))

# TASK g: Classifying text using KNN from package class

prob.test <- knn(train.dataset, test.dataset, Tags, k = 2, prob=TRUE)

# TASK h: Analyzing the output of knn()


a<-1:length(prob.test)
a
b<-levels(prob.test)[prob.test]
b
c<-attributes(prob.test)$prob
c
result<-data.frame(Doc=a, Predict=b, Prob=c, Correct=(prob.test==Tags))
result


sum(c)/length(Tags) # Overall probability


sum(prob.test==Tags)/length(Tags) # Percentage of TRUE/Correct classifications
