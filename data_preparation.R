require(jsonlite)
require(tidyverse)

# Reading in england data
england_data <- fromJSON("events_England.json")
england_shot_data <- england_data %>% filter(subEventName == "Shot")

# Getting relevant shot info
england_shot_info <- get_shot_info(england_shot_data)

# Converting x-y coordinates to angle-disatnce




