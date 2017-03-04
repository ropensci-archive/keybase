#' Check Keybase membership and retrieve basic user info
#'
#' @md
#' @param twitter,github,hackernews,web,coinbase,key_fingerprint vectors of ids/fingerprints
#'        from known public services/data stores. At least one service must have
#'        one character vector populated. There can be multiple items per character
#'        vector.
#' @param kb_usernames_only if `FALSE`, return a substantial amount of Keybase info/proofs
#'        for each user. If `TRUE`, return just the Keybase usernames. Default: `FALSE`
#' @export
#' @examples
#' kb_discover(twitter=c("hrbrmstr", "_inundata", "briandconnelly"), github="bearloga")
#' kb_discover(twitter=c("sckottie", "_inundata", "briandconnelly"), kb_usernames_only=TRUE)
kb_discover <- function(twitter, github, hackernews, web, coinbase, key_fingerprint,
                        kb_usernames_only = FALSE) {

  params <- list()

  if (!missing(twitter)) params$twitter <- commafy(twitter)
  if (!missing(github)) params$github <- commafy(github)
  if (!missing(hackernews)) params$hackernews <- commafy(hackernews)
  if (!missing(web)) params$web <- commafy(web)
  if (!missing(coinbase)) params$coinbase <- commafy(coinbase)
  if (!missing(key_fingerprint)) params$key_fingerprint <- commafy(key_fingerprint)
  if (kb_usernames_only) params$usernames_only = 1L

  if (length(params) == 0) {
    message("No accounts specified")
    return(invisible(NULL))
  }

  res <- httr::GET("https://keybase.io/_/api/1.0/user/discover.json", query=params)

  httr::stop_for_status(res)

  res <- httr::content(res, as="text")
  res <- jsonlite::fromJSON(res, simplifyDataFrame=TRUE, flatten=TRUE)

  if (kb_usernames_only) {
    res <- map_df(res$matches, function(x) {
      map_df(x, ~set_names(as_data_frame(.), "username"))
    }, .id = "service")
  } else {
    res <- map_df(res$matches, function(x) { map_df(x, ~.) }, .id = "service")
  }

  class(res) <- c("kbdiscover", "tbl_df", "tbl", "data.frame")
  res

}

