
#' CLI text
#'
#' It is wrapped to the screen width automatically. It may contain inline
#' markup. (See [inline-markup].)
#'
#' @param ... The text to show, in character vectors. They will be
#'   concatenated into a single string. Newlines are _not_ preserved.
#' @param .envir Environment to evaluate the glue expressions in.
#' 
#' @export
#' @examples
#' cli_text("Hello world!")
#' cli_text(packageDescription("cliapp")$Description)
#'
#' ## Arguments are concatenated
#' cli_text("this", "that")
#'
#' ## Command substitution
#' greeting <- "Hello"
#' subject <- "world"
#' cli_text("{greeting} {subject}!")
#'
#' ## Inline theming
#' cli_text("The {fun cli_text} function in the {pkg cliapp} package")
#'
#' ## Use within container elements
#' ul <- cli_ul()
#' cli_it()
#' cli_text("{emph First} item")
#' cli_it()
#' cli_text("{emph Second} item")
#' cli_end(ul)

cli_text <- function(..., .envir = parent.frame()) {
  cli__message("text", as.list(glue_cmd(..., .envir = .envir)))
}

#' CLI verbatim text
#'
#' It is not wrapped, but printed as is.
#' 
#' @param ... The text to show, in character vectors. Each element is
#'   printed on a new line.
#' @param .envir Environment to evaluate the glue expressions in.
#' 
#' @export
#' @examples
#' cli_verbatim("This has\nthree", "lines")

cli_verbatim <- function(..., .envir = parent.frame()) {
  cli__message("verbatim", c(list(...), list(.envir = .envir)))
}

#' CLI headers
#'
#' @param text Text of the header. It can contain inline markup.
#' @param id Id of the header element, string. It can be used in themes.
#' @param class Class of the header element,  string. It can be used in
#'   themes.
#' @param .envir Environment to evaluate the glue expressions in.
#' 
#' @export
#' @examples
#' cli_h1("Main title")
#' cli_h2("Subtitle")
#' cli_text("And some regular text....")

cli_h1 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h1", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

#' @rdname cli_h1
#' @export

cli_h2 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h2", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

#' @rdname cli_h1
#' @export

cli_h3 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h3", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

#' Generic CLI container
#'
#' See [containers]. A `cli_div` container is special, because it may
#' add new themes, that are valid within the container.
#'
#' @param id Element id, a string. If `NULL`, then a new id is generated
#'   and returned.
#' @param class Class name, sting. Can be used in themes.
#' @param theme A custom theme for the container. See [themes].
#' @param .auto_close Whether to close the container, when the calling
#'   function finishes (or `.envir` is removed, if specified).
#' @param .envir Environment to evaluate the glue expressions in. It is
#'   also used to auto-close the container if `.auto_close` is `TRUE`.
#' @return The id of the new container element, invisibly.
#' 
#' @export
#' @examples
#' ## div with custom theme
#' d <- cli_div(theme = list(h1 = list(color = "blue",
#'                                     "font-weight" = "bold")))
#' cli_h1("Custom title")
#' cli_end(d)
#'
#' ## Close automatically
#' div <- function() {
#'   cli_div(class = "tmp", theme = list(.tmp = list(color = "yellow")))
#'   cli_text("This is yellow")
#' }
#' div()
#' cli_text("This is not yellow any more")

cli_div <- function(id = NULL, class = NULL, theme = NULL,
                    .auto_close = TRUE, .envir = parent.frame()) {
  cli__message("div", list(id = id, class = class, theme = theme),
               .auto_close = .auto_close, .envir = .envir)
}

#' CLI paragraph
#'
#' See [containers].
#'
#' @param id Element id, a string. If `NULL`, then a new id is generated
#'   and returned.
#' @param class Class name, sting. Can be used in themes.
#' @inheritParams cli_div
#' @return The id of the new container element, invisibly.
#' 
#' @export
#' @examples
#' id <- cli_par()
#' cli_text("First paragraph")
#' cli_end(id)
#' id <- cli_par()
#' cli_text("Second paragraph")
#' cli_end(id)

