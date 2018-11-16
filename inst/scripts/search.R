#! /usr/bin/env Rscript

theme <- list(
  "url" = list(color = "blue"),
  ".pkg" = list(color = "orange"))
app <- cliapp::cliapp$new(theme = theme, output = "stdout")

tryCatch({
  library(pkgsearch)
  library(docopt)
  library(prettyunits)
  error = function(e) {
    app$alert_danger(
          "The {pkg pkgsearch}, {pkg prettyunits} and {pkg docopt} packages are needed!")
    q(save = "no", status = 1)
  }
})

"Usage:
  cransearch.R [-h | --help] [ -f from ] [ -n size ] <term>...

Options:
  -h --help  Print this help message
  -f first   First hit to include
  -n size    Number of hits to include

Seach for CRAN packages on r-pkg.org
" -> doc

opts <- docopt(doc)

search <- function(terms, from = 1, size = 5) {
  term <- paste(encodeString(quote = '"', terms), collapse = " ")
  result <- do_query(term, from = from, size = size)
  format_result(result, from = from, size = size)
  invisible()
}

`%||%` <- function(l, r) if (is.null(l)) r else l

do_query <- function(query, from, size) {
  app$alert_info("Searching...")
  pkg_search(query, from = from, size = size)
}

format_result <- function(obj, from, size) {
  meta <- attr(obj, "metadata")
  if (!meta$total) {
    app$alert_danger("No results :(")
    return()
  }

  app$
    alert_success("Found {meta$total} packages in {pretty_ms(meta$took)}")$
    text()$
    div(theme = list(ul = list("list-style-type" = "")))
  app$ul()

  nums <- format(from + seq_len(size) - 1L)
  for (i in seq_len(nrow(obj))) format_hit(obj[i, ], nums[i])
}

format_hit <- function(hit, num) {
  ago <- vague_dt(Sys.time() - hit$date)
  app$it("{num}. {pkg {hit$package}} {hit$version}  --
          {emph {hit$title}}")
  app$par()
  app$text(hit$description)
  app$verbatim("{emph {ago} by {hit$maintainer_name}}")
}

search(opts$term,
       from = as.numeric(opts$f %||% 1),
       size = as.numeric(opts$n %||% 5))
