## Load packages

library(sf)
library(rgdal)
library(tidyverse)
library(tmap)
library(tmaptools)
library(janitor)
library(dplyr)
install.packages('rgdal')
install.packages("janitor")

## Read dataset as df

getwd()
df <- read.csv("HDR21-22_Composite_indices_complete_time_series.csv")

## Data cleaning and adding new Gender Inequality Index Difference between 2010 & 2019 column (gii_diff)

gii <- df %>%
  clean_names() %>%
  select(iso3, country, gii_2010, gii_2019) %>%
  slice(1:195) %>%
  mutate(., gii_diff=(gii_2019-gii_2010)) %>%
  na.omit(df)
gii

## Read world countries spatial data (shapefile) as world

world <- st_read("World_Countries_(Generalized)/World_Countries__Generalized_.shp")

library(countrycode)


world
joined_data <- world %>% 
  clean_names() %>%
  left_join(., 
            gii,
            by = c("iso" = "iso"))
```
## Plot the Gender Inequality Difference 2010 & 2019 map

tm_shape(joined_data) + 
  tm_polygons("gii_diff", 
              style="pretty",
              palette="Blues",
              midpoint=NA,
              #title="Gender Inequality Difference 2010 & 2019",
              alpha = 0.7) + 
  tm_compass(position = c("left", "bottom"),type = "arrow") + 
  tm_scale_bar(position = c("left", "bottom")) +
  tm_layout(title = "Gender Inequality Difference 2010 & 2019", legend.position = c("right", "bottom")) +
  tmap_options(max.categories = 115)