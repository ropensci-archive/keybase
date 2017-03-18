#' See if a file exists
#'
#' @md
#' @param user Keybase user ID or a `keybase.pub` URL
#' @param path path of resource (file) to read (relative from the top level of the public folder).
#'        If `user` is a URL this parameter is ignored.
#' @return `TRUE` if the specified file exists
#' @export
#' @examples
#' kb_file_exists("hrbrmstr", "index.md")
#' kb_file_exists("https://hrbrmstr.keybase.pub/data/Rlogo.pngd")
#' kb_file_exists("hrbrmstr", "data/Rlogo.png")
kb_file_exists <- function(user, path) {

  user <- user[1]

  if (grepl("^https://.*.keybase.pub/", user)) {
    rsrc <-  user
  } else {
    rsrc <- sprintf("https://%s.keybase.pub/%s", user, path)
  }

  res <- httr::HEAD(rsrc)

  httr::status_code(res) == 200

}

#' Turn a user + path into a Keybase "raw" URL
#'
#' @param user Keybase user ID
#' @param path path of resource (file/dir) relative from the top level of the public folder
#' @export
#' @examples
#' kb_raw_url("hrbrmstr", "data/mtcars.json")
kb_raw_url <- function(user, path) {
  rsrc <- sprintf("https://%s.keybase.pub/%s", user, path)
  rsrc
}

#' Read a resource (file) from a Keybase public folder
#'
#' @md
#' @param user Keybase user ID or a `keybase.pub` URL
#' @param path path of resource (file) to read (relative from the top level of the public folder).
#'        If `user` is a URL this parameter is ignored.
#' @return the imported object (see [rio::import])
#' @export
#' @examples
#' kb_list_files("hrbrmstr", "data")
#' kb_read_file("hrbrmstr", "data/mtcars.csv")
kb_read_file <- function(user, path) {

  user <- user[1]

  if (grepl("^https://.*.keybase.pub/", user)) {
    rsrc <-  user
  } else {
    rsrc <- kb_raw_url(user, path)
  }

  if (kb_file_exists(rsrc)) {
    rio::import(rsrc)
  } else {
    warning("File not found")
    return(invisible(NULL))
  }

}
