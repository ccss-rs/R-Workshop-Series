# Data Visualization in R
# Cornell Center for Social Sciences
# Adapted from Data Carpentry’s R for Social Scientists(https://datacarpentry.org/r-socialsci)

## Section 1: Loading Required Packages and data
## We need to first install this package. We can do so by running the install.packages() function:
# install.packages("tidyverse","plotly")

## Now that it's installed, we need to import it to our current R session:
library(plotly)
library(tidyverse)

## Load Dataset
## Thomas Mock (2022). Tidy Tuesday: A weekly data project aimed at the R ecosystem. https://github.com/rfordatascience/tidytuesday.
tweets <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-15/tweets.csv')
head(tweets)
Chocolate...maybe
## Section 2: Basic R Plotting
## We can look at a histogram of a numerical value
hist(tweets$retweet_count)
hist(tweets$retweet_count, breaks=2, xlab = "Retweets", main = "Histogram of Retweets")

boxplot(tweets$retweet_count)
boxplot(retweet_count ~ verified, data = tweets)

plot(tweets$retweet_count,tweets$like_count)
plot(tweets$retweet_count[tweets$retweet_count<100],tweets$like_count)
plot(tweets$retweet_count[tweets$retweet_count<100],tweets$like_count[tweets$retweet_count<100])
plot(tweets$datetime[tweets$retweet_count<100],tweets$like_count[tweets$retweet_count<100],
     type="l")

## Section 3: ggplot
## ggplot2 is a plotting package that makes it simple to create complex plots from data stored in a data frame. It provides a programmatic interface for specifying what variables to plot, how they are displayed, and general visual properties. Therefore, we only need minimal changes if the underlying data change or if we decide to change from a bar plot to a scatterplot. This helps in creating publication quality plots with minimal amounts of adjustments and tweaking.

## Minimal syntax for ggplot functions:
# <DATA> %>% 
#   ggplot(aes(<MAPPINGS>)) +
#   <GEOM_FUNCTION>()

## Let's load a new dataset
episodes <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/episodes.csv')

## Section 3.1: Using ggplot to create scatterplots
## We can create a scatterplot by using the Geom Function geom_point(). 
episodes %>%
  ggplot(aes(x=rating,y=uk_viewers)) + ## When adding ggplot layers, you use the + operator
  geom_point()

## We can assign plots to a variable and then use the variable as a template for different types of plots. 
episodes_plot <- episodes %>%
  ggplot(aes(x=rating,y=uk_viewers))

episodes_plot +
  geom_point()

episodes_plot +
  geom_smooth()

## Now that we have a basic plot, we can start modifying it to extract more information. For instance, the plot below appears to have fewer dots than the plot above, even though it is using the same dataset.
episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_point()

## We can tell by looking at the data that there appear to be multiple observations with the same values for rating and duration.
episodes %>%
  filter(rating==84) %>%
  arrange(rating,duration) %>%
  select(rating, duration)

## To visualize these overlaps in data, we can adjust the transparency of the dots. We can control the transparency of the points with the alpha argument to geom_point. Values of alpha range from 0 to 1, with lower values corresponding to more transparent colors (an alpha of 1 is the default value). Specifically, an alpha of 0.1, would make a point one-tenth as opaque as a normal point. 
episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_point(alpha=.5)

## Another option to dealing with overlaps in the data is to jitter the points on the plot. Jittering introduces a little bit of randomness into the position of our points. The points will move a little bit side-to-side and up-and-down, but their position from the original plot won’t dramatically change. In order to jitter our plot, we replace the geom_point() function with the geom_jitter() function.
episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_jitter()

## We can use jitter in combination with alpha to reduce the randomness allowed.
episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_jitter(alpha = 0.5,
              width = 0.2,
              height = 0.2)

## We can change the color of all the points, by using the color argument.
episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_point(alpha=.5, color="red")

episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_jitter(alpha = 0.5,
              color = "red",
              width = 0.2,
              height = 0.2)

## We can also apply a color to points based on a grouping variable in the data. However, because we are now mapping features of the data to a colour, instead of setting one colour for all points, the colour of the points now needs to be set inside a call to the aes function.
episodes %>%
  ggplot(aes(x=rating,y=duration)) +
  geom_point(aes(color=type), alpha=.5) # You can also specify mappings for a given geom independently of the mapping defined globally in the ggplot() function.

