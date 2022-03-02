## Let's install a couple of packages to demonstrate some aspects of the R Package Ecosystem
install.packages("tidyverse")
install.packages("psych")
install.packages("randomForest")

## Now we need to load the packages into the current R session
library(tidyverse) # Notice the conflicts in the console output
library(psych) # Notice the "masked" objects in the console output
library(randomForest) # Notice the "masked" objects in the console output

## When a package is loaded with a function with the same name as an existing loaded package's function, then there is a conflict. To fix this conflict, R will mask the function in the existing package. A masked function can only be accessed by appending the namespace to the function.  
outlier() # Will use the outlier function from the randomForest package
psych::outlier() # Will use the outlier function from the psych package

## To further demonstrate the conflicting name issue, we will reload the packages in a different order.
## To unload a package from the R session, use the detach() function
detach("package:dplyr")
detach("package:psych")
detach("package:randomForest")

library(randomForest)
library(psych)
library(dplyr)

outlier() # Will use the outlier function from the psych package
randomForest::outlier() # Will use the outlier function from the randomForest package

## Over time packages will deprecate a function, typically in favor of a more accurate function. Let's look at the combine function in the dplyr package.
?combine

## Using the CRAN documentation for randomForest and psych, we will run some functions.
