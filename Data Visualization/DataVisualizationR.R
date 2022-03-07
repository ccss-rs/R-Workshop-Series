# Data Visualization in R
# Cornell Center for Social Sciences
# Adapted from Data Carpentry’s R for Social Scientists(https://datacarpentry.org/r-socialsci)
# Datasets from Thomas Mock (2022). Tidy Tuesday: A weekly data project aimed at the R ecosystem. https://github.com/rfordatascience/tidytuesday.

## Section 1: Loading Required Packages and data
## We need to first install this package. We can do so by running the install.packages() function:
# install.packages("tidyverse","plotly")

## Now that it's installed, we need to import it to our current R session:
library(plotly)
library(tidyverse)

## Load Dataset
episodes <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-11-23/episodes.csv')
head(episodes)

## Section 2: Basic R Plotting
## We can look at a distribution of a numerical variable
hist(episodes$uk_viewers)

## We can customize the plot with a label for the x-axis, title of the plot, and a different bin size.
hist(episodes$uk_viewers, breaks=5, xlab = "UK Viewership", main = "UK Viewership of Dr. Who")

## We can make boxplots to show the distribution of a numerical variable
boxplot(episodes$uk_viewers)

## We can compare the distribution of a variable grouped by another variable. To do this we will use the formula syntax (y~x)
boxplot(uk_viewers ~ type, data = episodes)

## We can make basic scatterplots
plot(episodes$uk_viewers, episodes$rating)

## We have to make sure that the x and y vectors are the same size.
plot(episodes$uk_viewers[episodes$duration<60], episodes$rating)
plot(episodes$uk_viewers[episodes$duration<60], episodes$rating[episodes$duration<60])

## We can change a scatterplot to a line plot by changing the type.
plot(episodes$first_aired,episodes$uk_viewers, type="l")

## Section 3: ggplot
## ggplot2 is a plotting package that makes it simple to create complex plots from data stored in a data frame. It provides a programmatic interface for specifying what variables to plot, how they are displayed, and general visual properties. Therefore, we only need minimal changes if the underlying data change or if we decide to change from a bar plot to a scatterplot. This helps in creating publication quality plots with minimal amounts of adjustments and tweaking.

## Minimal syntax for ggplot functions:
# <DATA> %>% 
#   ggplot(aes(<MAPPINGS>)) +
#   <GEOM_FUNCTION>()

## Let's load a new dataset
movies <- movies <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-03-09/movies.csv')
head(movies)


## Section 3.1: Using ggplot to create scatterplots
## We can create a scatterplot by using the Geom Function geom_point(). 
movies %>%
  ggplot(aes(x=metascore,y=imdb_rating)) + ## When adding ggplot layers, you use the + operator
  geom_point()

## We can assign plots to a variable and then use the variable as a template for different types of plots. 
episodes_plot <- movies %>%
  ggplot(aes(x=metascore,y=imdb_rating))

episodes_plot +
  geom_point()

episodes_plot +
  geom_point() +
  geom_smooth(method=lm)

## Now that we have a basic plot, we can start modifying it to extract more information. For instance, the plot below appears to have fewer dots than the plot above, even though it is using the same dataset.
movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_point()

## We can tell by looking at the data that there appear to be multiple observations with the same values for year and metascore
movies %>%
  filter(year==2000) %>%
  arrange(year,metascore) %>%
  select(year,metascore)

## To visualize these overlaps in data, we can adjust the transparency of the dots. We can control the transparency of the points with the alpha argument to geom_point. Values of alpha range from 0 to 1, with lower values corresponding to more transparent colors (an alpha of 1 is the default value). Specifically, an alpha of 0.1, would make a point one-tenth as opaque as a normal point. 
movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_point(alpha=.5)

## Another option to dealing with overlaps in the data is to jitter the points on the plot. Jittering introduces a little bit of randomness into the position of our points. The points will move a little bit side-to-side and up-and-down, but their position from the original plot won’t dramatically change. In order to jitter our plot, we replace the geom_point() function with the geom_jitter() function.
movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_jitter()

## We can use jitter in combination with alpha to reduce the randomness allowed.
movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_jitter(alpha = 0.5,
              width = 0.2,
              height = 0.2)

## We can change the color of all the points, by using the color argument.
movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_point(alpha=.5, color="red")

movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_jitter(alpha = 0.5,
              color = "red",
              width = 0.2,
              height = 0.2)

## We can also apply a color to points based on a grouping variable in the data. However, because we are now mapping features of the data to a colour, instead of setting one colour for all points, the colour of the points now needs to be set inside a call to the aes function.
movies %>%
  ggplot(aes(x=year,y=metascore)) +
  geom_point(aes(color=binary), alpha=.5) # You can also specify mappings for a given geom independently of the mapping defined globally in the ggplot() function.

### Challenge 1: Scatterplots
### Using the episodes dataset create a scatter plot of rating by season_number. Does this seem like a good way to display the relationship between these variables? What other kinds of plots might you use to show this type of data?

## Section 3.2: Using ggplot to create boxplots
## When we plot a boxplot, we will use the geom_boxplot() function.
movies %>%
  ggplot(aes(x=binary,y=metascore)) +
  geom_boxplot()

## We can add points to a boxplot, by adding a geom_jitter() or geom_point() layer.
movies %>%
  ggplot(aes(x=binary,y=metascore)) +
  geom_boxplot() +
  geom_jitter(alpha = 0.5,
            color = "red",
            width = 0.2,
            height = 0.2)

## Challenge 2: Boxplots
## Using the episodes dataset, create a boxplot for rating of each season_number. Hint: The season_number variable will need to be modified.

## Section 3.3: Using ggplot to create barplots
## Barplots are also useful for visualizing categorical data. By default, geom_bar accepts a variable for x, and plots the number of instances each value of x that appears in the dataset.
movies %>%
  ggplot(aes(x=clean_test)) +
  geom_bar()

## We can use the fill aesthetic for the geom_bar() geom to color bars by a grouping variable
movies %>%
  mutate(decade_code = as.character(decade_code)) %>% # If the grouping variable is numeric, will need to be converted to a character or factor.
  ggplot(aes(x=clean_test)) +
  geom_bar(aes(fill=decade_code))

## Despite fill and color both adding color to plots, they are not the same and cannot be used interchangeably. 
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  ggplot(aes(x=clean_test)) +
  geom_bar(aes(color=decade_code))

## We can separate the portions of the stacked bar that correspond to each group and put them side-by-side by using the position argument for geom_bar() and setting it to “dodge”.
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  ggplot(aes(x=clean_test)) +
  geom_bar(aes(fill=decade_code), position = "dodge")

## We can also change the y-axis from a count to using a variable in our dataset. We need to change the format of our data, so that there is only one observation per a clean_test and we will add the argument stat with a value of identity.
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  group_by(clean_test, decade_code) %>%
  summarise(avgBudget = mean(budget_2013, na.rm=T)) %>%
  ggplot(aes(x=clean_test, y=avgBudget, fill=decade_code)) +
  geom_bar(stat = "identity", position = "dodge")

### Challenge 3: Barplots
### Using the episodes dataset, create a bar plot showing the rating for the first episode of each season.

## Section 3.4: Adding Labels and Titles
## By default, the axes labels on a plot are determined by the name of the variable being plotted. However, ggplot2 offers lots of customization options, like specifying the axes labels, and adding a title to the plot with relatively few lines of code.
?labs

movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  group_by(clean_test, decade_code) %>%
  summarise(avgBudget = mean(budget_2013, na.rm=T)) %>%
  ggplot(aes(x=clean_test, y=avgBudget, fill=decade_code)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Budget of Bechdel Test Outcome by Decade Code",
       fill = "Decade Code", 
       x = "Bechdel Test Outcome",
       y = "Avg Budget Normalized to 2013")

## Section 3.5: Faceting
## Faceting allows the user to split one plot into multiple plots based on a factor included in the dataset.
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  group_by(clean_test, decade_code) %>%
  summarise(avgBudget = mean(budget_2013, na.rm=T)) %>%
  ggplot(aes(x=clean_test, y=avgBudget)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Budget of Bechdel Test Outcome by Decade Code",
       fill = "Decade Code", 
       x = "Bechdel Test Outcome",
       y = "Avg Budget Normalized to 2013") +
  facet_wrap(~decade_code)

