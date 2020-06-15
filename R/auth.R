#' Get api secret
#'
#' Api secret allows to access user's private feeds.
#'
#' @param api_token api auth token.
#'
#' @return A string
#'
#' @import httr
#'
#' @export
get_secret <- function(api_token=Sys.getenv("API_TOKEN")) {

  params = list(auth_token = api_token)

  res <- RETRY(
    "GET",
    url = "https://api.pinboard.in/",
    path = "v1/user/secret",
    query = list(auth_token = api_token)
  )

  stop_for_status()
  secret_parsed <- content(res) %>%
    as.list(.data)

  return(secret_parsed[["result"]][[1]])
}
