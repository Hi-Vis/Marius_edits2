library(tidyverse)
library(jsonlite)

r_data = read_json("extras/coords_r.json", simplifyVector = TRUE) %>%
    as.data.frame()
a_data = read_json("extras/coords_a.json", simplifyVector = TRUE) %>%
    as.data.frame()
d_data = read_json("extras/coords_d.json", simplifyVector = TRUE) %>%
    as.data.frame()

# plot(r_data[, 1], r_data[, 2])

rad = bind_rows(
    r_data %>% mutate(letter = "r"),
    a_data %>% mutate(letter = "a"),
    d_data %>% mutate(letter = "d")
)
colnames(rad) = c("x", "y", "letter")

rad = rad %>%
    mutate(id = 1:n())

# Normalize coords and flip y
rad = rad %>%
    mutate(y = (min(y) - y),
           y = y - min(y),
           x = x - min(x))

ggplot(rad, aes(x, y)) +
    geom_point() +
    coord_equal()

library(igraph)
library(ggraph)

# Randomly delete a few rows
# n_delete = 200
# to_delete = sample(1:nrow(rad), size = n_delete)
# rad = rad %>%
#     filter(! id %in% to_delete)

edge_df = rad %>%
    group_by(letter) %>%
    mutate(to = lead(id)) %>%
    ungroup() %>%
    select(from = id, to) %>%
    drop_na(to)

n_extra = 100
extra_edges = rad %>%
    group_by(letter) %>%
    group_modify(function(df, key) {
        data_frame(
            from = sample(df$id, n_extra),
            to = sample(df$id, n_extra)
        )
    }) %>%
    ungroup() %>%
    select(-letter)

g = graph_from_data_frame(edge_df %>% bind_rows(extra_edges), vertices = rad %>% select(id, x, y, letter))

random_ids = sample(1:nrow(rad))
ggraph(g) +
    geom_edge_link(alpha = 0.4) +
    geom_node_point(aes(colour = random_ids[as.numeric(name)]),
                    size = 3) +
    scale_colour_viridis_c(guide = 'none', option = "A") +
    coord_equal() +
    theme_graph()

ggsave("Images/rad_logo.png", 
       dpi = 96, width = 600 / 96, height = 300 / 96,
       type = "cairo")

r_ids = rad %>%
    filter(letter == "r") %>%
    pull(id)
r_only = graph_from_data_frame(
    edge_df %>%
        bind_rows(extra_edges) %>%
        filter(from %in% r_ids, to %in% r_ids),
    vertices = rad %>%
        select(id, x, y, letter) %>%
        filter(id %in% r_ids)
)

random_ids = sample(1:nrow(r_only))
ggraph(r_only) +
    geom_edge_link(alpha = 0.4) +
    geom_node_point(aes(colour = random_ids[as.numeric(name)]),
                    size = 3) +
    scale_colour_viridis_c(guide = 'none', option = "A") +
    coord_equal() +
    theme_graph(plot_margin = margin(10, 10, 10, 10))

ggsave("Images/rad_logo_r.png", 
       dpi = 96, width = 200 / 96, height = 200 / 96,
       type = "cairo")