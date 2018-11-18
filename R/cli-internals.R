
#' @importFrom fansi strwrap_ctl

cli__xtext <- function(self, private, ..., .list, .envir, indent) {
  style <- private$get_style()$main
  text <- private$inline(..., .list = .list, .envir = .envir)
  text <- strwrap_ctl(text, width = private$get_width())
  if (!is.null(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text, indent = indent)
  invisible(self)
}

cli__get_width <- function(self, private) {
  style <- private$get_style()$main
  left <- style$`margin-left` %||% 0
  right <- style$`margin-right` %||% 0
  console_width() - left - right
}

cli__cat <- function(self, private, lines) {
  if (private$output == "message") {
    cli__message(lines, appendLF = FALSE)
  }  else {
    cat(lines, sep = "")
  }
  private$margin <- 0
}

cli__cat_ln <- function(self, private, lines, indent) {
  if (!is.null(item <- private$state$delayed_item)) {
    private$state$delayed_item <- NULL
    return(private$item_text(item$type, NULL, item$cnt_id,
                             item$.envir, .list = lines))
  }

  style <- private$get_style()$main

  ## left margin
  left <- style$`margin-left` %||% 0
  if (length(lines) && left) lines <- paste0(strrep(" ", left), lines)

  ## indent or negative indent
  if (length(lines)) {
    if (indent < 0) {
      lines[1] <- dedent(lines[1], - indent)
    } else if (indent > 0) {
      lines[1] <- paste0(strrep(" ", indent), lines[1])
    }
  }

  ## zero out margin
  private$margin <- 0

  bar <- private$get_progress_bar()
  if (is.null(bar)) {
    if (private$output == "message") {
      cli__message(paste0(lines, "\n"), appendLF = FALSE)
    } else {
      cat(paste0(lines, "\n"), sep = "")
    }
  } else {
    bar$message(lines, set_width = FALSE)
  }
}

cli__vspace <- function(self, private, n) {
  if (private$margin < n) {
    sp <- strrep("\n", n - private$margin)
    if (private$output == "message") {
      cli__message(sp, appendLF = FALSE)
    } else {
      cat(sp)
    }
    private$margin <- n
  }
}

cli__message <- function(..., domain = NULL, appendLF = TRUE) {

  msg <- .makeMessage(..., domain = domain, appendLF = appendLF)

  cond <- structure(
    list(message = msg, call = NULL),
    class = c("cliapp_message", "callr_message", "message", "condition"))

  defaultHandler <- function(c) {
    cat(conditionMessage(c), file = stderr(), sep = "")
  }

  withRestarts({
    signalCondition(cond)
    defaultHandler(cond)
  }, muffleMessage = function() NULL)

  invisible()
}
