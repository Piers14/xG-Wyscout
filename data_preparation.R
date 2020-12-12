require(jsonlite)
require(tidyverse)

england_data <- fromJSON("events_England.json")
england_shot_data <- england_data %>% filter(subEventName == "Shot")

england_shot_tags <- get_shot_tags(england_shot_data)

get_shot_tags <- function(df){
  suppressMessages(shot_tags <- tibble(shot_tags = df$tags) %>% hoist(shot_tags, tag = "id") %>%
    unnest_wider(tag, names_sep = "") %>% rename_at(vars(contains(".")), funs(gsub("...", "_no_", ., fixed = TRUE))) %>%
    select(-shot_tags))
  return(shot_tags)
}

