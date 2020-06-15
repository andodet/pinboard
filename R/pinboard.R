#' A full-featured API wrapper for pinboard.in
#'
#' See documentation at \href{https://andodet.github.io/pinboard/}{https://andodet.github.io/pinboard/}
#'
#' @docType package
#' @name pinboard


# Global variables -------------------------------------------------------------

# API response format (xml / json)
res_format <- "json"

# Maximum number of retries for httr
max_retries <- 5

# Max wait time before timeout
max_wait <- 10

# Avoid RMD Check note on visible bindings
utils::globalVariables(c("."))
