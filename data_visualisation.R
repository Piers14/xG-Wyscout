require(ggsoccer)

ggplot(data = england_shot_info, aes(y = pos_y, x = pos_x)) +
  annotate_pitch(colour = "white", fill   = "green", limits = FALSE, dimensions = pitch_wyscout) +
  theme_pitch() +
  coord_flip(xlim = c(41, 101), ylim = c(-1, 101)) +
  geom_jitter(aes(fill = factor(is_scored, levels = c(1, 0))), alpha = 1, shape = 21, 
              show.legend = FALSE)