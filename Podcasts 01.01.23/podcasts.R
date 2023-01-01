# Open the library
library(DBI)

# Set working directory
setwd("~/Downloads/R Projects")

# Download Dataset
#https://www.kaggle.com/datasets/thoughtvector/podcastreviews/download?datasetVersionNumber=27

# Read about how to use RSQLite at https://cran.r-project.org/web/packages/RSQLite/vignettes/RSQLite.html
podcasts <- dbConnect(RSQLite::SQLite(),"podcasts.sqlite")

# Take a look at the tables in the database
dbListTables(podcasts)

# Look at the top 5 rows in each table
dbGetQuery(podcasts, 'SELECT * FROM categories LIMIT 5')
dbGetQuery(podcasts, 'SELECT * FROM podcasts LIMIT 5')
dbGetQuery(podcasts, 'SELECT * FROM reviews LIMIT 5')
dbGetQuery(podcasts, 'SELECT * FROM runs LIMIT 5')

# Look at the items we care about
dbGetQuery(podcasts, "SELECT category,
                             rating, 
                             reviews.podcast_id
                      FROM categories
                      INNER JOIN reviews ON categories.podcast_id=reviews.podcast_id
                      LIMIT 5")

# Get the data and store it
data <- dbGetQuery(podcasts, "SELECT  category,
                                      AVG(rating) as 'Avg. Rating',
                                      COUNT(DISTINCT reviews.podcast_id) as 'No. of Podcasts',
                                      COUNT(*) as 'No. of Listeners'
                              FROM categories
                                   INNER JOIN reviews ON categories.podcast_id=reviews.podcast_id
                              GROUP BY category")

# Saturation Ratio
data$'Saturation Ratio' <- round(data$`No. of Listeners`/data$`No. of Podcasts`,0)

write.csv(data, "/home/parallels/Downloads/R Projects/podcasts.csv", row.names=FALSE)
