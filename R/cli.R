
#' @importFrom R6 R6Class

cliapp <- R6Class(
  "cliapp",
  public = list(
    initialize = function(theme = getOption("cli.theme"),
                          user_theme = getOption("cli.user_theme"),
                          output = c("message", "stdout"))
      clii_init(self, private, theme, user_theme, match.arg(output)),

    ## Themes
    list_themes = function()
      clii_list_themes(self, private),
    add_theme = function(theme)
      clii_add_theme(self, private, theme),
    remove_theme = function(id)
      clii_remove_theme(self, private, id),

    ## Close container(s)
    end = function(id)
      clii_end(self, private, id),

    ## Generic container
    div = function(id, class = NULL, theme = NULL)
      clii_div(self, private, id, class, theme),

    ## Paragraphs
    par = function(id, class = NULL)
      clii_par(self, private, id, class),

    ## Text, wrapped
    text = function(...)
      clii_text(self, private, ...),

    ## Text, not wrapped
    verbatim = function(...)
      clii_verbatim(self, private, ...),

    ## Markdow(ish) text, wrapped: emphasis, strong emphasis, links, code
    md_text = function(...)
      clii_md_text(self, private, ...),

    ## Headers
    h1 = function(text, id, class = NULL)
      clii_h1(self, private, text, id, class),
    h2 = function(text, id, class = NULL)
      clii_h2(self, private, text, id, class),
    h3 = function(text, id, class = NULL)
      clii_h3(self, private, text, id, class),

    ## Block quote
    blockquote = function(quote, citation = NULL, id, class = NULL)
      clii_blockquote(self, private, quote, citation, id, class),

    ## Lists
    ul = function(items = NULL, id = NULL, class = NULL, .close = TRUE)
      clii_ul(self, private, items, id, class, .close),
    ol = function(items = NULL, id, class = NULL, .close = TRUE)
      clii_ol(self, private, items, id, class, .close),
    dl = function(items = NULL, id, class = NULL, .close = TRUE)
      clii_dl(self, private, items, id, class, .close),
    it = function(items = NULL, id = NULL, class = NULL)
      clii_it(self, private, items, id, class),

    ## Code
    code = function(lines, id, class = NULL)
      clii_code(self, private, lines, class),

    ## Tables
    table = function(cells, id, class = NULL)
      clii_table(self, private, cells, class),

    ## Alerts
    alert = function(text, id, class = NULL, wrap = FALSE)
      clii_alert(self, private, "alert", text, id, class, wrap),
    alert_success = function(text, id, class = NULL, wrap = FALSE)
      clii_alert(self, private, "alert-success", text, id, class, wrap),
    alert_danger = function(text, id, class = NULL, wrap = FALSE)
      clii_alert(self, private, "alert-danger", text, id, class, wrap),
    alert_warning = function(text, id, class = NULL, wrap = FALSE)
      clii_alert(self, private, "alert-warning", text, id, class, wrap),
    alert_info = function(text, id, class = NULL, wrap = FALSE)
      clii_alert(self, private, "alert-info", text, id, class, wrap),

    ## Progress bars
    progress_bar = function(id, ...)
      clii_progress_bar(self, private, id, ...),
    progress = function(id, operation, ...)
      clii_progress(self, private, id, operation, ...)
  ),

  private = list(
    raw_themes = NULL,
    theme = NULL,
    margin = 0,
    state = NULL,
    output = NULL,

    get_matching_styles = function()
      tail(private$state$matching_styles, 1)[[1]],
    get_style = function()
      tail(private$state$styles, 1)[[1]],

    xtext = function(..., .list = NULL, indent = 0)
      clii__xtext(self, private, ..., .list = .list, indent = indent),

    vspace = function(n = 1)
      clii__vspace(self, private, n),

    inline = function(..., .list = NULL)
      clii__inline(self, private, ..., .list = .list),

    item_text = function(type, name, cnt_id, ..., .list = NULL)
      clii__item_text(self, private, type, name, cnt_id, ..., .list = .list),

    get_width = function()
      clii__get_width(self, private),
    cat = function(lines)
      clii__cat(self, private, lines),
    cat_ln = function(lines, indent = 0)
      clii__cat_ln(self, private, lines, indent),

    match_theme = function(element_path)
      clii__match_theme(self, private, element_path),

    progress_bars = list(),
    get_progress_bar = function()
      clii__get_progress_bar(self, private),
    cleanup_progress_bars = function()
      clii__cleanup_progress_bars(self, private)
  )
)

#' @importFrom xml2 read_html xml_find_first

clii_init <- function(self, private, theme, user_theme, output) {
  private$output <- output
  private$raw_themes <- list(
    default = builtin_theme(), optional = theme)
  private$theme <- theme_create(private$raw_themes)
  private$state <-
    list(doc = read_html("<html><body id=\"body\"></body></html>"))
  private$state$current <- xml_find_first(private$state$doc, "./body")

  private$state$matching_styles <-
    list(body = private$match_theme("./body"))
  root_styles <- private$theme[private$state$matching_styles[[1]], ]
  root_style <- list(main = list(), before = list(), after = list())
  for (i in seq_len(nrow(root_styles))) {
    root_style <- merge_styles(root_style, root_styles[i,])
  }
  private$state$styles <- list(body = root_style)

  private$state$xstyles <- character()

  self$add_theme(user_theme)

  invisible(self)
}

## Text -------------------------------------------------------------

#' @importFrom fansi strwrap_ctl

clii_text <- function(self, private, ...) {
  private$xtext(...)
}

clii_verbatim <- function(self, private, ..., .envir) {
  style <- private$get_style()$main
  text <- paste(unlist(list(...), use.names = FALSE), collapse = "\n")
  if (!is.null(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  invisible(self)
}

clii_md_text <- function(self, private, ...) {
  stop("Markdown text is not implemented yet")
}

## Headers ----------------------------------------------------------

clii_h1 <- function(self, private, text, id, class) {
  clii__header(self, private, "h1", text, id, class)
}

clii_h2 <- function(self, private, text, id, class) {
  clii__header(self, private, "h2", text, id, class)
}

clii_h3 <- function(self, private, text, id, class) {
  clii__header(self, private, "h3", text, id, class)
}

clii__header <- function(self, private, type, text, id, class) {
  id <- new_uuid()
  clii__container_start(self, private, type, id = id, class = class)
  on.exit(clii__container_end(self, private, id), add = TRUE)
  text <- private$inline(text)
  style <- private$get_style()$main
  if (is.function(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  invisible(self)
}

## Block quote ------------------------------------------------------

clii_blockquote <- function(self, private, quote, citation, id, class) {
  stop("Quotes are not implemented yet")
}

## Table ------------------------------------------------------------

clii_table <- function(self, private, cells, id, class) {
  stop("Tables are not implemented yet")
}

## Alerts -----------------------------------------------------------

clii_alert <- function(self, private, type, text, id, class, wrap) {
  clii__container_start(self, private, "div", id = id,
                       class = paste(class, "alert", type))
  on.exit(clii__container_end(self, private, id), add = TRUE)
  text <- private$inline(text)
  style <- private$get_style()
  text[1] <- paste0(style$before$content, text[1])
  text[length(text)] <- paste0(text[length(text)], style$after$content)
  if (is.function(style$main$fmt)) text <- style$main$fmt(text)
  if (wrap) text <- strwrap_ctl(text, exdent = 2)
  private$cat_ln(text)
  invisible(self)
}
