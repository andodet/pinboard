#' Add bookmark
#'
#' Add a bookmark to user collection.
#'
#' @param api_token (chr) api auth token.
#' @param url (chr) Url to add.
#' @param title (chr) Title of the bookmark.
#' @param extended (chr) Description of the item.
#' @param tags (chr vector) List of tags, up to 100 tags.
#' @param date (date) Creation date for the bookmark, to be formatted as 2020-02-23T12:32:45Z.
#' @param replace (bool) Replace an existing bookmark. Throws an error if set to false.
#' @param shared (bool) Make the bookmark public.
#' @param toread (bool) Flags the bookmark as unread. Default is FALSE.
#'
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#' @import jsonlite
#'
#' @export
add_bookmark <- function(api_token = Sys.getenv("API_TOKEN"), url, title, extended = NULL,
                     tags = NULL, date = NULL, replace = TRUE, shared = TRUE, toread = FALSE) {

  date <- paste0(date, "T12")
  if (length(tags) > 100) {
    stop(paste("You have added", length(tags), ", max allowed is 100", sep = " "))
  }

  params <- list(
    auth_token = api_token,
    url = url,
    description = title,
    extended = extended,
    tags = tags,
    date = date,
    replace = bool_to_yesno(replace),
    shared = bool_to_yesno(shared),
    toread = bool_to_yesno(toread),
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/add",
    query = params,
    user_agent("r_lib"),
    format = res_format
  )

  stop_for_status(res)
  parsed_res <- parse_bool_res(res)

  return(parsed_res)
}


#' Delete a bookmark
#'
#' Deletes a bookmark from user's collection.
#'
#' @param api_token (chr) api auth token.
#' @param url (chr) Url to delete.
#'
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#' @import jsonlite
#'
#' @export
delete_bookmark <- function(api_token = Sys.getenv("API_TOKEN"), url) {

  params <- list(
    auth_token = api_token,
    url = url,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/delete",
    query = params,
    user_agent("r_lib")
  )

  stop_for_status(res)
  parsed_res <- parse_bool_res(res)

  return(parsed_res)
}


#' Get all bookmarks
#'
#' Get all bookmarks in a user collection.
#'
#' @param api_token (chr) api auth token.
#' @param tags (chr vector) List of tags, up to 100 tags.
#' @param start (int) Offset value. Default is 0.
#' @param n_results (int) Number of result to return. Default is all.
#' @param from_date (date) Return only bookmarks after this date. To be formatted as 2020-02-23T12:32:45Z.
#' @param to_date (date) Return only bookmarks before this date. To be formatted as 2020-02-23T12:32:45Z.
#' @param meta (BOOL) Include a change detection signature for each bookmark.
#'
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#' @import jsonlite
#'
#' @export
get_all_bookmarks <- function(api_token = Sys.getenv("API_TOKEN"),
                              tags = NULL,
                              start = 0,
                              n_results = NULL,
                              from_date = NULL,
                              to_date = NULL,
                              meta = FALSE) {

  if (length(tags) > 3) {
    stop("You can use maximum 3 tags")
  }

  params <- list(
    auth_token = api_token,
    tag = tags,
    results = n_results,
    start = start,
    fromdt = from_date,
    todt = to_date,
    meta = bool_to_yesno(meta),
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/all",
    query = params,
    user_agent("r_lib")
  )

  # stop_for_status(res)
  posts <- res_to_df(res)

  return(posts)

}


#' Get number of boorkmarks by date
#'
#' Returns a tibble with the number of bookmarks created by date.
#'
#' @param api_token (chr) api auth token.
#' @param tags (chr vector) Filter up to 3 tags.
#'
#' @return A tibble
#'
#' @import httr
#' @importFrom purrr pluck
#' @import jsonlite
#' @import tibble
#' @import tidyr
#'
#' @export
#'
n_bookmarks_by_date <- function(api_token = Sys.getenv("API_TOKEN"),
                            tags = NULL) {

  if (length(tags) > 3) {
    stop("You can use maximum 3 tags")
  }

  params <- list(
    auth_token = api_token,
    tag = tags,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/dates",
    query = params
  )

  stop_for_status(res)

  post_count <- content(res) %>%
    fromJSON() %>%
    pluck("dates") %>%
    enframe(name = "date", value = "count") %>%
    unnest(c(count)) %>%
    mutate(date = as.Date(date))

  return(post_count)

}


#' Get recent bookmarks
#'
#' Get user's recent bookmarks, filtered by tag.
#'
#' @param api_token (chr) api auth token.
#' @param tags (chr vector) Filter up to three tags
#' @param n_results (int) Number of result to return. Default is all.
#'
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#' @import jsonlite
#' @import tibble
#'
#' @export
get_recent_bookmarks <- function(api_token = Sys.getenv("API_TOKEN"),
                             tags = NULL, n_results = NULL) {

  if (length(tags) > 3) {
    stop("You can use maximum 3 tags")
  }

  params <- list(
    auth_token = api_token,
    tag = tags,
    count = n_results,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/recent",
    query = params
  )

  stop_for_status(res)
  recent_bookmarks <- res_to_df(res)

  return(as_tibble(recent_bookmarks$posts))

}


#' Get time of last interaction
#'
#' Returns the most recent time a bookmark was added, updated or deleted.
#'
#' @param api_token (chr) api auth token.
#'
#' @import httr
#'
#' @export
date_last_updated <- function(api_token = Sys.getenv("API_TOKEN")) {

  params <- list(
    auth_token = api_token,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/update",
    query = params
  )

  stop_for_status(res)
  last_updated <- res_to_df(res)

  return(last_updated[[1]])

}
