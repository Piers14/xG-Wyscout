require(ggsoccer)

# All england shots
ggplot(data = england_shot_info, aes(y = pos_y, x = pos_x)) +
  annotate_pitch(colour = "white", fill = "green", limits = FALSE, dimensions = pitch_wyscout) +
  theme_pitch() +
  #coord_fixed(xlim = c(40, 101), ylim = c(-1, 101), ratio = 0.5) +
  geom_jitter(aes(fill = factor(is_scored, levels = c(1, 0))), alpha = 1, shape = 21, 
              show.legend = FALSE)

# Sample shots with predicted probabilities
plot_shot(head(strtoi(names(val_preds)), 22), head(val_preds, 22))