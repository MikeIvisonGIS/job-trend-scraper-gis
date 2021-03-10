# Install and load packages ############
if (!require("pacman")) install.packages("pacman")
# pacman must already be installed; then load contributed
# packages (including pacman) with pacman
pacman::p_load(pacman, tidyverse, RColorBrewer, vcd)
# pacman: for loading/unloading packages
# tidyverse: for so many reasons
# vcd: for categorical data and sample dataset

#Load and prepare data ###########
#Hard-coded option - read file
my_data <- read.delim("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/keyword_counts.txt", sep = "|", header = TRUE)

df <- my_data %>%
  as_tibble() %>%
  print()

#Soft-coded option - Read file and allow user to choose file location
# my_data_choose <- read.delim(file.choose(), sep = "|", header = TRUE) 
# 
# df <- my_data_choose %>%
#   as_tibble()
#   print()

# mutate search_term to factor, then change the order of the factors to list in order of "increasing" job responsibility
df <- df %>%
  mutate(
    search_term = factor(
      search_term, 
      levels = c("       technician      ", "       specialist      ", "        analyst        ", "       developer       ")
    )
  )

# Factor frequencies, in needed
# df %>% 
#   group_by(search_term) %>%       # Select variable
#   summarize(Count = n())  # Count rows

# TO-DO: Create a function instead of repeating code 4x.
mean_py <- df %>% group_by(search_term, python)
mean_py <-  aggregate(python ~ search_term, mean_py, mean) %>%
  print()
# mean_py %>%
#   summarize(Count = n())

mean_sql <- df %>% group_by(search_term, sql)
mean_sql <- aggregate(sql ~ search_term, mean_sql, mean) %>%
  print()
# mean_sql %>%
#   summarize(Count = n())

mean_java <- df %>% group_by(search_term, javascript_api)
mean_java <- aggregate(javascript_api ~ search_term, mean_java, mean) %>%
  print()
# mean_java %>%
#   summarize(Count = n())

mean_html <- df %>% group_by(search_term, html)
mean_html <- aggregate(html ~ search_term, mean_html, mean) %>%
  print()
# mean_html %>%
#   summarize(Count = n())

new_data <- cbind(mean_py, mean_sql[2], mean_java[2], mean_html[2])
#print(new_data)

#Plot data with barplot #####

colors = c("green", "orange", "blue", "red")
search_term = c("Technician", "Specialist", "Analyst", "Developer")
skill_term = c("Python", "SQL", "Javascript API", "HTML")

barplot_data <- matrix(c(new_data$python[1], new_data$sql[1], new_data$javascript_api[1], new_data$html[1],
                         new_data$python[2], new_data$sql[2], new_data$javascript_api[2], new_data$html[2],
                         new_data$python[3], new_data$sql[3], new_data$javascript_api[3], new_data$html[3],
                         new_data$python[4], new_data$sql[4], new_data$javascript_api[4], new_data$html[4]
                         ),
                       nrow = 4, ncol = 4, byrow = FALSE)
barplot(barplot_data, main = "Programming Job Trends for GIS via LinkedIn", names.arg = search_term, xlab = "Job Title", ylab = "Average Number of Keyword Appearances", col = colors, beside = TRUE)
legend("topleft", skill_term, cex = 0.7, fill = colors)   

#Options to save as png or pdf. Still not working. Used Export in plots window instead.
# png(file="C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/KeywordBarChart.png",
#            width = 600, height = 350)
# 
# pdf(file="C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/KeywordBarChart.pdf")

# Clean data, packages, plots, and console #######

# Clear data
rm(list = ls())  # Removes all objects from environment
# Clear packages
detach("package:datasets", unload = T)  # For base packages
p_unload(all)  # Remove all contributed packages
# Clear plots
graphics.off()  # Clears plots, closes all graphics devices
# Clear console
cat("\014")  # Mimics ctrl+L

# Learning Goals - Different ways to do the same thing #######

## Organize data in mean_prog and plot from there rather than 4 different data frames #####
# Create df and group by search_term for python, SQL, html, and  javascript API 
# mean_prog <- df %>% group_by(search_term, python, sql, javascript_api, html)
# mean_prog %>%
#   summarize(Count = n())
#   
# summary(mean_prog)
# 
# mean_prog <- aggregate(python ~ search_term, mean_prog, mean)
# mean_prog %>%
#   print()
# 
# mean_prog %>%
#   head()
# 
# agg = aggregate(mean_prog,
#                 by = search_term,
#                 FUN = mean)


## gg plot option ########

# mean_py %>%
#   ggplot(aes(search_term)) +
#   geom_bar(aes(weight = python, fill=search_term)) +
#   labs(                                       #add labels
#     title = 'Average Python Total per Job Search',      #title label
#     x = 'Search Term',                            #x-axis label
#     y = 'Average Python Total'                                 #y-axis label
#   ) +
#   theme(legend.position="none") +
#   scale_y_continuous(breaks=seq(0, 50, 5))
# 
# # Save as PNG
# ggsave("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/PythonKeywordBarChart.png",
#        width = 12, height = 6, dpi = 300)
# 
# mean_sql %>%
#   ggplot(aes(search_term)) +
#   geom_bar(aes(weight = sql, fill=search_term)) +
#   labs(                                       #add labels
#     title = 'Average SQL Total per Job Search',      #title label
#     x = 'Search Term',                            #x-axis label
#     y = 'Average SQL Total'                                 #y-axis label
#   ) +
#   theme(legend.position="none") +
#   scale_y_continuous(breaks=seq(0, 50, 5))
# 
# # Save as PNG
# ggsave("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/SqlKeywordBarChart.png",
#        width = 12, height = 6, dpi = 300)
# 
# mean_java %>%
#   ggplot(aes(search_term)) +
#   geom_bar(aes(weight = javascript_api, fill=search_term)) +
#   labs(                                       #add labels
#     title = 'Average Javascript API Total per Job Search',      #title label
#     x = 'Search Term',                            #x-axis label
#     y = 'Average Javascript API Total'                                 #y-axis label
#   ) +
#   theme(legend.position="none") +
#   scale_y_continuous(breaks=seq(0, 50, 5))
# 
# # Save as PNG
# ggsave("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/JavaKeywordBarChart.png",
#        width = 12, height = 6, dpi = 300)
# 
# mean_html %>%
#   ggplot(aes(search_term)) +
#   geom_bar(aes(weight = html, fill=search_term)) +
#   labs(                                       #add labels
#     title = 'Average HTML Total per Job Search',      #title label
#     x = 'Search Term',                            #x-axis label
#     y = 'Average HTML Total'                                 #y-axis label
#   ) +
#   theme(legend.position="none") +
#   scale_y_continuous(breaks=seq(0, 50, 5))
# 
# # Save as PNG
# ggsave("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/HtmlKeywordBarChart.png",
#        width = 12, height = 6, dpi = 300)
#ggsave("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/KeywordBarChart.png",
#       width = 12, height = 6, dpi = 300)

#ggsave("C:/Python_Stuff/jobTrendScraperGIS/job-trend-scraper-gis/KeywordBarChart.pdf",
#       width = 12, height = 6, dpi = 300)
