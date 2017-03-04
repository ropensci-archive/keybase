#' List files/directories in a user's public folder
#'
#' @md
#' @param user Keybase user ID or a `keybase.pub` URL
#' @param path (optional) path (relative from the top level of the public folder).
#'        If `user` is a URL this parameter is ignored.
#' @param pattern if not `NULL`, then the file list will be filtered using the
#'        `stringi`-acceptable regular expression passed in
#' @return `tibble` with the directory listing results
#' @export
#' @examples
#' kb_list_files("marcopolo")
#' kb_list_files("marcopolo", pattern="\\.txt")
kb_list_files <- function(user, path, pattern=NULL) {

  user <- user[1]

  if (grepl("^https://keybase.pub/", user)) {
    res <- httr::GET(user)
  } else {
    URL <- sprintf("https://keybase.pub/%s/", user)
    if (!missing(path)) URL <- paste0(URL, path, collapse = "")
    res <- httr::GET(URL)
  }

  httr::stop_for_status(res)

  res <- httr::content(res, as = "text")
  res <- xml2::read_html(res)
  res <- rvest::html_nodes(res, "table.table-dir-contents")

  purrr::map_df(rvest::html_nodes(res, "tr"), function(x) {

    cols <- rvest::html_nodes(x, "td")

    entry_type <- rvest::html_attr(cols[[1]], "class")
    entry_type <- trimws(gsub("icon-col[-]*", "", entry_type))

    entry_url <- rvest::html_nodes(cols[[2]], "a")
    entry_url <- rvest::html_attr(entry_url, "href")

    entry_name <- rvest::html_text(cols[[2]])

    tibble::data_frame(
      entry_name = entry_name,
      entry_type = entry_type,
      entry_url = entry_url
    )

  }) -> out

  out <- dplyr::filter(out, (entry_type %in% c("file", "dir")))

  out <- dplyr::mutate(out, raw_url = kb_plain_to_raw_url(entry_url))

  if (!is.null(pattern)) {
    out <- dplyr::filter(out, stringi::stri_detect_regex(entry_name, pattern))
  }

  out

}
