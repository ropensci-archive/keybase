#' Share RDS files with other Keybase users
#'
#' Specify the user(s) you want to share an R object with in a character vector
#' using the Keybase user conventions outline [in their kbfs introduction](https://keybase.io/docs/kbfs).
#' You do not need to specify yourself (the function takes care of adding you).
#'
#' Order of usernames does not matter as Keybase is smart enough to create and
#' resolve dynamic symbolic links of all user combos.
#'
#' @md
#' @param kb_users character vector of (other) Keybase user(s)
#' @param path Relative path to read from/write to.
#' @export
#' @examples
#' \dontrun{
#' kb_write_rds(mtcars, "marked", "reprex.rds")
#' kb_read_rds("marked", "reprex.rds")
#' }
kb_read_rds <- function(kb_users, path) {

  me <- .kb_user_info()

  kb_users <- c(me$CurrentUser, kb_users)

  full_path <- file.path("/keybase/private", commafy(kb_users), path)

  if (file.exists(full_path)) {
    readRDS(full_path)
  } else {
    stop("File/path not found.", call.=FALSE)
  }

}


#' @md
#' @param x R object to write to serialise.
#' @param compress Compression method to use: "none", "gz" ,"bz", or "xz".
#' @param ... Additional arguments to connection function. For example, control
#'   the space-time trade-off of different compression methods with
#'   `compression`. See [connections()] for more details.
#' @return `write_rds()` returns `x`, invisibly.
#' @rdname kb_read_rds
#' @export
kb_write_rds <- function(x, kb_users, path, compress = c("none", "gz", "bz2", "xz"), ...) {

  me <- .kb_user_info()

  kb_users <- c(me$CurrentUser, kb_users)

  full_path <- file.path("/keybase/private", commafy(kb_users), path)

  compress <- match.arg(compress)
  con <- switch(compress,
         none = file(full_path, ...),
         gz   = gzfile(full_path, ...),
         bz2  = bzfile(full_path, ...),
         xz   = xzfile(full_path, ...))

  on.exit(close(con), add = TRUE)

  saveRDS(x, con)

  invisible(x)

}