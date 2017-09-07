#' Retrieve KBFS error log
#'
#' @return data frame of error log entries
#' @export
kbfs_errors <- function() {
  err_log <- "/keybase/.kbfs_error"
  if (file.exists(err_log)) {
    as_tibble(jsonlite::fromJSON(err_log, flatten=TRUE))
  }
}

#' Retrieve KBFS performance metrics
#'
#' TODO: Parse this into a data frame
#'
#' @export
kbfs_metrics <- function() {
  metrics <- "/keybase/.kbfs_metrics"
  if (file.exists(metrics)) {
    message("HERE")
    tmp <- readBin(metrics, "raw", file.size(metrics))
    tmp <- rawToChar(tmp)
    cat(tmp)
    invisiblke(tmp)
  }
}