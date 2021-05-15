#install.packages('corrplot')
library(corrplot)
# Clustering
#install.packages('cluster')
#install.packages('factoextra')
library(cluster) 
library(factoextra)
#install.packages('tidyverse')
library(tidyverse)  # data manipulation
#--------------------------------------

# load the data
snf2 <- read.csv("/Users/hient/OneDrive - National University of Ireland, Galway/Documents/snf2/snf2all-mafft-needledata.csv", header = TRUE, sep = ",")
snf2_dat <- snf2[-c(1,3)]
snf2_dat[1] <- round(snf2["identity"]/snf2["count"]*100, 2)
snf2_dat[2] <- round(snf2["similarity"]/snf2["count"]*100, 2)
snf2_dat[3] <- round(snf2["gaps"]/snf2["count"]*100, 2)
rownames(snf2_dat) <- snf2[,1]

# plot the data - do you see clusters?
pairs(snf2_dat, gap = 0, pch = 19, col = adjustcolor(1, 0.4))


## K-means clustering

# Calinski-harabasz index
#```{r pressure, echo=FALSE}
#K<- 30 #set K max
#wss <- bss <- rep(NA, K) # initialize empty vector
#
#for ( k in 2:K ) {
# run kmeans for each value of k
#  fit <- kmeans(snf2_dat, centers = k, nstart = 30)
#  wss[k] <- fit$tot.withinss # store total within sum of squares
#  bss[k] <- fit$betweenss
#}
# compute calinski-harabasz index
#N <- nrow(snf2_dat)
#ch <- ( bss/(1:K - 1) ) / ( wss/(N - 1:K) )
#ch[1] <- 0
#plot(1:K, ch, type = "b", ylab = "CH index", xlab = "Number of clusters")

#```

## Elbow

# function to compute total within-cluster sum of square 
wss <- function(k) {
  kmeans(snf2_dat, k, nstart = 20)$tot.withinss
}

# Compute and plot wss for k = 1 to k = 15
k.values <- 2:30

# extract wss for 2-15 clusters
wss_values <- map_dbl(k.values, wss)

plot(k.values, wss_values,
     type="b", pch = 19, 
     xlab="Number of clusters K",
     ylab="Total within-clusters sum of squares", main="Elbow method", ylim=c(0,300000), xlim=c(0,30))
abline(v=4,lty=2, col="blue")

## Silhouette Method

# function to compute average silhouette for k clusters
avg_sil <- function(k) {
  km.res <- kmeans(snf2_dat, centers = k, nstart = 20)
  # construct a distance matrix using squared Euclidean distance
  d <- dist(snf2_dat, method = "euclidean")^2
  ss <- silhouette(km.res$cluster, d)
  mean(ss[, 3])
}

# Compute and plot wss for k = 2 to k = 30
k.values <- 2:30

# extract avg silhouette for 2-30 clusters
avg_sil_values <- map_dbl(k.values, avg_sil)

plot(k.values, avg_sil_values,
     type = "b", pch = 19,  
     xlab = "Number of clusters K",
     ylab = "Average Silhouettes", main="Silhouette-Euclidean method",
     xlim=c(0,30))


# silhouette manhattan
avg_sil <- function(k) {
  km.res <- kmeans(snf2_dat, centers = k, nstart = 20)
  # construct a distance matrix using squared Euclidean distance
  d <- dist(snf2_dat, method = "manhattan")
  ss <- silhouette(km.res$cluster, d)
  mean(ss[, 3])
}

# Compute and plot wss for k = 2 to k = 30
k.values <- 2:30

# extract avg silhouette for 2-30 clusters
avg_sil_values <- map_dbl(k.values, avg_sil)

plot(k.values, avg_sil_values,
     type = "b", pch = 19,  
     xlab = "Number of clusters K",
     ylab = "Average Silhouettes", main="Silhouette-Manhattan method",
     xlim=c(0,30))


# Silhouette
fit2 <- kmeans(snf2_dat, centers = 2, nstart = 20)
fit3 <- kmeans(snf2_dat, centers = 3, nstart = 20)
fit4 <- kmeans(snf2_dat, centers = 4, nstart = 20)
# construct a distance matrix using squared Euclidean distance
d <- dist(snf2_dat, method = "euclidean")^2

sil2 <- silhouette(fit2$cluster, d)
sil3 <- silhouette(fit3$cluster, d)
sil4 <- silhouette(fit4$cluster, d)
# produce the two silhouette plots
col <- c("darkorange2", "deepskyblue3", "magenta3")
# par( mfrow = c(1,2) )
plot(sil2, col = adjustcolor(col[1:2], 0.3),
     main = "Wine data - K = 2")
plot(sil3, col = adjustcolor(col[1:2], 0.3),
     main = "Wine data - K = 3")
plot(sil4, col = adjustcolor(col[1:2], 0.3),
     main = "Wine data - K = 4")


# K-means with k=4
fitkm <- kmeans(snf2_dat, centers = 4, nstart = 20)
column <- fitkm$cluster
column <- data.frame(fitkm$cluster)
column[2] <- rownames(column)
rownames(column) <- c()
colnames(column) <- c("new clusters", "sequences")
write.csv(column, "/Users/hient/OneDrive - National University of Ireland, Galway/Documents/snf2/new_clusters.csv")
#column <- separate(column, 2,into = c("old cluster ID", "seq"),sep = "_")
#column[2] <- as.integer((column$`old cluster ID`))
symb <- c(15, 16, 17, 18)
col <- c("black", "red", "blue","green")

# plot with symbol and color corresponding to the clusterings
pairs(snf2_dat, gap = 0, pch = symb[fit4$cluster],
      col = adjustcolor(col[fit4$cluster], 0.4), main = "Pairwise Clustering result - K = 4")
