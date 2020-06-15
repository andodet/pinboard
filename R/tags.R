#' Geta all tags
#'
#' Returns a full list of the user's tags along with the number of times they were used.
#'
#' @param api_token (chr) api auth token.
#' @return A tibble.
#'
#' @import httr
#' @import tidyr
#'
#' @export
get_all_tags <- function(api_token = Sys.getenv("API_TOKEN")) {

  params <- list(
    auth_token = api_token,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/tags/get",
    query = params
  )

  stop_for_status(res)
  tags <- res_to_df(res)

  tags_df <- pivot_longer(tags, cols = names(tags), names_to = "tag",
                          values_to = "count")

  return(tags_df)
}


#' Delete a tag
#'
#' Deletes a tag in user collection.
#'
#' @param api_token (chr) api auth token.
#' @param tag (chr) Tag to be deleted.
#'
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#'
#' @export
delete_tag <- function(api_token = Sys.getenv("API_TOKEN"), tag) {

  params <- list(
    auth_token = api_token,
    tag = tag,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/tags/delete",
    query = params
  )

  stop_for_status(res)
  parsed_res <- parse_bool_res(res)

  return(parsed_res)


}


#' Rename tag
#'
#' Rename a tag found in user's collection.
#'
#' @param api_token api auth token.
#' @param old (chr) Tag to be renamed.
#' @param new (chr) New tag
#'
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#'
#' @export
rename_tag <- function(api_token = Sys.getenv("API_TOKEN"), old, new) {

  params <- list(
    auth_token = api_token,
    old = old,
    new = new,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/tags/rename",
    query = params
  )

  stop_for_status(res)
  parsed_res <- parse_bool_res(res)

  return(parsed_res)
}


#' Get tag recommendation for a URL
#'
#' Returns a list of popular tags and recommended tags for a given URL. Popular tags
#'   are tags used site-wide for the url; recommended tags are drawn from the user's own tags.
#'
#' @param api_token (chr) api auth token.
#' @param url (chr) URL address to get recommendations for.
#'
#' @return A list
#'
#' @import httr
#' @import jsonlite
#' @importFrom purrr map
#'
#' @export
#'
get_tag_recommendation <- function(api_token = Sys.getenv("API_TOKEN"),
                                   url) {

  params <- list(
    auth_token = api_token,
    url = url,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/posts/suggest",
    query = params,
    format = format
  )

  stop_for_status(res)

  recommendations <- content(res, as = "text") %>%
    fromJSON() %>%
    map(.data, unlist)

  return(recommendations)
}
