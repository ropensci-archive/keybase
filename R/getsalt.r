#' #' Round 1 of the 2-round Keybase login protocol
#' #'
#' #' The Keybase login protocol is two rounds, to prevent replay attacks, and to allow
#' #' strong randomized salting of passwords.
#' #'
#' #' In the first round of the login protocol, the user presents a username or email
#' #' address to the server, and the server responds with the salt the user uploaded
#' #' during signup, and a short-lived random challenge. The salt doesn't change for a
#' #' given user, but the random challege will always be different, and expires after a
#' #' few minutes.
#' #'
#' #' The random challege is called login_session. It's not a trully random token, but
#' #' an unforgeable token cryptographically tied to client's user ID (or email) and a
#' #' timestamp. This construction saves the server from having to keep state, but the
#' #' client can treat the login_session as an opaque random token.
#' #'
#' #' If the user or email address does not exist, getsalt will reply with a deterministic
#' #' salt, a function of the parameters. This is so /getsalt can't be used to test for user
#' #' membership. (An unnecessary precaution with usernames, since Keybase is a public
#' #' directory.)
#' #'
#' #' @param email_or_username keybase email or username; will be pulled from the `KEYBASE_USERNAME`
#' #'        if it exists.
#' #' @export
#' get_salt <- function(email_or_username = Sys.getenv("KEYBASE_USERNAME")) {
#'
#'   res <- httr::GET("https://keybase.io/_/api/1.0/getsalt.json",
#'                    query=list(email_or_username=email_or_username),
#'                    verbose())
#'
#'   httr::stop_for_status(res)
#'
#'   res <- httr::content(res, as="text")
#'   res <- jsonlite::fromJSON(res)
#'
#'   res$email_or_username <- email_or_username
#'
#'   class(res) <- "kbsalt"
#'   res
#'
#' }
#'
#'
#' #' Round 2 of the 2-round Keybase login protocol
#' #'
#' #' @param salt salt
#' #' @param passphrase passphrase
#' #' @export
#' kb_login <- function(salt = get_salt(Sys.getenv("KEYBASE_USERNAME")),
#'                      passphrase = getPass::getPass(sprintf("Keybase passphrase for [%s]",
#'                                                            salt$email_or_username))) {
#'   message(passphrase)
#'
#'   passphrase_stream <- scrypt::scrypt(passphrase, hex_to_raw(salt$salt),
#'                                       n=215, r=8, p=1, length=256)
#'   pdpka5 <- passphraseStream[224:256]
#'
#'   list(
#'     body = list (
#'       auth = list (
#'         nonce = generate_nonce(),
#'         session = salt$login_session
#'       ),
#'       key = list (
#'         host = "keybase.io",
#'         kid = TODO_KEY_ID,
#'         username = TODO_USERNAME
#'       ),
#'       type = "auth",
#'       version = 1L
#'     ),
#'     ctime = Sys.time(),
#'     expire_in = 157680000,
#'     tag = "signature"
#'   )
#'
#' #   {
#' #   "body": {
#' #     "auth": {
#' #       "nonce": "ab68b24b6bcff3dc6e0cdc558e3e043c",
#' #       "session": "lgG5dGhlbWF4KzhkY2FhNjc4QGdtYWlsLmNvbc5YBShhzQlgwMQgtABibipP7sQIpLv/hO+akJ5mdrD64QkuhY08VdLwtW0="
#' #     },
#' #     "key": {
#' #       "host": "keybase.io",
#' #       "kid": "0120fffa77faf7c189edbb82a942c5feef831335ced44e2fd3155673b023314719070a",
#' #       "username": "u5c7d0817"
#' #     },
#' #     "type": "auth",
#' #     "version": 1
#' #   },
#' #   "ctime": 1476733025,
#' #   "expire_in": 157680000,
#' #   "tag": "signature"
#' # }
#'
#'   # POST("https://keybase.io/_/api/1.0/login.json",
#'   #      body=list(
#'   #        email_or_username = salt$email_or_username,
#'   #        pdpka5 = pdpka5
#'   #      ),
#'   #      verbose()) -> res
#'   #
#'   # httr::stop_for_status(res)
#'   #
#'   # res <- httr::content(res, as="text")
#'   # res <- jsonlite::fromJSON(res)
#'   #
#'   # class(res) <- "kblogin"
#'   # res
#'
#' }