#' Tools to Work with the 'Keybase' 'API'
#'
#' 'Keybase' <keybase.io> is a directory of people and public keys and provides
#' methods for obtaining public keys, validating users and exchanging files and/or messages
#' in a secure fashion. Tools are provided to search for and retrieve information about
#' 'Keybase' users, retrieve and import user public keys and list and/or download files.\cr
#' \cr
#' There's also a thin but useful R wrapper around many of they `keybase` command-line
#' utility functions.
#'
#' @md
#' @name keybase
#' @docType package
#' @author Bob Rudis (bob@@rud.is)
#' @import purrr scrypt getPass gpg
#' @importFrom httr GET content stop_for_status verbose add_headers
#' @importFrom jsonlite fromJSON
#' @importFrom tibble as_tibble data_frame
#' @importFrom xml2 read_html
#' @importFrom rvest html_nodes html_table
#' @importFrom dplyr filter select mutate as_data_frame
#' @importFrom stringi stri_replace_first_regex stri_split_fixed stri_detect_regex
#' @importFrom rio import
NULL
