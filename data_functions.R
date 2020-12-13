get_shot_tags <- function(df){
  suppressMessages(shot_tags <- tibble(shot_tags = df$tags) %>% hoist(shot_tags, tag = "id") %>%
                     unnest_wider(tag, names_sep = "") %>% rename_at(vars(contains("...")), funs(gsub("...", "_no_", ., fixed = TRUE))) %>%
                     select(-shot_tags))
  return(shot_tags)
}

get_shot_info <- function(df){
  shot_tags <- get_shot_tags(df)
  
  new_tags <- shot_tags %>% 
    mutate(is_scored = ifelse(apply(., 1, function(x) any(x == 101, na.rm = TRUE)), 1, 0), 
           is_blocked = ifelse(apply(., 1, function(x) any(x == 2101, na.rm = TRUE)), 1, 0), 
           shot_type = ifelse(apply(., 1, function(x) any((x == 401 | x == 402), na.rm = TRUE)), "Foot", 
                              ifelse(apply(., 1, function(x) any(x == 403, na.rm = TRUE)), "Head", NA)), 
           is_counter  = ifelse(apply(., 1, function(x) any(x == 1901, na.rm = TRUE)), 1, 0))
  
  suppressMessages(shot_pos_df <- tibble(shot_pos = df$positions) %>%
                     hoist(shot_pos, pos_y = "y", pos_x = "x") %>%
                     unnest_wider(pos_y, names_sep = "_") %>%
                     unnest_wider(pos_x, names_sep = "_") %>%
                     rename_at(vars(contains("...")), funs(gsub("...", "", ., fixed = TRUE))) %>%
                     select(-c(shot_pos, pos_x_2, pos_y_2)))
  
  shot_info <- cbind(new_tags, shot_pos_df) %>%
    select(-c(1:6)) %>%
    filter(is_blocked == 0) %>%
    select(c(pos_x_1, pos_y_1, shot_type, is_counter, is_scored)) %>%
    rename(pos_x = pos_x_1, pos_y = pos_y_1)
  
  return(shot_info)
}