cli_par <- function(id = NULL, class = NULL, .auto_close = TRUE,
                    .envir = parent.frame()) {
  cli__message("par", list(id = id, class = class),
               .auto_close = .auto_close, .envir = .envir)
}

#' Close a CLI container
#'
#' @param id Id of the container to close. If missing, the current
#' container is closed, if any.
#' 
#' @export
#' @examples
#' ## If id is omitted
#' cli_par()
#' cli_text("First paragraph")
#' cli_end()
#' cli_par()
#' cli_text("Second paragraph")
#' cli_end()

cli_end <- function(id = NULL) {
  cli__message("end", list(id = id %||% NA_character_))
}

#' Unordered CLI list
#'
#' An unordered list is a container, see [containers].
#'
#' @param items If not `NULL`, then a character vector. Each element of
#'   the vector will be one list item, and the list container will be
#'   closed by default (see the `.close` argument).
#' @param id Id of the list container. Can be used for closing it with
#'   [cli_end()] or in themes. If `NULL`, then an id is generated and
#'   retuned invisibly.
#' @param class Class of the list container. Can be used in themes.
#' @param .close Whether to close the list container if the `items` were
#'   specified. If `FALSE` then new items can be added to the list.
#' @inheritParams cli_div
#' @return The id of the new container element, invisibly.
#' 
#' @export
#' @examples
#' ## Specifying the items at the beginning
#' cli_ul(c("one", "two", "three"))
#'
#' ## Adding items one by one
#' cli_ul()
#' cli_it("one")
#' cli_it("two")
#' cli_it("three")
#' cli_end()
#'
#' ## Complex item, added gradually.
#' cli_ul()
#' cli_it()
#' cli_verbatim("Beginning of the {emph first} item")
#' cli_text("Still the first item")
#' cli_end()
#' cli_it("Second item")
#' cli_end()

cli_ul <- function(items = NULL, id = NULL, class = NULL,
                   .close = TRUE, .auto_close = TRUE,
                   .envir = parent.frame()) {
  cli__message(
    "ul",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class, .close = .close),
    .auto_close = .auto_close, .envir = .envir)
}

#' Ordered CLI list
#'
#' An ordered list is a container, see [containers].
#'
#' @inheritParams cli_ul
#' @return The id of the new container element, invisibly.
#' 
#' @export
#' @examples
#' ## Specifying the items at the beginning
#' cli_ol(c("one", "two", "three"))
#' 
#' ## Adding items one by one
#' cli_ol()
#' cli_it("one")
#' cli_it("two")
#' cli_it("three")
#' cli_end()
#'
#' ## Nested lists
#' cli_div(theme = list(ol = list("margin-left" = 2)))
#' cli_ul()
#' cli_it("one")
#' cli_ol(c("foo", "bar", "foobar"))
#' cli_it("two")
#' cli_end()
#' cli_end()

cli_ol <- function(items = NULL, id = NULL, class = NULL,
                   .close = TRUE, .auto_close = TRUE,
                   .envir = parent.frame()) {
  cli__message(
    "ol",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class, .close = .close),
    .auto_close = .auto_close, .envir = .envir)
}

#' Definition list
#' 
#' A definition list is a container, see [containers].
#'
#' @param items Named character vector, or `NULL`. If not `NULL`, they
#'   are used as list items.
#' @inheritParams cli_ul
#' @return The id of the new container element, invisibly.
#' 
#' @export
#' @examples
#' ## Specifying the items at the beginning
#' cli_dl(c(foo = "one", bar = "two", baz = "three"))
#' 
#' ## Adding items one by one
#' cli_dl()
#' cli_it(c(foo = "one"))
#' cli_it(c(bar = "two"))
#' cli_it(c(baz = "three"))
#' cli_end()

cli_dl <- function(items = NULL, id = NULL, class = NULL,
                   .close = TRUE, .auto_close = TRUE,
                   .envir = parent.frame()) {
  cli__message(
    "dl",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class, .close = .close),
    .auto_close = .auto_close, .envir = .envir)
}

