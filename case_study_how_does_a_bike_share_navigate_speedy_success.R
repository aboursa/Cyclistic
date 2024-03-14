# Business Task: Design marketing strategies aimed at converting casual riders into
# annual members. Team needs to better understand how annual members and casual riders differ, why casual riders 
# would buy a membership, and how digital media could affect their marketing tactics




# Install libraries needed for analysis

library(tidyverse)
library(dplyr)
library(janitor)
library(lubridate)
library(knitr)
library(ggplot2)
library(labeling)
library(magrittr)
library(readr)
library(skimr)
library(geosphere)
library(hms)
library(scales)





# Variables used/data sets of bike data for 12 months between 5/2020 - 4/2021

tripdata_202005  
tripdata_202006  
tripdata_202007  
tripdata_202008  
tripdata_202009  
tripdata_202010  
tripdata_202011  
tripdata_202012  
tripdata_202101  
tripdata_202002  
tripdata_202103  
tripdata_202104  





# Import all data sets as csvs


tripdata_202005 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202005-divvy-tripdata.csv')


tripdata_202006 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202006-divvy-tripdata.csv')


tripdata_202007 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202007-divvy-tripdata.csv')


tripdata_202008 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202008-divvy-tripdata.csv')


tripdata_202009 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202009-divvy-tripdata.csv')


tripdata_202010 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202010-divvy-tripdata.csv')


tripdata_202011 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202011-divvy-tripdata.csv')


tripdata_202012 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202012-divvy-tripdata.csv')


tripdata_202101 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202101-divvy-tripdata.csv')


tripdata_202102 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202102-divvy-tripdata.csv')


tripdata_202103 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202103-divvy-tripdata.csv')


tripdata_202104 <- read.csv('C:/Users/Adj/OneDrive/Documents/Google Data Analytics Cert - Capstone 1/Data Files/csvs/202104-divvy-tripdata.csv')





# Check to see if all data sets' are consistent (columns + data types)
str(tripdata_202005)  
str(tripdata_202006)  
str(tripdata_202007)  
str(tripdata_202008)  
str(tripdata_202009)  
str(tripdata_202010)  
str(tripdata_202011)  
str(tripdata_202012)  
str(tripdata_202101)  
str(tripdata_202102)  
str(tripdata_202103)  
str(tripdata_202104)  

# * "start_station_id" & "end_station_id columns have "chr" in some data sets and "int" in others





# Convert inconsistent data types found in "start_station_id" & "end_station_id" -> 05/2020 thru 11/2020 are "int", 12/2020 thru 04/2021 are "chr" 
# Convert data sets with "int" station_ids to "chr"

tripdata_202005$start_station_id <- as.character(tripdata_202005$start_station_id)
tripdata_202005$end_station_id <- as.character(tripdata_202005$end_station_id)


tripdata_202006$start_station_id <- as.character(tripdata_202006$start_station_id)
tripdata_202006$end_station_id <- as.character(tripdata_202006$end_station_id)
                                               
                                               
tripdata_202007$start_station_id <- as.character(tripdata_202007$start_station_id)
tripdata_202007$end_station_id <- as.character(tripdata_202007$end_station_id)                                               
                                               
                                               
tripdata_202008$start_station_id <- as.character(tripdata_202008$start_station_id)
tripdata_202008$end_station_id <- as.character(tripdata_202008$end_station_id)                                               
                                               
                                               
tripdata_202009$start_station_id <- as.character(tripdata_202009$start_station_id)
tripdata_202009$end_station_id <- as.character(tripdata_202009$end_station_id)   


tripdata_202010$start_station_id <- as.character(tripdata_202010$start_station_id)
tripdata_202010$end_station_id <- as.character(tripdata_202010$end_station_id)


tripdata_202011$start_station_id <- as.character(tripdata_202011$start_station_id)
tripdata_202011$end_station_id <- as.character(tripdata_202011$end_station_id)




                                               
# Combine all data sets into one file so we have one year's worth of data (5/2020 - 4/2021)


tripdata_combined_0520_0421 <- bind_rows(tripdata_202005, tripdata_202006, tripdata_202007, tripdata_202008, tripdata_202009, tripdata_202010, tripdata_202011, tripdata_202012, tripdata_202101, tripdata_202102, tripdata_202103, tripdata_202104)
View(tripdata_combined_0520_0421)





