
`%||%` <- function(l, r) if (is.null(l)) r else l

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}

viapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = integer(1), ..., USE.NAMES = USE.NAMES)
}

vlapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = logical(1), ..., USE.NAMES = USE.NAMES)
}

new_uuid <- (function() {
  cnt <- 0
  function() {
    cnt <<- cnt + 1
    paste0("cli-", cliappenv$pid, "-", cnt)
  }
})()

#' @importFrom utils tail

tail_na <- function(x, n = 1) {
  tail(c(rep(NA, n), x), n)
}

#' @importFrom crayon col_substr

dedent <- function(x, n = 2) {
  first_n_char <- strsplit(col_substr(x, 1, n), "")[[1]]
  n_space <- cumsum(first_n_char == " ")
  d_n_space <- diff(c(0, n_space))
  first_not_space <- head(c(which(d_n_space == 0), n + 1), 1)
  col_substr(x, first_not_space, nchar(x))
}

strrep <- function(x, times) {
  x <- as.character(x)
  if (length(x) == 0L) return(x)
  r <- .mapply(
    function(x, times) {
      if (is.na(x) || is.na(times)) return(NA_character_)
      if (times <= 0L) return("")
      paste0(replicate(times, x), collapse = "")
    },
    list(x = x, times = times),
    MoreArgs = list()
  )

  unlist(r, use.names = FALSE)
}
