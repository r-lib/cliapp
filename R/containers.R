
#' @importFrom withr defer
#' @importFrom xml2 xml_add_child
#' @importFrom glue glue

clii__container_start <- function(self, private, tag, class = NULL,
                                  id = NULL) {
  id <- id %||% new_uuid()

  if (is.null(class)) {
    private$state$current <- xml_add_child(
      private$state$current, tag, id = id)
  } else {
    private$state$current <- xml_add_child(
      private$state$current, tag, id = id, class = class)
  }

  matching_styles <- private$match_theme(
    glue("descendant-or-self::*[@id = '{id}']"))
  new_styles <- private$theme[
    setdiff(matching_styles, private$get_matching_styles()), ]
  private$state$matching_styles <-
    c(private$state$matching_styles,
      structure(list(matching_styles), names = id))

  new_style <- list(main = list(), before = list(), after = list())
  for (i in seq_len(nrow(new_styles))) {
    new_style <- merge_styles(new_style, new_styles[i, ])
  }
  new_style <- merge_embedded_styles(private$get_style(), new_style)
  private$state$styles <-
    c(private$state$styles, structure(list(new_style), names = id))

  ## Top margin, if any
  private$vspace(new_style$main$`margin-top` %||% 0)

  invisible(id)
}

#' @importFrom xml2 xml_find_first xml_name xml_remove xml_parent
#'   xml_attr
#' @importFrom utils head
#' @importFrom stats na.omit

clii__container_end <- function(self, private, id) {
  ## Do not remove the <body>
  if (xml_name(private$state$current) == "body") return(invisible(self))

  ## Defaults to last container
  if (is.null(id) || is.na(id)) {
    id <- xml_attr(private$state$current, "id")
  }

  ## Do we have 'id' at all?
  cnt <- xml_find_first(
    private$state$doc,
    glue("descendant-or-self::*[@id = '{id}']"))
  if (is.na(xml_name(cnt))) return(invisible(self))

  ## Remove the whole subtree of 'cnt', pointer is on its parent
  private$state$current <- xml_parent(cnt)
  xml_remove(cnt, free = TRUE)
  rm(cnt)

  ## Bottom margin
  del_from <- match(id, names(private$state$matching_styles) %||% character())
  bottom <- max(viapply(
    private$state$styles[del_from:length(private$state$styles)],
    function(x) as.integer(x$main$`margin-bottom` %||% 0L)
  ))
  private$vspace(bottom)

  ## Remove styles as well
  deleted_styles <- tail(names(private$state$matching_styles),
                         -(del_from - 1))
  private$state$matching_styles <-
    head(private$state$matching_styles, del_from - 1)
  private$state$styles <-
    head(private$state$styles, del_from - 1)

  ## Styles that are to be removed when the container ends
  xstyles <- na.omit(private$state$xstyles[deleted_styles])
  if (length(xstyles)) {
    private$raw_themes[xstyles] <- NULL
    private$theme <- theme_create(private$raw_themes)
    private$state$xstyles <- setdiff(private$state$xstyles, xstyles)
  }

  invisible(self)
}

## div --------------------------------------------------------------

clii_div <- function(self, private, id, class, theme) {
  theme_id <- self$add_theme(theme)
  clii__container_start(self, private, "div", class, id)
  private$state$xstyles <-
    c(private$state$xstyles, structure(theme_id, names = id))

  id
}

## Paragraph --------------------------------------------------------

clii_par <- function(self, private, id, class) {
  clii__container_start(self, private, "par", class, id)
}

## Lists ------------------------------------------------------------

clii_ul <- function(self, private, items, id, class, .close) {
  id <- clii__container_start(self, private, "ul", id = id, class = class)
  if (length(items)) { self$it(items); if (.close) self$end(id) }
  invisible(id)
}

clii_ol <- function(self, private, items, id, class, .close) {
  id <- clii__container_start(self, private, "ol", id = id, class = class)
  if (length(items)) { self$it(items); if (.close) self$end(id) }
  invisible(id)
}

clii_dl <- function(self, private, items, id, class, .close) {
  id <- clii__container_start(self, private, "dl", id = id, class = class)
  if (length(items)) { self$it(items); if (.close) self$end(id) }
  invisible(id)
}

#' @importFrom xml2 xml_parent xml_path xml_attr

clii_it <- function(self, private, items, id, class) {

  id <- id %||% new_uuid()

  ## check the last active list container
  last <- private$state$current
  while (! xml_name(last) %in% c("ul", "ol", "dl", "body")) {
    prev <- last
    last <- xml_parent(last)
  }

  ## if not the last container, close the ones below it
  if (xml_name(last) != "body" &&
      xml_path(last) != xml_path(private$state$current)) {
    self$end(xml_attr(prev, "id"))
  }

  ## if none, then create an ul container
  if (xml_name(last) == "body") {
    cnt_id <- self$ul()
    type <- "ul"
  } else {
    cnt_id <- xml_attr(last, "id")
    type <- xml_name(last)
  }

  if (length(items) > 0) {
    for (i in seq_along(items)) {
      id <- clii__container_start(self, private, "it", id = id, class = class)
      private$item_text(type, names(items)[i], cnt_id, items[[i]])
      if (i < length(items)) self$end(id)
    }
  } else {
    private$state$delayed_item <- list(type = type, cnt_id = cnt_id)
    id <- clii__container_start(self, private, "it", id = id, class = class)
  }

  invisible(id)
}

clii__item_text <- function(self, private, type, name, cnt_id, ..., .list) {

  style <- private$get_style()$main
  head <- if (type == "ul") {
    paste0(style$`list-style-type` %||% "*", " ")
  } else if (type == "ol") {
    res <- paste0(private$state$styles[[cnt_id]]$main$start %||% 1L, ". ")
    private$state$styles[[cnt_id]]$main$start <-
      (private$state$styles[[cnt_id]]$main$start %||% 1L) + 1L
    res
  } else if (type == "dl") {
    paste0(name, ": ")
  }
  private$xtext(.list = c(list(head), list(...), .list), indent = -2)
}

## Code -------------------------------------------------------------

clii_code <- function(self, private, lines, id, class) {
  stop("Code is not implemented yet")
}

## Close container(s) -----------------------------------------------

clii_end <- function(self, private, id) {
  clii__container_end(self, private, id)
}
