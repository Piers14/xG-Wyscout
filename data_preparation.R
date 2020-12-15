require(jsonlite)
require(tidyverse)

# Reading in event data for each country

england_data <- fromJSON("events_England.json")
england_shot_data <- england_data %>% filter(subEventName == "Shot")

spain_data <- fromJSON("events_Spain.json")
spain_shot_data <- spain_data %>% filter(subEventName == "Shot")

germany_data <- fromJSON("events_Germany.json")
germany_shot_data <- germany_data %>% filter(subEventName == "Shot")

italy_data <- fromJSON("events_Italy.json")
italy_shot_data <- italy_data %>% filter(subEventName == "Shot")

france_data <- fromJSON("events_France.json")
france_shot_data <- france_data %>% filter(subEventName == "Shot")



# Getting relevant shot info in a usable format

england_shot_info <- get_shot_info(england_shot_data)
spain_shot_info <- get_shot_info(spain_shot_data)
germany_shot_info <- get_shot_info(germany_shot_data)
italy_shot_info <- get_shot_info(italy_shot_data)
france_shot_info <- get_shot_info(france_shot_data)


# Combining all data into one dataframe



# Converting x-y coordinates to angle-disatnce
england_shot_angles <- get_angle_distance_format(england_shot_info)



