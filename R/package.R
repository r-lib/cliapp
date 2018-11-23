
#' Create Rich Command Line Applications
#'
#' Create rich command line applications, with colors, headings, lists,
#' alerts, progress bars, etc. It uses CSS for theming.
#'
#' See [themes] for theming, [containers] for container elements,
#' [inline-markup] for more about command substitution and inline markup.
#'
#' See also the various CLI elements:
#' * Text elements: [cli_text()], [cli_verbatim()], [cli_h1()].
#' * Containers: [cli_div()], [cli_par()], [cli_end()].
#' * Lists: [cli_ul()], [cli_ol()], [cli_dl()], [cli_it()].
#' * Alerts: [cli_alert()].
#' * Progress bars: [cli_progress_bar()].
#' 
#' @docType package
#' @name cliapp
"_PACKAGE"

cliappenv <- new.env()
cliappenv$stack <- list()
cliappenv$pid <- Sys.getpid()

.onLoad <- function(libname, pkgname) {
  if (is.null(getOption("callr.condition_handler_cliapp_message"))) {
    options(callr.condition_handler_cliapp_message = cli__default_handler)
  }
}

#' Start, stop, query the default cli application
#'
#' `start_app` creates an app, and places it on the top of the app stack.
#'
#' `stop_app` removes the top app, or multiple apps from the app stack.
#'
#' `default_app` returns the default app, the one on the top of the stack.
#'
#' @param theme Theme to use, passed to the [cliapp] initializer.
#' @param output How to print the output, passed to [cliapp] initializer.
#' @param .auto_close Whether to stop the app, when the calling frame
#'   is destroyed.
#' @param .envir The environment to use, instead of the calling frame,
#'   to trigger the stop of the app.
#' @param app App to stop. If `NULL`, the current default app is stopped.
#'   Otherwise we find the supplied app in the app stack, and remote it,
#'   together with all the apps above it.
#' @return
#'   `start_app` returns the new app, `default_app` returns the default app.
#'   `stop_app` does not return anything.
#'
#' @export

start_app <- function(theme = getOption("cli.theme"),
                      output = c("message", "stdout"), .auto_close = TRUE,
                      .envir = parent.frame()) {

  app <- cliapp$new(
    theme = theme,
    user_theme = getOption("cli.user_theme"),
    output = match.arg(output))
  cliappenv$stack[[length(cliappenv$stack) + 1]] <- app

  if (.auto_close && !identical(.envir, globalenv())) {
    defer(stop_app(app = app), envir = .envir, priority = "first")
  }

  invisible(app)
}

#' @export
#' @importFrom utils head
#' @name start_app

stop_app <- function(app = NULL) {
  if (is.null(app)) {
    cliappenv$stack <- head(cliappenv$stack, -1)

  } else {
    if (!inherits(app, "cliapp")) stop("Not a CLI app")
    ndl <- format.default(app)
    nms <- vapply(cliappenv$stack, format.default, character(1))
    if (! ndl %in% app) {
      warning("No app to end")
      return()
    }
    wh <- which(nms == ndl)[1]
    cliappenv$stack <- head(cliappenv$stack, wh - 1)
  }

  invisible()
}

#' @export
#' @importFrom utils tail
#' @name start_app

default_app <- function() {
  top <- tail(cliappenv$stack, 1)
  if (length(top)) top[[1]] else NULL
}
