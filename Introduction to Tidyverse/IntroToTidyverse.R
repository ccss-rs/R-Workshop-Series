# Introduction Tidyverse

## Section 1: Loading Tidyverse
## We need to first install this package. We can do so by running the install.packages() function:
# install.packages("tidyverse")

## Now that it's installed, we need to import it to our current R session:
library("tidyverse")

## Section 2: Loading the Dataset
# install.packages("gapminder")
library("gapminder")

## The gapminder dataset is accessed by using the gapminder function. We can view the details of the gapminder dataset by looking at the help for the gapminder function.
gapminder <- gapminder 

## We can preview a dataframe with the head() function.
head(gapminder)

## Or we can view the dataset in a separate tab as well:
view(gapminder)

## Or we can view summary statistics of the dataset:
summary(gapminder)

## Section 3: Using dplyr to Perform Data analysis
## Common syntax for data.frame functions command(dataframe, **)

## Section 3.1: Using dplyr to Subset Data
## In dplyr, we can use the "select" function to select columns:
select(gapminder, country)
gapminder_select = select(gapminder, country, year, pop)
head(gapminder_select)
dim(gapminder_select)

## We can also use the filter() function to subset rows according to logical condition:
filter(gapminder, year==1952)
filter(gapminder, continent==Asia)
filter(gapminder, continent=="Asia" & year > 1980)
gapminder_filter = filter(gapminder, continent=="Asia" | continent=="Europe")
head(gapminder_filter)
dim(gapminder_filter)

## dplyr comes with a "piping" operator that allows us to perform multiple computations on the same data frame in a single command. 
## This operator is %>%: you can think of it as taking the output of the left hand side, and passing it into the function on the right hand side.
## Command 1 %>% "then" Command 2
gapminder_pipe = select(gapminder, country, year, lifeExp) %>%
  filter (year<1980)
head(gapminder_pipe)
dim(gapminder_pipe)

### Challenge 1: Subsetting
### 1. Using pipes, subset the gapminder data to only include rows where the country is on the African continent and the year is between 1980 and 1990 and retain only the columns country, lifeExp, and pop.

## Section 3.2: Using dplyr to create new columns
## We can use the mutate() function to create new columns by using information from other columns
gapminder %>% 
mutate(gdptotal = pop*gdpPercap)

## Section 3.3: Using dplyr to Split-apply-combine data analysis and the summarize() function
## We can use the group_by() function to split the data into groups, apply some analysis to each group, and then combine the results
### The group_by() function is frequently used with the summarize() function to collapse the results for each group into one row
gapminder %>% 
group_by(continent) %>% 
summarize(mean(lifeExp))

gapminder_summarize <- gapminder %>%
  group_by(continent, year) %>%
  summarize(meanGDP = mean(gdpPercap)) # We can name the new column in the summarize function
head(gapminder_pipe)
dim(gapminder_pipe)

## Note that the output is a grouped tibble. To obtain an ungrouped tibble, use the ungroup function:
gapminder %>% 
  group_by(continent) %>% 
  summarize(mean(lifeExp)) %>%
  ungroup()

## We can also run group_by() and mutate() in combination to apply analysis to each group, but do not collapse the results
gapminder_mutate_summarize <- gapminder %>% 
  group_by(continent) %>% 
  mutate(meanLife = mean(lifeExp))
view(gapminder_mutate_summarize)

gapminder %>%  
  group_by(continent, year) %>% 
   mutate(mean_continent_gdp = mean(gdpPercap),
          gdpPercap_diff = gdpPercap - mean_continent_gdp) %>% 
  arrange(desc(gdpPercap_diff))

## We can use the arrange() to sort the data.frame
gapminder %>%
  arrange(pop)

## We can use desc in the arrange() to sort in decreasing order
gapminder %>%
  arrange(desc(pop))

gapminder %>% 
  group_by(continent) %>% 
  summarize(meanLife = mean(lifeExp), 
            mingdp = min(year)) %>% 
  arrange(desc(meanLife))

## We can use the count() to count observations
gapminder %>%
  count(continent)

gapminder %>% 
  filter(pop > 10000000 & gdpPercap > 5000) %>% 
  count(continent)

### Challenge 2: Analyzing Data
### 1. How many countries in the survey have a lifeExp rounded to the nearest integer of 30? or 36? 
### 2. Use group_by() and summarize() to find the mean, min, and max number of pop for each continent. Also add the number of observations (hint: see ?n).

## Section 4: Using stringr to manipulate strings
## All functions in stringr start with str_ and take a vector of strings as the first argument.
## We can use str_flatten() to combine a string vector into a single string
gapminder %>%
  group_by(continent) %>%
  summarise(str_flatten(unique(country), collapse = ", "))

## We can use str_c() to join multiple strings into a single string
gapminder %>%
  mutate(str_c(continent,country, sep = "-"))

## We can use str_detect() in a filter() to select rows where string matches a pattern
gapminder_detect = gapminder %>%
  filter(str_detect(country,"au"))
view(gapminder_detect)

## Section 5: Reading Data from CSV
## We can use readr to read in csv, tsv, or any other delimited files into a dataframe. readr also supports fixed-width files.

## Navigating directory structures can be confusing. We have to remember a lot of aspects of of where our files are located. This can be fragile and dependent on the way we order files on our computers, which are often different than the way our friends and colleagues do it. 
## One way to make this easier is to take advantage of the "here" R package.
## The "here" package enables easy file referencing by using the top level directory of our project to build the file paths.
# install.packages("here")
library(here)
interviews <- read_csv(here("Data", "SAFI_clean.csv"), na = "NULL")
str(interviews)

## Section 6: Using tidyr to change layout of dataframes
interviews %>%
  select(key_ID, village, interview_date, instanceID)

## For each interview date in each village no instanceIDs are the same. Thus, this format is what is called a “long” data format, where each observation occupies only one row in the dataframe.
interviews %>%
  filter(village == "Chirodzo") %>%
  select(key_ID, village, interview_date, instanceID) %>%
  head(10)

## In the “longest” data format there would only be three columns, one for the id variable, one for the observed variable, and one for the observed value (of that variable). This data format is quite unsightly and difficult to work with, so you will rarely see it in use.

## Alternatively, in a “wide” data format columns can represent different levels/values of a variable. For instance, in some data you encounter the researchers may have chosen for every survey date to be a different column.

## Section 6.1 Pivoting wider
## We can use the pivot_wider() to transform interviews to create new columns for each type of wall construction material.
interviews_wide <- interviews %>%
    mutate(wall_type_logical = TRUE) %>%
    pivot_wider(names_from = respondent_wall_type,
                values_from = wall_type_logical,
                values_fill = list(wall_type_logical = FALSE))

## Section 6.2 Pivoting longer
## The opposite of `pivot_wider` is `pivot_longer`.
interviews_long <- interviews_wide %>%
    pivot_longer(cols = burntbricks:sunbricks,
                 names_to = "respondent_wall_type",
                 values_to = "wall_type_logical")