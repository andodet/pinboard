#' Converts API response to a tibble
#'
#' Pinboars API ingests UTC timestamps in the "%Y-%m-%dT%H:%M:%S" format
#'
#' @import httr
#' @import dplyr
#' @import jsonlite
#'
#' @keywords internal
res_to_df <- function(res) {

  res_df <- content(res, as = "text", encoding = "UTF-8") %>%
    fromJSON() %>%
    as_tibble() %>%
    mutate_all(., list(~na_if(., "")))

  return(res_df)
}


#' Parses a boolean API response
#'
#' @param res An httr response
#' @return TRUE if successful, error message otherwise.
#'
#' @import httr
#' @import jsonlite
#'
#' @keywords internal
parse_bool_res <- function(res) {
  parsed_res <- content(res, encoding = "UTF-8", as = "text") %>%
    fromJSON()

  if (parsed_res[[1]] == "done") {
    return(TRUE)
  } else {
    msg <- paste("A problem has occurred:", parsed_res[[1]], sep = " ")
    return(msg)
  }
}


#' Converts a boolean to yes/no string
#'
#' Instead of booleans, pinboard.in API uses 'yes'/'no' strings.
#'
#' @param (BOOL) A boolean value
#' @return (str) yes or no
#'
#' @keywords internal
bool_to_yesno <- function(x) {
  if (is.null(x)) {
    return("")
  } else if (x) {
    return("yes")
  } else if (!x) {
    return("no")
  }
}
