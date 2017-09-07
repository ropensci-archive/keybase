# temporary steal from https://github.com/ianmcook/wkb/blob/master/R/hex2raw.R
hex_to_raw <- function(hex) {
  hex <- gsub("[^0-9a-fA-F]", "", hex)
  if(length(hex) == 1) {
    if(nchar(hex) < 2 || nchar(hex) %% 2 != 0) {
      stop("hex is not a valid hexadecimal representation")
    }
    hex <- strsplit(hex, character(0))[[1]]
    hex <- paste(hex[c(TRUE, FALSE)], hex[c(FALSE, TRUE)], sep = "")
  }
  if(!all(vapply(X = hex, FUN = nchar, FUN.VALUE = integer(1)) == 2)) {
    stop("hex is not a valid hexadecimal representation")
  }
  as.raw(as.hexmode(hex))
}

commafy <- function(x) { paste0(trimws(x), collapse=",") }

kb_plain_to_raw_url <- function(lst) {
  map_chr(lst, function(x) {
    if (grepl("/$", x)) return(NA_character_)
    x <- stringi::stri_replace_first_regex(x, "^https://keybase.pub/", "")
    x <- stringi::stri_split_fixed(x, "/", 2)[[1]]
    sprintf("https://%s.keybase.pub/%s", x[1], x[2])
  })
}

.kb_user_info <- function() {
  jsonlite::fromJSON("/keybase/public/.kbfs_status", flatten=TRUE)
}