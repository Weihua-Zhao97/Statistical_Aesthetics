install.packages("ggridges")
install.packages("polyclip")
install.packages("cowplot")

library(gtable)
library(scales)
library(dplyr)
library(forcats)
library(data.table)
library(ggplot2)
library(ggridges)
library(polyclip)

#==============================================================================#
# Method 1: ridgeline plot with gradient fill colors depending on the X-axis
#==============================================================================#
# Data Preparation
data <- read.csv("data.csv")

# Add a chronological index for each dynasty
data_with_id <- data %>% 
  mutate(group_no = as.integer(factor(Dynasty, levels = unique(data$Dynasty))))

# Plot
ggplot(data_with_id, aes(x = Length, y = fct_reorder(Dynasty, -group_no),
                            fill = stat(x))) +
  geom_density_ridges_gradient(scale = 8, colour="#A18A3C",alpha=0.3)+
  theme_classic() +
  scale_fill_gradient2(low="#A18A3C", mid="#99D1A4", high="#2D93C2",
                      midpoint = 35) + 
   
  theme(panel.background = element_rect(fill = alpha("#A18A3C",0.7)),
        plot.background=element_rect(fill="#A18A3C")) +
  theme(legend.background = element_rect(fill = "#A18A3C")) +
  labs(y = "", x = "") + 
  ggtitle("The Mandate of Time: Reign Lengths of Chinese Emperors",
          subtitle = "     ") +
  theme(legend.position = c(1, 0.1)) +
  theme(plot.title = element_text(hjust = 0.5, face="bold", size=20)) +
  theme(plot.margin = unit(c(1, 1, 0.1, 0.1), "cm")) +
  theme(legend.title = element_blank()) +
  theme(axis.line.x = element_blank()) +
  theme(axis.text.y = element_text(size = 11))

ggsave("test.jpeg", units="in", width=12, height=14, dpi=500)


#==============================================================================#
# Method 2: ridgeline plot with gradient fill colors depending on the density
#==============================================================================#
# Define helper function
fade_polygon <- function(x, y, yseq = seq(min(y), max(y), length.out = 100)) {
  poly <- data.frame(x = x, y = y)
  
  # Create bounding-box edges
  xlim <- range(poly$x) + c(-1, 1)
  
  # Pair y-edges
  grad <- cbind(head(yseq, -1), tail(yseq, -1))
  # Add vertical ID
  grad <- cbind(grad, seq_len(nrow(grad)))
  
  # Slice up the polygon
  grad <- apply(grad, 1, function(range) {
    # Create bounding box
    bbox <- data.frame(x = c(xlim, rev(xlim)),
                       y = c(range[1], range[1:2], range[2]))
    
    # Do actual slicing
    slice <- polyclip::polyclip(poly, bbox)
    
    # Format as data.frame
    for (i in seq_along(slice)) {
      slice[[i]] <- data.frame(
        x = slice[[i]]$x,
        y = slice[[i]]$y,
        value = range[3],
        id = c(1, rep(0, length(slice[[i]]$x) - 1))
      )
    }
    slice <- do.call(rbind, slice)
  })
  # Combine slices
  grad <- do.call(rbind, grad)
  # Create IDs
  grad$id <- cumsum(grad$id)
  return(grad)
}

# Split by time and calculate densities
densities <- split(data_with_id, data_with_id$Dynasty)
densities <- lapply(densities, function(df) {
  dens <- density(df$`Length`)
  data.frame(x = dens$x, y = dens$y)
})

# Arrange the density list into chronological order:
densities <- densities[match(unique(data_with_id$Dynasty), names(densities))]

# Extract x/y positions
x <- lapply(densities, `[[`, "x")
y <- lapply(densities, `[[`, "y")

# Make sequence to max density
ymax <- max(unlist(y))
yseq <- seq(0, ymax, length.out = 100) # 100 can be any large enough number

# Apply function to all densities
polygons <- mapply(fade_polygon, x = x, y = y, yseq = list(yseq), SIMPLIFY = FALSE)

# Count number of observations in each of the polygons
rows <- vapply(polygons, nrow, integer(1))

# Combine all of the polygons
polygons <- do.call(rbind, polygons)

# Assign month information
polygons$month_id  <- rep(seq_along(rows), rows)

# Plot
ggplot(polygons, aes(x, (y / ymax) * 1 + month_id, 
                     fill = value, group = interaction(month_id, id))) +
  geom_polygon(aes(colour = after_scale(fill)), size = 0.7) +
  scale_y_continuous(
    name = "",
    breaks = seq_along(rows),
    labels = names(rows)
  ) +
  scale_fill_gradient2(low="#a3801e", mid="#99D1A4", high="#2D93C2",
                       midpoint = 35) + 
  theme(panel.background = element_rect(fill = alpha("#a3801e",0))) +
  theme(panel.background = element_rect(fill = alpha("#A18A3C",0.7)),
        plot.background=element_rect(fill="#A18A3C")) +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.border = element_blank())
