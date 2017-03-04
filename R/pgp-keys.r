#' Retrive the public key(s) for a given user
#'
#' @md
#' @param user user
#' @param import if `TRUE`, import into local GPG keyring
#' @return single character vector with the key(s) (invisibly)
#' @export
kb_get_public_keys <- function(user, import=FALSE) {

  res <- GET(sprintf("https://keybase.io/%s/pgp_keys.asc", user))

  httr::stop_for_status(res, task = "User not found")

  res <- httr::content(res, as="text")

  if (import) {
    tf <- tempfile()
    writeLines(res, tf)
    gpg::gpg_import(tf)
    unlink(tf)
  }

  invisible(res)

}