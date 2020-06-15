#' Return all user notes
#'
#' Returns a dataframe of all notes created by user.
#'
#' @param api_token api auth token
#'
#' @return A tibble.
#'
#' @import httr
#' @import tibble
#'
#' @export
get_all_notes <- function(api_token = Sys.getenv("API_TOKEN")) {

  params <- list(
    auth_token = api_token,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/notes/list",
    query = params
  )

  stop_for_status(res)
  notes <- res_to_df(res)

  browser()

  return(as_tibble(notes$notes))

}


#' Return a specific user note
#'
#' Retrieve a specific note by id.
#'
#' @param api_token api auth token.
#' @param id Id of the note to be retrieved.
#'
#' @return A tibble.
#'
#' @import httr
#'
#' @export
get_note <- function(api_token = Sys.getenv("API_TOKEN"), id) {

  params <- list(
    auth_token = api_token,
    format = res_format
  )

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = paste0("v1/notes/", id),
    query = params
  )

  stop_for_status(res)
  note <- res_to_df(res)

  return(note)

}
