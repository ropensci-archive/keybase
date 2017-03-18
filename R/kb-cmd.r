#' Execute a keybase command-line command
#'
#' @md
#' @param cmd command to execute
#' @param stdout,stderr logical
#' @references [https://keybase.io/docs/command_line](https://keybase.io/docs/command_line)
#' @export
kb_cmd <- function(cmd, stdout = TRUE, stderr = FALSE) {

  kb <- Sys.which("keybase")

  if (kb == "") {
    stop("keybase executable not found. Please visit https://keybase.io/ for download/installation instructions",
         call.=FALSE)
  }

  out <- system2(command = kb, args = cmd, stdout = stdout, stderr = stderr)

  out

}

#' @rdname kb_cmd
#' @export
kb_following <- function() { kb_cmd("list-following") }

#' @rdname kb_cmd
#' @export
kb_followers <- function() { kb_cmd("list-followers") }

#' @rdname kb_cmd
#' @export
kb_ping <- function() {

  out <- kb_cmd("ping", stderr=TRUE)

  up <- any(grepl("is up$", out))

  if (!up) warning(out)

  up

}

#' Encrypt/decrypt a message
#'
#' @param users keybase user ids (character vector)
#' @param msg message text
#' @export
kb_encrypt_msg <- function(users, msg) {

  users <- paste0(users, collapse=" ")

  kb_cmd(c("encrypt", users, "-m", shQuote(msg)))

}

#' @rdname kb_encrypt_msg
#' @export
kb_decrypt_msg <- function(msg) {
  kb_cmd(c("decrypt", "-m", shQuote(msg)))
}

#' Encrypt/decrypt a file
#'
#' @md
#' @param users keybase user ids (character vector)
#' @param infile path to file to encrypt
#' @param outfile if `NULL` then the encrypted/decrypted file contents are returned as
#'        a vector (type depends on value of `binary`). If a string, it should be a
#'        valid path to where the encrypted/decrypted file will be written.
#' @param binary if `TRUE` iutput in binary (rather than ASCII/armored which is the default)
#' @export
kb_encrypt_file <- function(users, infile, outfile = NULL, binary = FALSE) {

  if (!file.exists(infile)) stop(sprintf("[%s] not found", infile), call.=FALSE)

  in_arg <- c("-i", shQuote(infile))

  if (is.null(outfile)) {

    ret_enc <- TRUE
    outfile <- tempfile()

  } else {

    ret_enc <- FALSE
    out_path <- dirname(outfile)

    if (!dir.exists(out_path)) stop(sprintf("[%s] not found", out_path), call.=FALSE)
    if (file.access(out_path, 2) == -1) stop(sprintf("[%s] not writeable", out_path), call.=FALSE)

  }

  out_arg <- c("-o", shQuote(outfile))

  users <- paste0(users, collapse=" ")

  bin_arg <- if (binary) "-b" else ""

  cmd <- c("encrypt", users, bin_arg, in_arg, out_arg)

  catch_err <- kb_cmd(cmd, stderr=TRUE)

  if (ret_enc) {

    bytes <- file.size(outfile)

    if (binary) {
      ret_val <- readBin(outfile, what = "raw", n = bytes)
    } else {
      ret_val <- readChar(outfile, nchars = bytes, useBytes = TRUE)
      ret_val <- sub("\n$", "", ret_val)
    }

    unlink(outfile)

    return(ret_val)

  }

}

#' @rdname kb_encrypt_file
#' @export
kb_decrypt_file <- function(infile, outfile = NULL) {

  if (!file.exists(infile)) stop(sprintf("[%s] not found", infile), call.=FALSE)

  in_arg <- c("-i", shQuote(infile))

  if (is.null(outfile)) {

    ret_enc <- TRUE
    outfile <- tempfile()

  } else {

    ret_enc <- FALSE
    out_path <- dirname(outfile)

    if (!dir.exists(out_path)) stop(sprintf("[%s] not found", out_path), call.=FALSE)
    if (file.access(out_path, 2) == -1) stop(sprintf("[%s] not writeable", out_path), call.=FALSE)

  }

  out_arg <- c("-o", shQuote(outfile))

  tf <- tempfile()
  encryptor_arg <- c("--encryptor-outfile", shQuote(tf))

  cmd <- c("decrypt", in_arg, out_arg, encryptor_arg)

  catch_err <- kb_cmd(cmd, stderr=TRUE)

  message(sprintf("File [%s] encrypted by [%s]", infile, readLines(tf, warn = FALSE)))

  unlink(tf)

  if (ret_enc) {

    bytes <- file.size(outfile)
    ret_val <- readBin(outfile, what = "raw", n = bytes)

    unlink(outfile)

    return(ret_val)

  }

}