# pinboard 📌

<!-- badges: start -->
[![R-CMD-check](https://github.com/andodet/pinboard/workflows/R-CMD-check/badge.svg)](https://github.com/andodet/pinboard/actions?query=workflow%3AR-CMD-check)
<!-- badges: end -->

Full featured R API wrapper for [pinboard.in](https://www.pinboard.in).  

The package allows to interact with bookmarks, notes and tags.

## Installation

You can install the package via:
```r
remotes::install_github("andodet/pinboard")
```

## Authentication

To use the package, an API token from [pinboard](https://www.pinboard.in) is required.
You can get one from _settings_ > _password_.  

The token can be supplied to the package via an environment variable either system-wide
or within the R environment:

```bash
export API_TOKEN=your_api_string
```
```r
Sys.setenv(API_TOKEN = "your_api_string")
```

## Overview

Below a few example of the main functions. Check [here](https://andodet.github.io/pinboard/) 
for full documentation.

### Bookmarks

The package lets to dump user's bookmark collection in a data frame:
```r
library(pinboard)

get_all_bookmarks()

#> # A tibble: 119 x 9
#>    href      description     extended    meta   hash   time  shared toread tags 
#>    <chr>     <chr>           <chr>       <chr>  <chr>  <chr> <chr>  <chr>  <chr>
#>  1 https://… some title      <NA>        da287… 56164… 2020… yes    no     <NA> 
#>  2 https://… Some test note  <NA>        29d68… 88e03… 2020… no     no     R    
#>  3 https://… some desc       <NA>        9405d… 24156… 2020… yes    no     new_…
#>  4 https://… Benefits of a … <NA>        e01df… e8bff… 2020… yes    no     R    
#>  5 https://… Effectively De… <blockquot… 79818… 49e1d… 2020… yes    no     R    
#>  6 https://… r - dplyr func… <NA>        6129c… 32c73… 2020… yes    no     R    
#>  7 http://t… Advanced Bash-… <NA>        c0bfd… 9ca94… 2020… yes    no     <NA> 
#>  8 https://… How Silicon Va… <NA>        f4c58… 269cf… 2020… yes    no     <NA> 
#>  9 https://… Rules of thumb… <blockquot… ded84… 15a5c… 2020… yes    no     <NA> 
#> 10 https://… How the heck d… Async prog… 1ba1d… aec99… 2020… yes    no     pyth…
#> # … with 109 more rows
```

Adding a bookmark is as simple as passing a `url` and a `title`:
``` r
library(pinboard)
add_bookmark(url = "https://pudding.cool/", title = "Data viz wizards")

#> [1] TRUE
```

The API offers some endpoint for reporting usage over time
```r
library(pinboard)
library(dplyr)

n_bookmarks_by_date() %>% 
    arrange(desc(count))

#> # A tibble: 71 x 2
#>    date       count
#>    <date>     <int>
#>  1 2019-10-08    10
#>  2 2019-08-26     7
#>  3 2019-08-21     5
#>  4 2020-02-14     3
#>  5 2020-02-13     3
#>  6 2020-02-12     3
#>  7 2019-11-03     3
#>  8 2019-10-24     3
#>  9 2019-10-22     3
#> 10 2019-09-01     3
#> # … with 61 more rows
```

### Tags

On top of standard operations with tags, it is possible to retrieve most used tags:

```r
library(pinboard)
library(dplyr)

get_all_tags() %>% 
    head() %>% 
    arrange(desc(count ))

#> # A tibble: 6 x 2
#>   tag       count
#>   <chr>     <int>
#> 1 docker        4
#> 2 analytics     3
#> 3 gcp           2
#> 4 articles      1
#> 5 books         1
#> 6 hn            1
```
