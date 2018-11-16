#! /usr/bin/env Rscript

## To get the async package:
## source("https://install-github.me/r-lib/async")

theme <- list("url" = list(color = "blue"))
app <- cliapp::cliapp$new(theme = theme, output = "stdout")

tryCatch({
  library(async)
  library(docopt) },
  error = function(e) {
    app$alert_danger("The {pkg async} and {pkg docopt} packages are needed!")
    q(save = "no", status = 1)
  })

"Usage:
  up.R [-t timeout] [URLS ...]
  up.R -h | --help

Options:
  -t timeout   Timeout for giving up on a site, in seconds [default: 5].
  -h --help    Print this help message

Check is web site(s) are up.
" -> doc

opts <- docopt(doc)

up <- function(urls, timeout) {
  chk_url <- async(function(url, ...) {
    http_head(url, ...)$
      then(function(res) {
        if (res$status_code < 300) {
          app$alert_success("{url {url}} ({res$times[['total']]}s)")
        } else {
          app$alert_danger("{url {url}} (HTTP {res$status_code})")
        }
      })$
      catch(error = function(err) {
        e <- if (grepl("timed out", err$message)) "timed out" else "error"
        app$alert_danger("{url {url}} ({e})")
      })
  })

  invisible(synchronise(
    async_map(urls, chk_url, options = list(timeout = timeout))
  ))
}

up(opts$URLS, timeout = as.numeric(opts$t))
