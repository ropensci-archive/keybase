#' Retrieve info on Keybase user(s)
#'
#' @md
#' @param users vector of usernames / mails
#' @param fields user information fields to return. Any combination of "all", basics",
#'        "cryptocurrency_addresses",  "pictures", "proofs_summary", "profile",
#'        "public_keys", "remote_key_proofs", "sigs". If left unchanged, the
#'        default is to return "basics" and "profile". If "all" is one of the
#'        character vectors, then it supersedes any other combination and
#'        returns all of fields.
#' @return `tibble`
#' @export
#' @examples
#' kb_lookup("hrbrmstr")
kb_lookup <- function(users, fields = c("basics", "profile")) {

  kb_fields <- c("basics", "cryptocurrency_addresses",
                 "pictures", "proofs_summary", "profile",
                 "public_keys", "remote_key_proofs", "sigs")

  users <- trimws(users)

  fields <- trimws(fields)
  fields <- match.arg(fields, several.ok = TRUE, choices = c("all", kb_fields))

  users <- commafy(users)

  if ("all" %in% fields) fields <- kb_fields

  fields <- commafy(fields)

  res <- httr::GET("https://keybase.io/_/api/1.0/user/lookup.json",
                   query=list(usernames = users, fields = fields))

  httr::stop_for_status(res)

  res <- httr::content(res, as="text")
  res <- jsonlite::fromJSON(res, simplifyDataFrame=TRUE, flatten=TRUE)

  if (res$status$code == 100L) {
    warning(sprintf("Keybase API error: %s", res$status$desc))
    return(invisible(NULL))
  }

  res$them <- tibble::as_tibble(res$them)

  class(res) <- "kbusers"

  res

}

#' @rdname kb_lookup
#' @param x object to print
#' @param ... unused
#' @export
print.kbusers <- function(x, ...) {
  print(x$them)
}