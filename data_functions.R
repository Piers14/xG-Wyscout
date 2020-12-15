# Extracts the tags associated to each shot from a dataframe of shot events
get_shot_tags <- function(df){
  suppressMessages(shot_tags <- tibble(shot_tags = df$tags) %>% hoist(shot_tags, tag = "id") %>%
                     unnest_wider(tag, names_sep = "") %>% rename_at(vars(contains("...")), funs(gsub("...", "_no_", ., fixed = TRUE))) %>%
                     select(-shot_tags))
  return(shot_tags)
}

# Returns a dataframe with relevent info about each shot in a nice format
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

# Returns the distance between shot location to the centre of the goal
get_shot_distance <- function(x, y){
  shot_dis <- sqrt((50 - y)^2 + (100 - x)^2)
  return(shot_dis)
}
get_shot_distance_v <- Vectorize(get_shot_distance)

# Returns the angle between shot location and two goal posts
get_shot_angle <- function(x, y){
  if(x == 100){
    if(y < 53.66 & y > 46.34){
      return(pi)
    }
    return(0)
  }
  right_dis <- sqrt((53.66 - y)^2 + (100 - x)^2)
  left_dis <- sqrt((46.34 - y)^2 + (100 - x)^2)
  goal_line <- 7.32
  theta = acos((right_dis^2 + left_dis^2 - goal_line^2) / (2 * right_dis * left_dis))
  return(theta)
}
get_shot_angle_v <- Vectorize(get_shot_angle)

# Returns the dataframe in angle/distance format from x/y format
get_angle_distance_format <- function(df){
  new_df <- df %>% mutate(angle = get_shot_angle_v(pos_x, pos_y), 
                          distance = get_shot_distance_v(pos_x, pos_y)) %>%
    select(distance, angle, shot_type, is_counter, is_scored)
}

# Plots the location of a particular shot from the all_shots dataset
plot_shot <- function(indx, probs = 0){
  new_df <- all_shot_info[indx, ] %>% mutate(probs = probs*4)
  ggplot(data = all_shot_info[indx, ], aes(y = pos_y, x = pos_x)) +
    annotate_pitch(colour = "white", fill = "green", limits = FALSE, dimensions = pitch_wyscout) +
    theme_pitch() +
    #coord_fixed(xlim = c(40, 101), ylim = c(-1, 101), ratio = 0.5) +
    geom_point(aes(fill = factor(is_scored, levels = c(1, 0)), size = probs, color = shot_type), shape = 21,
                show.legend = FALSE) + 
    scale_colour_manual(values = c("Head" = "black", "Foot" = "white"))
}













