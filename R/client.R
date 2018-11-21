
cli_text <- function(..., .envir = parent.frame()) {
  cli__message("text", as.list(glue_cmd(..., .envir = .envir)))
}

cli_verbatim <- function(..., .envir = parent.frame()) {
  cli__message("verbatim", as.list(glue_cmd(..., .envir = .envir)))
}

cli_h1 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h1", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

cli_h2 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h2", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

cli_h3 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h3", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

cli_div <- function(id = NULL, class = NULL, theme = NULL,
                    .auto_close = TRUE, .envir = parent.frame()) {
  cli__message("div", list(id = id, class = class, theme = theme),
               .auto_close = .auto_close, .envir = .envir)
}

cli_par <- function(id = NULL, class = NULL, .auto_close = TRUE,
                    .envir = parent.frame()) {
  cli__message("par", list(id = id, class = class),
               .auto_close = .auto_close, .envir = .envir)
}

cli_end <- function(id = NULL) {
  cli__message("end", list(id = id %||% NA_character_))
}

cli_ul <- function(items = NULL, id = NULL, class = NULL,
                   .auto_close = TRUE, .envir = parent.frame()) {
  cli__message(
    "ul",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class),
    .auto_close = .auto_close, .envir = .envir)
}

cli_ol <- function(items = NULL, id = NULL, class = NULL,
                   .auto_close = TRUE, .envir = parent.frame()) {
  cli__message(
    "ol",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class),
    .auto_close = .auto_close, .envir = .envir)
}

cli_dl <- function(items = NULL, id = NULL, class = NULL,
                   .auto_close = TRUE, .envir = parent.frame()) {
  cli__message(
    "dl",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class),
    .auto_close = .auto_close, .envir = .envir)
}

cli_it <- function(items = NULL, id = NULL, class = NULL,
                   .auto_close = TRUE, .envir = parent.frame()) {
  cli__message(
    "it",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class),
    .auto_close = .auto_close, .envir = .envir)
}


cli_alert <- function(text, id = NULL, class = NULL, wrap = FALSE,
                       .envir = parent.frame()) {
  cli__message("alert", list(text = glue_cmd(text, .envir = .envir), id = id,
                             class = class, wrap = wrap))
}

cli_alert_success <- function(text, id = NULL, class = NULL, wrap = FALSE,
       .envir = parent.frame()) {
  cli__message("alert_success", list(text = glue_cmd(text, .envir = .envir),
                                     id = id, class = class, wrap = wrap))
}

cli_alert_danger <- function(text, id = NULL, class = NULL, wrap = FALSE,
                              .envir = parent.frame()) {
  cli__message("alert_danger", list(text = glue_cmd(text, .envir = .envir),
                                    id = id, class = class, wrap = wrap))
}

cli_alert_warning <- function(text, id = NULL, class = NULL, wrap = FALSE,
                               .envir = parent.frame()) {
  cli__message("alert_warning", list(text = glue_cmd(text, .envir = .envir),
                                     id = id, class = class, wrap = wrap))
}

cli_alert_info <- function(text, id = NULL, class = NULL, wrap = FALSE,
                            .envir = parent.frame()) {
  cli__message("alert_info", list(text = glue_cmd(text, .envir = .envir),
                                  id = id, class = class, wrap = wrap))
}

cli_progress_bar <- function(...) {
  id <- cli__message("progress_bar", list(id = NULL, ...))
  cli__remote_progress_bar(id)
}

cli_reset <- function() {
  cli__message("reset", list())
}

cli__message <- function(type, args, .auto_close = TRUE, .envir = NULL) {

  if ("id" %in% names(args) && is.null(args$id)) args$id <- new_uuid()

  if (.auto_close && !is.null(.envir) && !identical(.envir, .GlobalEnv)) {
    defer(cli_end(id = args$id), envir = .envir, priority = "first")
  }

  cond <- list(message = paste("cli message", type),
               type = type, args = args, pid = cliappenv$pid)
  class(cond) <- c("cliapp_message", "callr_message", "condition")

  withRestarts({
    signalCondition(cond)
    cli__default_handler(cond)
  }, muffleMessage = function() NULL)

  invisible(args$id)
}

cli__default_handler <- function(msg) {
  custom_handler <- getOption("cli.default_handler")

  if (is.function(custom_handler)) {
    custom_handler(msg)
  } else {
    cli_server_default(msg)
  }
}
