# Introduction Tidyverse
# Cornell Center for Social Sciences
# Adapted from Data Carpentry’s R for Social Scientists(https://datacarpentry.org/r-socialsci)

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
gapminder_select <- select(gapminder, country, year, pop)
head(gapminder_select)
dim(gapminder_select)

## We can also use the filter() function to subset rows according to logical condition:
filter(gapminder, year==1952)
filter(gapminder, continent==Asia)
filter(gapminder, continent=="Asia" & year > 1980)
gapminder_filter <- filter(gapminder, continent=="Asia" | continent=="Europe")
head(gapminder_filter)
dim(gapminder_filter)

## We can use the arrange() to sort the data.frame
arrange(gapminder, pop)

## We can use desc in the arrange() to sort in decreasing order
arrange(gapminder, desc(pop))

## We can use the count() to count observations
count(gapminder, continent)

## dplyr comes with a "piping" operator that allows us to perform multiple computations on the same data frame in a single command. 
## This operator is %>%: you can think of it as taking the output of the left hand side, and passing it into the function on the right hand side.
## Command 1 %>% "then" Command 2
## You can use ctrl+shift+m for PC and cmd+shift+m for mac to insert "%>%"
gapminder_pipe <- select(gapminder, country, year, lifeExp) %>%
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

head(gapminder_summarize)
dim(gapminder_summarize)


gapminder %>% 
  group_by(continent) %>% 
  summarize(meanLife = mean(lifeExp), 
            mingdp = min(year)) %>% 
  arrange(desc(meanLife))

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

## This new format can be used to answer different questions, such as what is the differences in households grouped by different types of construction materials. We can run a couple regressions to understand the difference in format. The basic regression syntax is (Dependent Variable~Independent Variables, data=Data Source)
interviews_wide_lm <- lm(years_liv ~ muddaub + burntbricks + sunbricks + cement, 
                        data = interviews_wide)
summary(interviews_wide_lm)
table(interviews_wide$cement)

## Section 6.2 Pivoting longer
## The opposite of `pivot_wider` is `pivot_longer`.
interviews_long <- interviews_wide %>%
    pivot_longer(cols = c(burntbricks, cement, muddaub, sunbricks),
                 names_to = "respondent_wall_type",
                 values_to = "wall_type_logical")

interviews_long <- interviews_wide %>%
    pivot_longer(cols = c(burntbricks, cement, muddaub, sunbricks),
                 names_to = "respondent_wall_type",
                 values_to = "wall_type_logical") %>%
  filter(wall_type_logical) %>%
  select(-wall_type_logical)

## We can run the regression again on the long format and notice that the only thing that changes is the coefficients. The regression needs a comparison group and defaults to the largest group in the column.
interviews_long_lm <- lm(years_liv~respondent_wall_type, data=interviews_long)
summary(interviews_long_lm)

## Section 6.3 Using Pivot Wider to clean data
## Pivot wider can also be helpful when you have column that contains multiple values.
interviews$items_owned

interviews_items_owned <- interviews %>%
  separate_rows(items_owned, sep = ";") %>%
  replace_na(list(items_owned = "no_listed_items")) %>%
  mutate(items_owned_logical = TRUE) %>%
    pivot_wider(names_from = items_owned,
                values_from = items_owned_logical,
                values_fill = list(items_owned_logical = FALSE))

nrow(interviews_items_owned)
view(interviews_items_owned)

## We calculate the average number of items from the list owned by respondents in each village. The rowSums() function can count the amount of TRUE values for given number of columns.
interviews_items_owned %>%
    mutate(number_items = rowSums(select(., bicycle:car))) %>%
    group_by(village) %>%
    summarize(mean_items = mean(number_items))
