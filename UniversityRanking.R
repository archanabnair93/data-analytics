
#Author: Archana Balachandran

#Categorical Data Analysis
country.data<-UniRanking$country
table(UniRanking$country) #majority in the US


# Multiple histograms for numerical data analysis

#par(mfrow=c(3, 3))
hist(UniRanking$quality_of_education) 
hist(UniRanking$score) #exponential distribution
dotchart(UniRanking$score, col="red3", xlab="Score", main="Aggregation of Scores")
barplot(table(UniRanking$country),ylim = c(0,60), las=2,main="Country-wise ranking")

#Examining score in USA -country with maximum number of top universities

usa.score <- subset(UniRanking, country=="USA", select=(c("score")))
dotchart(usa.score$score, col="red3", xlab="University Score", main="Score of Universities in USA")
boxplot(usa.score$score, xaxt="n", horizontal=TRUE, col="red3",xlab="University Score", main="Score of Universities in USA")
axis(side=1, at=fivenum(usa.score$score), labels=TRUE, las=2)

#Comparing scores in Top 3 countries

usa.score <- subset(UniRanking, country=="USA", select=(c("score")))
uk.score <- subset(UniRanking, country=="United Kingdom", select=(c("score")))
france.score <-subset(UniRanking,country=="France",select=(c("score")))
boxplot(usa.score$score, uk.score$score, france.score$score, names=c("USA", "UK","France"), col=heat.colors(3), horizontal=TRUE)


all.mean <- mean(UniRanking$score)
all.sd <- sd(UniRanking$score)
all.pdf <- dnorm(UniRanking$score, mean=all.mean, sd=all.sd)

usa.score <- subset(UniRanking, country=="USA", select=(c("score")))
uk.score <- subset(UniRanking, country=="United Kingdom", select=(c("score")))
france.score <- subset(UniRanking, country=="France", select=(c("score")))

#distribution of scores in USA

usa.score<- subset(UniRanking, country=="USA", select=(c("score")))
usa.mean <- mean(usa.score$score)
usa.sd <- sd(usa.score$score)
usa.pdf <- dnorm(usa.score$score, mean=usa.mean, sd=usa.sd)
plot(usa.score$score, usa.pdf, type="p", col="red", xlab="USA Scores", main="Scores in US Universities", xlim=c(usa.mean-3*usa.sd, usa.mean+3*usa.sd))

#Comparing scores across USA,United Kingdom,France - Compare SD and shape of curve


all.mean <- mean(UniRanking$score)
all.sd <- sd(UniRanking$score)
all.pdf <- dnorm(UniRanking$score, mean=all.mean, sd=all.sd)
all.sd
usa.score <- subset(UniRanking, country=="USA", select=(c("score")))
uk.score <- subset(UniRanking, country=="United Kingdom", select=(c("score")))
france.score <- subset(UniRanking, country=="France", select=(c("score")))

usa.mean <- mean(usa.score$score)
usa.sd <- sd(usa.score$score)
usa.pdf <- dnorm(usa.score$score, mean=usa.mean, sd=usa.sd)
usa.sd
uk.mean <- mean(uk.score$score)
uk.sd <- sd(uk.score$score)
uk.pdf <- dnorm(uk.score$score, mean=uk.mean, sd=uk.sd)
uk.sd
france.mean <- mean(france.score$score)
france.sd <- sd(france.score$score)
france.pdf <- dnorm(france.score$score, mean=france.mean, sd=france.sd)
france.sd

plot(usa.score$score, usa.pdf, type="p", col="red", xlim=c(40,100), ylim=c(0.0, 0.04), xlab="USA score", ylab="Probability Density Function", main="Score across Countries")
lines(uk.score$score, uk.pdf, type="p", col="blue")
lines(france.score$score, france.pdf, type="p", col="green")
lines(UniRanking$score, all.pdf, type="p", col="black")




#Central Limit Theorem

par(mfrow = c(2,2))
set.seed(150)
samples <- length(usa.score$score)
sample.data <- numeric(samples)
sample.size = 20
for (i in 1:samples) {
  sample.data[i] <- mean(rnorm(sample.size, mean=usa.mean, sd=usa.sd))
}
hist(sample.data, prob = TRUE, breaks=15, xlim=c(50,70), ylim=c(0.0,0.7),  xlab="Scores", main=paste("Sample size = ", sample.size), col="red")
mean(sample.data) 
sd(sample.data) 


sample.size = 40
for (i in 1:samples) {
  sample.data[i] <- mean(rnorm(sample.size, mean=usa.mean, sd=usa.sd))
}
hist(sample.data, prob = TRUE, breaks=15, xlim=c(50,70), ylim=c(0.0,0.7),  xlab="Scores", main=paste("Sample size = ", sample.size), col="red")
mean(sample.data) 
sd(sample.data) 


sample.size = 60
for (i in 1:samples) {
  sample.data[i] <- mean(rnorm(sample.size, mean=usa.mean, sd=usa.sd))
}
hist(sample.data, prob = TRUE, breaks=15, xlim=c(50,70), ylim=c(0.0,0.7),  xlab="Scores", main=paste("Sample size = ", sample.size), col="red")
mean(sample.data) 
sd(sample.data) 

sample.size = 80
for (i in 1:samples) {
  sample.data[i] <- mean(rnorm(sample.size, mean=usa.mean, sd=usa.sd))
}
hist(sample.data, prob = TRUE, breaks=15, xlim=c(50,70), ylim=c(0.0,0.7),  xlab="Scores", main=paste("Sample size = ", sample.size), col="red")
mean(sample.data) 
sd(sample.data) 


# SAMPLING Methods 
frame.size <- length(UniRanking$country)
sample.size <- 200
total.freq <- table(UniRanking$country)
total.freq