#' CLI list item(s)
#'
#' A list item is a container, see [containers].
#'
#' @param items Character vector of items, or `NULL`.
#' @param id Id of the new container. Can be used for closing it with
#'   [cli_end()] or in themes. If `NULL`, then an id is generated and
#'   retuned invisibly.
#' @param class Class of the item container. Can be used in themes.
#' @inheritParams cli_div
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' ## Adding items one by one
#' cli_ul()
#' cli_it("one")
#' cli_it("two")
#' cli_it("three")
#' cli_end()
#'
#' ## Complex item, added gradually.
#' cli_ul()
#' cli_it()
#' cli_verbatim("Beginning of the {emph first} item")
#' cli_text("Still the first item")
#' cli_end()
#' cli_it("Second item")
#' cli_end()

cli_it <- function(items = NULL, id = NULL, class = NULL,
                   .auto_close = TRUE, .envir = parent.frame()) {
  cli__message(
    "it",
    list(
      items = vcapply(items, glue_cmd, .envir = .envir), id = id,
      class = class),
    .auto_close = .auto_close, .envir = .envir)
}

#' CLI alerts
#'
#' Alerts are typically short status messages.
#'
#' @param text Text of the alert.
#' @param id Id of the alert element. Can be used in themes.
#' @param class Class of the alert element. Can be used in themes.
#' @param wrap Whether to auto-wrap the text of the alert.
#' @param .envir Environment to evaluate the glue expressions in.
#' 
#' @export
#' @examples
#'
#' cli_alert("Cannot lock package library.")
#' cli_alert_success("Package {pkg cliapp} installed successfully.")
#' cli_alert_danger("Could not download {pkg cliapp}.")
#' cli_alert_warning("Internet seems to be unreacheable.")
#' cli_alert_info("Downloaded 1.45MiB of data")

cli_alert <- function(text, id = NULL, class = NULL, wrap = FALSE,
                       .envir = parent.frame()) {
  cli__message("alert", list(text = glue_cmd(text, .envir = .envir), id = id,
                             class = class, wrap = wrap))
}

#' @rdname cli_alert
#' @export

cli_alert_success <- function(text, id = NULL, class = NULL, wrap = FALSE,
                              .envir = parent.frame()) {
  cli__message("alert_success", list(text = glue_cmd(text, .envir = .envir),
                                     id = id, class = class, wrap = wrap))
}

#' @rdname cli_alert
#' @export

cli_alert_danger <- function(text, id = NULL, class = NULL, wrap = FALSE,
                              .envir = parent.frame()) {
  cli__message("alert_danger", list(text = glue_cmd(text, .envir = .envir),
                                    id = id, class = class, wrap = wrap))
}

#' @rdname cli_alert
#' @export

cli_alert_warning <- function(text, id = NULL, class = NULL, wrap = FALSE,
                               .envir = parent.frame()) {
  cli__message("alert_warning", list(text = glue_cmd(text, .envir = .envir),
                                     id = id, class = class, wrap = wrap))
}

#' @rdname cli_alert
#' @export

cli_alert_info <- function(text, id = NULL, class = NULL, wrap = FALSE,
                            .envir = parent.frame()) {
  cli__message("alert_info", list(text = glue_cmd(text, .envir = .envir),
                                  id = id, class = class, wrap = wrap))
}

#' CLI progress bar
#'
#' A progress bar using the progress package
#'
#' @param ... All arguments are passed to the constuctor of the
#' [progress::progress_bar] class.
#' @return A remote progress bar object that can be used the same way
#' as [progress::progress_bar], see examples below.
#' 
#' @export
#' @examplesIf !cliapp:::is_cran_check()
#' {
#'   p <- cli_progress_bar(total = 10)
#'   cli_alert_info("Starting computation")
#'   for (i in 1:10) { p$tick(); Sys.sleep(0.2) }
#'   cli_alert_success("Done")
#' }

cli_progress_bar <- function(...) {
  id <- cli__message("progress_bar", list(id = NULL, ...))
  cli__remote_progress_bar(id)
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