# Check that data set has the same number of unique Ids as there are rows in the data set

n_unique(tripdata_combined_0520_0421$ride_id)
# *** there are 3,742,202 rows in the data set but only 3,741,993 unique rider_ids




# Delete rows with duplicated ride_id

tripdata_combined_0520_0421 <- tripdata_combined_0520_0421[!duplicated(tripdata_combined_0520_0421$ride_id), ]





# Convert "started_at" and "ended_at" to Date data type

tripdata_combined_0520_0421 <- tripdata_combined_0520_0421 %>%
  mutate(started_at = ymd_hms(started_at),
         ended_at = ymd_hms(ended_at))
str(tripdata_combined_0520_0421) # check that "started_at" and "ended_at" are now date types





# Add column "ride_length" to calculate duration between "started_at" and "ended_at" for each data set

tripdata_combined_0520_0421 <- tripdata_combined_0520_0421 %>% 
  mutate(ride_length = as_hms(difftime(ended_at, started_at, units = "secs"))) # use "as_hms to convert difference in seconds to duration format





# Some rows have negative "ride_length" values - drop them from the data set

nrow(tripdata_combined_0520_0421[tripdata_combined_0520_0421$ride_length <0,]) # returns count of rows with ride_length <0

tripdata_combined_0520_0421 <- tripdata_combined_0520_0421[!tripdata_combined_0520_0421$ride_length <0,] # [! ,] creates subset for column condition (records with ride_length NOT less than 0)






# Add "day of week" column to each data set

tripdata_combined_0520_0421 <- tripdata_combined_0520_0421 %>% 
  mutate(weekday = weekdays(started_at))