## Section 3.6: Customization
## Section 3.6.1: Themes
## ggplot2 comes with several themes which can be useful to quickly change the look of your visualization. The complete list of themes is available at https://ggplot2.tidyverse.org/reference/ggtheme.html.
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  group_by(clean_test, decade_code) %>%
  summarise(avgBudget = mean(budget_2013, na.rm=T)) %>%
  ggplot(aes(x=clean_test, y=avgBudget)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Budget of Bechdel Test Outcome by Decade Code",
       fill = "Decade Code", 
       x = "Bechdel Test Outcome",
       y = "Avg Budget Normalized to 2013") +
  facet_wrap(~decade_code) +
  theme_bw()

movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  group_by(clean_test, decade_code) %>%
  summarise(avgBudget = mean(budget_2013, na.rm=T)) %>%
  ggplot(aes(x=clean_test, y=avgBudget)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Budget of Bechdel Test Outcome by Decade Code",
       fill = "Decade Code", 
       x = "Bechdel Test Outcome",
       y = "Avg Budget Normalized to 2013") +
  facet_wrap(~decade_code) +
  theme_void()

## Section 3.6.1: Scales
## We can change the scale of an axis to log
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  ggplot(aes(x=clean_test)) +
  geom_bar(aes(fill=decade_code), position = "dodge") +
  scale_y_log10() +
  theme_bw()

## We can reverse the scale of an axis
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  ggplot(aes(x=clean_test)) +
  geom_bar(aes(fill=decade_code), position = "dodge") +
  scale_y_reverse() +
  theme_bw()

## We can flip the coordinates
movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  ggplot(aes(x=clean_test)) +
  geom_bar(aes(fill=decade_code), position = "dodge") +
  coord_flip()

## Section 3.7: Saving the Plots
## There are two common ways to save a plot produced from ggplot.
## 1. The Export tab in the Plot pane in RStudio will save your plots. The resolution is low, which will not be accepted by many journals and will not scale well for posters.
## 2. Instead, use the ggsave() function, which allows you to easily change the dimension and resolution of your plot by adjusting the appropriate arguments (width, height and dpi).
my_plot <- movies %>%
  mutate(decade_code = as.character(decade_code)) %>%
  group_by(clean_test, decade_code) %>%
  summarise(avgBudget = mean(budget_2013, na.rm=T)) %>%
  ggplot(aes(x=clean_test, y=avgBudget)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Avg Budget of Bechdel Test Outcome by Decade Code",
       fill = "Decade Code", 
       x = "Bechdel Test Outcome",
       y = "Avg Budget Normalized to 2013") +
  facet_wrap(~decade_code) +
  theme_bw()

ggsave("testPlot.png", my_plot, width = 15, height = 10)

## Section 4: Plotly
## Plotly is a plotting package that makes interactive visualizations. Like ggplot, it uses a layering API that allows you customize your plots.
tweets <- read_csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2021/2021-06-15/tweets.csv')

head(tweets)

## Minimal syntax for ggplot functions:
# <DATA> %>% 
#   plot_ly(MAPPING,type=TYPEOFPLOT)

## A minimal scatter plot can be created with the following syntax.
tweets %>%
  plot_ly(x=~retweet_count, y=~like_count, size =~followers, 
          text=~paste0("Username: ",username, "<br>Content:",content), 
          hoverinfo = 'text',
          type='scatter')

## Plotly has a more extensive visualization library than ggplot, and we will walk through one type of visualization that is not included in basic ggplot.

## Section 4.1 Maps
## There are several map visualizations available in Plotly. The most popular visualizations are choropleth maps, where geographic regions are shaded by value, and scatter plots maps, where points are mapped to latitude and longitude values.
tweets %>%
   plot_ly(lat = ~lat, lon = ~long, type='scattergeo')

## Customization to maps can be provided with a list of options in the format of list(parameter=value)
g <- list(
  scope = 'north america',
  showland = TRUE,
  landcolor = toRGB("gray95"),
  subunitcolor = toRGB("gray85"),
  countrycolor = toRGB("gray85"),
  countrywidth = 0.5,
  subunitwidth = 0.5
)

## The customization is applied by applying the value of the list to the geo parameter in the layout layer.
tweets %>%
   plot_ly(lat = ~lat, lon = ~long, type='scattergeo') %>% ## Note: The %>% operator is used to add additional layers.
  layout(geo=g)