# 1. Simple Random Sampling with Replacement

#All items within the frame have the same probability for selection

set.seed(153)
s <- srswr(40, nrow(UniRanking))
s[s != 0]
rows <- (1:nrow(UniRanking))[s!=0]
rows <- rep(rows, s[s != 0])
rows
sample.1 <- UniRanking[rows, ]
#Display the dataframe containing the list of all institutions, along with their corresponding frequency after sampling.  
setNames(data.frame(table(sample.1$institution)), c( "Institution", "Freq"))


# 2. Simple Random Sampling Without Replacement

set.seed(153)
s <- srswor(40, nrow(UniRanking))
sample.2 <- UniRanking[s != 0, ]
head(sample.2[c("institution","world_rank")])
setNames(data.frame(table(sample.2$institution)), c( "Institution", "Freq"))

# 3. Systematic Sampling

#Step 1 calculation of number of items in each group for frame size N and sample size n
N <- nrow(UniRanking)
n <- 40
k <- ceiling(N / n) #determining number of items in each group
k


#Step 2 : selecting an item at random from the first group of k items. n samples are then drawn from every kth item in subsequent k-item groups
r <- sample(k, 1)
r
s <- seq(r, by = k, length = n)
sample.3 <- UniRanking[s, ]
head(sample.3[c("institution","world_rank")])
setNames(data.frame(table(sample.3$institution)), c( "Institution", "Freq"))



#  For CONFIDENCE LEVELS of 80 and 90, show the confidence intervals of the mean of the numeric variable 
#  for various samples and compare against the population mean.

# 1. Drawing the sample for Confidence level = 90%

# References 1. http://homepages.math.uic.edu/~bpower6/stat101/Confidence%20Intervals.pdf
#            2. Module6_samples.R
#            3. http://www.stat.osu.edu/~calder/stat528/Lectures/lecture21_2slides.PDF



options(digits=4)

data.frame.size <- length(UniRanking$score)
sample.size <- 100
draw.samples <- 50
mean.of.50.samples <- numeric(draw.samples)
ci.upper <- numeric(draw.samples)
ci.lower <- numeric(draw.samples)
print.samples <- ""
total.mean <- mean(UniRanking$score, na.rm=TRUE) 
total.sd <- sd(UniRanking$score, na.rm=TRUE)
sample.means.sd <- total.sd / sqrt(sample.size)

#storing values for confidence level and calculating its alpha value

set.seed(150)
conf.value <- 80
alpha.value <- 1 - conf.value / 100

#calculating z score of the upper tail 

zscore <- qnorm(1- alpha.value / 2)
OUT <- 0
for (i in 1:draw.samples) {
  rows.to.sample <- srswr(sample.size, data.frame.size) 
  uni.sample.data <- UniRanking$score[rows.to.sample != 0]
  mean.of.50.samples[i] <- mean(uni.sample.data, na.rm=TRUE)
  # calcualtion of confidence intervals (ci)
  ci.lower[i] <- mean.of.50.samples[i] - zscore * sample.means.sd
  ci.upper[i] <- mean.of.50.samples[i] + zscore * sample.means.sd
  # displaying the 80% confidence level for each of the sample means
  
  print.samples <- sprintf("%2d. Sample Mean=%.2f, CI= %.2f - %.2f, %s",
                           i, mean.of.50.samples[i], ci.lower[i], ci.upper[i],
                           ifelse(total.mean >= ci.lower[i] && total.mean <= ci.upper[i], "IN", "OUT"))
  if (total.mean < ci.lower[i] || total.mean > ci.upper[i]) inc(OUT) <-  1
  cat(print.samples,"\n")
}
sprintf("Samples OUT the confidence interval = %d", OUT)

#each sample plotted against the population mean which is denoted by the vertical line

matplot(rbind(ci.lower, ci.upper),
        rbind(1:draw.samples, 1:draw.samples), type="l", lty=1,
        ylab="Samples", xlab="Sample Means", main=" 80% Confidence")
abline(v = total.mean, lty="solid")


#  2. Drawing the sample for Confidence level = 90%


set.seed(150)

   #storing values for confidence level and calculating its alpha value

conf.value <- 90
alpha.value <- 1 - conf.value / 100

   #calculating z score of the upper tail 

zscore <- qnorm(1- alpha.value / 2)

OUT <- 0
for (i in 1:draw.samples) {
  # using simple random sampling without replacement to select the rows to sample
  rows.to.sample <- srswr(sample.size, data.frame.size)  
  uni.sample.data <- UniRanking$score[rows.to.sample != 0]
  mean.of.50.samples[i] <- mean(uni.sample.data, na.rm=TRUE)
  # calcualtion of confidence intervals
  ci.lower[i] <- mean.of.50.samples[i] - zscore * sample.means.sd
  ci.upper[i] <- mean.of.50.samples[i] + zscore * sample.means.sd
  
  # displaying the 90% confidence level for each of the sample means
  print.samples <- sprintf("%2d. Sample Mean=%.2f, CI= %.2f - %.2f, %s",
                           i, mean.of.50.samples[i], ci.lower[i], ci.upper[i],
                           ifelse(total.mean >= ci.lower[i] && total.mean <= ci.upper[i], "IN", "OUT"))
  if (total.mean < ci.lower[i] || total.mean > ci.upper[i]) inc(OUT) <-  1
  cat(print.samples,"\n")
}
sprintf("Total OUT ci = %d", OUT)
#each sample plotted against the population mean which is denoted by the vertical line

matplot(rbind(ci.lower, ci.upper),
        rbind(1:draw.samples, 1:draw.samples), type="l", lty=1,
        ylab="Score Samples", xlab="Sample Mean", main="90% Confidence")
abline(v = total.mean, lty="solid")
total.mean