tripdata_combined_0520_0421$weekday <- ordered(tripdata_combined_0520_0421$weekday, levels=c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"))




# Rename "member_casual" column name

tripdata_combined_0520_0421 <- tripdata_combined_0520_0421 %>% 
  rename(rider_type = member_casual)





# Split date and time into separate columns for "started_at"

tripdata_combined_0520_0421$date <- as.Date(tripdata_combined_0520_0421$started_at) # add new column for started date

tripdata_combined_0520_0421$month <- format(as.Date(tripdata_combined_0520_0421$date), "%b") # use new date column to extract month

tripdata_combined_0520_0421$day <- format(as.Date(tripdata_combined_0520_0421$date), "%d") # use new date column to extract date

tripdata_combined_0520_0421$year <- format(as.Date(tripdata_combined_0520_0421$date), "%Y") # use new date column to extract year

tripdata_combined_0520_0421$time <- format(as.POSIXct(tripdata_combined_0520_0421$started_at), 
                                                    format = "%H:%M:%S") # add new column for started time





# Get summary of combined data set

tripdata_combined_0520_0421 %>% 
  summary()


str(tripdata_combined_0520_0421)

# Other summary calculations
tripdata_combined_0520_0421 %>% 
  summarise(max_ride_length = as_hms(max(ride_length)),
            min_ride_length = as_hms(min(ride_length)))


most_frequent_station <- tripdata_combined_0520_0421 %>% 
  group_by(start_station_name) %>% 
  summarise(start_station_name_count = n()) %>%
  filter(start_station_name != "") %>%  # removes records with no start_station_name listed
  arrange(desc(start_station_name_count))
View(most_frequent_station) # number of starts at each station from most to least frequented


most_frequent_station_members <- tripdata_combined_0520_0421 %>%
  filter(rider_type == "member") %>%
  group_by(start_station_name) %>% 
  summarise(start_station_name_count = n()) %>% 
  filter(start_station_name != "") %>% 
  arrange(desc(start_station_name_count))
View(most_frequent_station_members) # number of starts at each station from most to least frequented by members
#*** Clark St & Elm St is the most popular start station among members


most_frequent_station_casuals <- tripdata_combined_0520_0421 %>%
  filter(rider_type == "casual") %>%
  group_by(start_station_name) %>% 
  summarise(start_station_name_count = n()) %>% 
  filter(start_station_name != "") %>% 
  arrange(desc(start_station_name_count))
View(most_frequent_station_casuals)
# *** Streeter Dr & Grand Ave is the most popular start station among casuals





# Create visual showing top 10 most frequented stations among rider types (all, members, casuals)

most_frequent_station %>% 
  top_n(10, start_station_name_count) %>% 
  ggplot() +
  geom_bar(mapping = aes(reorder(x = start_station_name, -start_station_name_count), y = start_station_name_count), stat = "identity") +
  theme(axis.text.x = element_text(angle = 90)) +
  labs(title = "Top 10 Starting Stations (All Riders)",
       x = "Station",
       y = "Ride Count") +
  facet_wrap(~ rider_type)


most_frequent_station_members %>% 
  top_n(10, start_station_name_count) %>% 
  ggplot() +
  geom_bar(mapping = aes(reorder(x = start_station_name, -start_station_name_count), y = start_station_name_count), fill = "#00bfc4", stat = "identity") +
  theme(axis.text.x = element_text(angle = 90), legend.position = "none") +
  labs(title = "Top 10 Starting Stations (Members)",
       x = "Station",
       y = "Ride Count")
ggsave(filename = file.path("Google Data Analytics Cert - Capstone 1", "most_frequent_station_members.png"), width = 7, height = 5)

most_frequent_station_casuals %>% 
  top_n(10, start_station_name_count) %>% 
  ggplot() +
  geom_bar(mapping = aes(reorder(x = start_station_name, -start_station_name_count), y = start_station_name_count, fill = "salmon"), stat = "identity") +
  theme(axis.text.x = element_text(angle = 90), legend.position = "none") +
  labs(title = "Top 10 Starting Stations (Casuals)",
       x = "Station",
       y = "Ride Count")
ggsave(filename = file.path("Google Data Analytics Cert - Capstone 1", "most_frequent_station_casuals.png"), width = 7, height = 5)




# Group casual vs. member riders and average ride length for each type of rider

tripdata_combined_0520_0421_member_type <- tripdata_combined_0520_0421 %>%
  group_by(rider_type) %>% 
  summarise(rider_type_count = n(),
            avg_ride_duration = format(strptime(as_hms(mean(ride_length)), format = "%H:%M:%S"), "%H:%M:%S"))
View(tripdata_combined_0520_0421_member_type)





# Group by day of week and rider type

tripdata_combined_0520_0421_weekday <- tripdata_combined_0520_0421 %>% 
  group_by(weekday) %>% 
  summarise(total_riders = n(),
            casual = sum(rider_type == "casual"),
            member = sum(rider_type == "member"),
            avg_ride_duration = format(strptime(as_hms(mean(ride_length)), format = "%H:%M:%S"), "%H:%M:%S"),
            avg_ride_duration_casual = format(strptime(as_hms(mean(ride_length[rider_type == "casual"])), "%H:%M:%S"), "%H:%M:%S"),
            avg_ride_duration_member = format(strptime(as_hms(mean(ride_length[rider_type == "member"])), "%H:%M:%S"), "%H:%M:%S"))





# Group by month and rider type

tripdata_combined_0520_0421_month <- tripdata_combined_0520_0421 %>% 
  group_by(month) %>% 
  summarise(total_riders = n(),
            casual = sum(rider_type == "casual"),
            member = sum(rider_type == "member"),
            avg_ride_duration = format(strptime(as_hms(mean(ride_length)), format = "%H:%M:%S"), "%H:%M:%S")) %>% 
  arrange(total_riders)
View(tripdata_combined_0520_0421_month)





# Create visuals


  # Double bar graph to differentiate "casual" and "member" ridership during the week

ggplot(data = tripdata_combined_0520_0421, aes(fill = rider_type, x = weekday)) +
  geom_bar(position = "dodge", stat = "count") +
  scale_y_continuous(labels = label_comma()) +
  labs(title = "Users per Day by Rider Type",
       x = "",
       y = "Riders",
       caption = "*daily ridership from May 2020 - April 2021")
ggsave(filename = file.path("Google Data Analytics Cert - Capstone 1", "tripdata_combined_0520_0421.png"))
# ***More members leveraged Cyclistic bikes M - F, but more casual users rode bikes on weekends


  # Double bar graph showing average trip time per day of week by rider type


ggplot(data = tripdata_combined_0520_0421, aes(x= weekday, y = ride_length)) +
  geom_bar(stat = "summary", fun.y = "mean") +
  facet_wrap(~ rider_type) +
  theme(axis.text.x = element_text(angle = 60)) +
  scale_y_continuous(labels= hms) +
  labs(title = "Average Trip Duration per day by Rider Type",
       x = "",
       y = "Average Trip Duration")
# No need to use facet wrap version of bar chart, but keep here anyway.

ggplot(data = tripdata_combined_0520_0421, aes(x= weekday, y = ride_length, fill = rider_type)) +
  geom_bar(stat = "summary", fun.y = "mean", position = "dodge") +
  theme(axis.text.x = element_text(angle = 60)) +
  scale_y_continuous(labels= hms) +
  labs(title = "Average Trip Duration per day by Rider Type",
       x = "",
       y = "Average Trip Duration")
ggsave(filename = file.path("Google Data Analytics Cert - Capstone 1", "tripdata_combined_0520_0421.png"), width = 5, height = 5)

  # Bar graph to show average trip duration per day of week

ggplot(data = tripdata_combined_0520_0421_weekday, aes(x= weekday, y = avg_ride_duration)) +
         geom_col(fill = "orange") +
# ***Riders averaged longer trips on weekends (1. Sunday, 2. Saturday)
# don't need to include this graph in markdown file since it doesn't help differentiate between member & casual usage.


  # Comparison in overall average ride duration between members and casuals

ggplot(data = tripdata_combined_0520_0421_member_type, aes(x = rider_type, y = avg_ride_duration, fill = rider_type))+
  geom_col(position = "dodge", stat = "count") +
  labs(title = "Average Trip Duration by Rider Type",
       x = "",
       y = "HH:MM:SS")
ggsave(filename = file.path("Google Data Analytics Cert - Capstone 1", "tripdata_combined_0520_0421_member_type.png"))

  # Comparison in number of members to casuals

ggplot(data = tripdata_combined_0520_0421, aes(x = rider_type, fill = rider_type)) +
  geom_bar(position = "dodge", stat = "count") +
  scale_y_continuous(labels = label_comma()) +
  labs(title = "Number of Riders by Rider Type",
       caption = "*riders between May 2020 - April 2021",
       x = "",
       y = "Riders")


  # Transform rider type count to percentage

tripdata_combined_0520_0421_member_type$rider_type_count <- as.numeric(tripdata_combined_0520_0421_member_type$rider_type_count) # convert "rider_type_count" from int to num

tripdata_combined_0520_0421_member_type_percent <- tripdata_combined_0520_0421 %>% 
  group_by(rider_type) %>% 
  summarise(total = n()) %>% 
  mutate(total_riders = sum(total)) %>% 
  group_by(rider_type) %>% 
  summarise(total_percent = total/total_riders) %>% 
  mutate(labels = scales::percent(total_percent))
View(tripdata_combined_0520_0421_member_type_percent)





  # Pie chart to compare % of members to casuals

ggplot(data = tripdata_combined_0520_0421_member_type_percent, aes(x = "", y = total_percent, fill = rider_type)) +
  geom_bar(stat = "identity", width = 1) +
  coord_polar("y", start = 0) +
  labs(title = "Usage by Rider Type",
       caption = "*ridership by rider type between May 2020 - April 2021") +
  theme_minimal() +
  theme(axis.title.x = element_blank(),
        axis.text.x = element_blank(),
        axis.title.y = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank()) +
  geom_text(aes(label = labels), position = position_stack(vjust = 0.5))
ggsave(filename = file.path("Google Data Analytics Cert - Capstone 1", "tripdata_combined_0520_0421_member_type_percent.png"))
  




    # Bar graph showing total number of riders per month

ggplot(data = tripdata_combined_0520_0421_month, aes(x = month, y = total_riders)) +
  geom_col(fill = "yellow") +
  scale_y_continuous(labels = label_comma())+
  scale_x_discrete(limits = month.abb) +
  labs(title = "All Riders by Month",
       x = "",
       y = "Number of Riders",
       caption= "*Historical data from May 2020 - April 2021. Chart is ordered by calendar year.")

ggplot(data = tripdata_combined_0520_0421, aes(x = month, fill = rider_type)) +
  geom_bar(position = "stack", stat = "count") +
  scale_y_continuous(labels = label_comma()) +
  scale_x_discrete(limits = month.abb) +
  labs(title = "Total Rides per Month by Rider Type",
       x = "",
       y = "Riders",
       caption = "*monthly ridership from May 2020 - April 2021")
# ***Summer months experienced higher ridership for both member and casual riders and gradually decreases in the fall and winter months, likely due to outside weather conditions, where people tend to ride bikes, especially for leisure, during the warmer seasons.


