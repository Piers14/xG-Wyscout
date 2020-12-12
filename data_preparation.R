require(jsonlite)
require(tidyverse)

england_data <- fromJSON("events_England.json")
england_shot_data <- england_data %>% filter(subEventName == "Shot")

england_shot_tags <- get_shot_tags(england_shot_data)

get_shot_tags <- function(df){
  suppressMessages(shot_tags <- tibble(shot_tags = df$tags) %>% hoist(shot_tags, tag = "id") %>%
    unnest_wider(tag, names_sep = "") %>% rename_at(vars(contains("...")), funs(gsub("...", "_no_", ., fixed = TRUE))) %>%
    select(-shot_tags))
  return(shot_tags)
}

new_tags <- england_shot_tags %>% 
  mutate(is_scored = ifelse(apply(., 1, function(x) any(x == 101, na.rm = TRUE)), 1, 0), 
         is_blocked = ifelse(apply(., 1, function(x) any(x == 2101, na.rm = TRUE)), 1, 0), 
         shot_type = ifelse(apply(., 1, function(x) any((x == 401 | x == 402), na.rm = TRUE)), "Foot", 
                            ifelse(apply(., 1, function(x) any(x == 403, na.rm = TRUE)), "Head", NA)), 
         is_counter  = ifelse(apply(., 1, function(x) any(x == 1901, na.rm = TRUE)), 1, 0))

england_shot_pos <- tibble(shot_pos = england_shot_data$positions) %>%
  hoist(shot_pos, y = "y", x = "x") %>%
  unnest_wider(y, names_sep = "") %>%
  unnest_wider(x, names_sep = "") %>%
  dplyr::select(-positions)