### Challenge 1: Scatterplots
### Use what you just learned to create a scatter plot of rating by season_number. Does this seem like a good way to display the relationship between these variables? What other kinds of plots might you use to show this type of data?

## Section 3.2: Using ggplot to create boxplots
## When we plot a boxplot, we will use the geom_boxplot() function.
episodes %>%
  ggplot(aes(x=type,y=rating)) +
  geom_boxplot()

## We can add points to a boxplot, by adding a geom_jitter() or geom_point() layer.
episodes %>%
  ggplot(aes(x=type,y=rating)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.5,
            color = "red",
            width = 0.2,
            height = 0.2)

## Challenge 2: Boxplots
## Create a boxplot for rating of each season_number. Hint: The season_number variable will need to be modified.

## Section 3.3: Using ggplot to create barplots
## Barplots are also useful for visualizing categorical data. By default, geom_bar accepts a variable for x, and plots the number of instances each value of x that appears in the dataset.
episodes %>%
  ggplot(aes(x=season_number)) +
  geom_bar()

## We can use the fill aesthetic for the geom_bar() geom to colour bars by a grouping variable
episodes %>%
  ggplot(aes(x=season_number)) +
  geom_bar(aes(fill=type))

## Despite fill and color both adding color to plots, they are not the same and cannnot be used interchangeably. 
episodes %>%
  ggplot(aes(x=season_number)) +
  geom_bar(aes(color=type))

## We can separate the portions of the stacked bar that correspond to each group and put them side-by-side by using the position argument for geom_bar() and setting it to “dodge”.
episodes %>%
  ggplot(aes(x=season_number)) +
  geom_bar(aes(fill=type), position = "dodge")

## We can also change the y-axis from a count to using a variable in our dataset. We need to change the format of our data, so that there is only one observation per a season_number and we will add the argument stat with a value of identity.
episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating, fill=type)) +
  geom_bar(stat = "identity", position = "dodge")

### Challenge 3: Barplots
### Create abar plot showing the rating for the first episode of each season.

## Section 3.4: Adding Labels and Titles
## By default, the axes labels on a plot are determined by the name of the variable being plotted. However, ggplot2 offers lots of customization options, like specifying the axes labels, and adding a title to the plot with relatively few lines of code.
?labs

episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating, fill=type)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       fill = "Episode Type", 
       x = "Season",
       y = "Avg Rating")

## Section 3.5: Faceting
## Faceting allows the user to split one plot into multiple plots based on a factor included in the dataset.
episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       x = "Season",
       y = "Avg Rating") +
  facet_wrap(~type)

## Section 3.6: Customization
## Section 3.6.1: Themes
## ggplot2 comes with several themes which can be useful to quickly change the look of your visualization. The complete list of themes is available at https://ggplot2.tidyverse.org/reference/ggtheme.html.
episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       x = "Season",
       y = "Avg Rating") +
  facet_wrap(~type) +
  theme_bw()

episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       x = "Season",
       y = "Avg Rating") +
  facet_wrap(~type) +
  theme_void()

## Section 3.6.1: Scales
## We can change the scale of an axis to log
episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       x = "Season",
       y = "Avg Rating") +
  facet_wrap(~type) +
  scale_y_log10() +
  theme_bw()

## We can reverse the scale of an axis
episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       x = "Season",
       y = "Avg Rating") +
  facet_wrap(~type) +
  scale_y_reverse() +
  theme_bw()

## We can flip the coordinates
episodes %>%
  ggplot(aes(x=season_number)) +
  geom_bar() +
  coord_flip()

## Section 3.7: Saving the Plots
## There are two common ways to save a plot produced from ggplot.
## 1. The Export tab in the Plot pane in RStudio will save your plots. The resolution is low, which will not be accepted by many journals and will not scale well for posters.
## 2. Instead, use the ggsave() function, which allows you to easily change the dimension and resolution of your plot by adjusting the appropriate arguments (width, height and dpi).
my_plot <- episodes %>%
  group_by(season_number, type) %>%
  summarise(avgRating = mean(rating, na.rm=T)) %>%
  ggplot(aes(x=season_number, y=avgRating)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg rating of season's episodes by episode type",
       x = "Season",
       y = "Avg Rating") +
  facet_wrap(~type) +
  scale_y_reverse() +
  theme_bw()

ggsave("testPlot.png", my_plot, width = 15, height = 10)
