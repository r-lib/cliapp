
#' CLI inline markup
#'
#' @section Command substitution:
#'
#' All text emitted by cliapp supports glue interpolation. Expressions
#' enclosed by braces will be evaluated as R code. See [glue::glue()] for
#' details.
#'
#' In addition to regular glue interpolation, cliapp can also add classes
#' to parts of the text, and these classes can be used in themes. For
#' example
#' 
#' ```
#' cli_text("This is {emph important}.")
#' ```
#' 
#' adds a class to the "important" word, class "emph". Note that in this
#' cases the string within the braces is not a valid R expression. If you
#' want to mix classes with interpolation, add another pair of braces:
#' 
#' ```
#' adjective <- "great"
#' cli_text("This is {emph {adjective}}.")
#' ```
#'
#' An inline class will always create a `span` element internally. So in
#' themes, you can use the `span.emph` CSS selector to change how inline
#' text is emphasized:
#' 
#' ```
#' cli_div(theme = list(span.emph = list(color = "red")))
#' adjective <- "nice and red"
#' cli_text("This is {emph {adjective}}.")
#' ```
#'
#' @section Classes:
#'
#' The default theme defines the following inline classes:
#' * `emph` for emphasized text.
#' * `strong` for strong importance.
#' * `code` for a piece of code.
#' * `pkg` for a package name.
#' * `fun` for a function name.
#' * `arg` for a function argument.
#' * `key` for a keyboard key.
#' * `file` for a file name.
#' * `path` for a path (essentially the same as `file`).
#' * `email` for an email address.
#' * `url` for a URL.
#' * `var` for a variable name.
#' * `envvar` for the name of an environment variable.
#'
#' See examples below.
#'
#' You can simply add new classes by defining them in the theme, and then
#' using them, see the example below.
#'
#' @name inline-markup
#' @examples
#' ## Some inline markup examples
#' cli_ul()
#' cli_it("{emph Emphasized} text")
#' cli_it("{strong Strong} importance")
#' cli_it("A piece of code: {code sum(a) / length(a)}")
#' cli_it("A package name: {pkg cliapp}")
#' cli_it("A function name: {fun cli_text}")
#' cli_it("A function argument: {arg text}")
#' cli_it("A keyboard key: press {key ENTER}")
#' cli_it("A file name: {file /usr/bin/env}")
#' cli_it("An email address: {email bugs.bunny@acme.com}")
#' cli_it("A URL: {url https://acme.com}")
#' cli_it("A variable name: {var mtcars}")
#' cli_it("An environment variable: {envvar R_LIBS}")
#' cli_end()
#'
#' ## Adding a new class
#' cli_div(theme = list(
#'   span.myclass = list(color = "lightgrey"),
#'   "span.myclass::before" = list(content = "["),
#'   "span.myclass::after" = list(content = "]")))
#' cli_text("This is {myclass in brackets}.")
#' cli_end()
NULL

#' CLI containers
#'
#' Container elements may contain other elements. Currently the following
#' commands create container elements: [cli_div()], [cli_par()], the list
#' elements: [cli_ul()], [cli_ol()], [cli_dl()], and list items are
#' containers as well: [cli_it()].
#'
#' Container elements need to be closed with [cli_end()]. For convenience,
#' they are have an `.auto_close` argument, which allows automatically
#' closing a container element, when the function that created it
#' terminates (either regularly, or with an error).
#'
#' @name containers
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
NULL

#' CLI themes
#'
#' TODO
#' @name themes
NULL
