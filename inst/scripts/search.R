#! /usr/bin/env Rscript

theme <- list(
  "url" = list(color = "blue"),
  ".pkg" = list(color = "orange"))
app <- cliapp::cliapp$new(theme = theme, output = "stdout")

tryCatch({
  library(httr)
  library(jsonlite)
  library(prettyunits)
  library(docopt) },
  error = function(e) {
    app$alert_danger(
          "The {pkg httr}, {pkg jsonlite}, {pkg prettyunits} and ",
          "{pkg docopt} packages are needed!")
    q(save = "no", status = 1)
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
  query <- make_query(term)
  result <- do_query(query, from = from, size = size)
  format_result(result, from = from, size = size)
  invisible()
}

`%||%` <- function(l, r) if (is.null(l)) r else l

make_query <- function(query) {
  query_object <- list(
    query = list(
      function_score = list(
        query = list(
          multi_match = list(
            fields = c("Package^10", "Title^5", "Description^2",
                       "Author^3", "Maintainer^4", "_all"),
            query = query,
            operator = "and",
            minimum_should_match = "20%"
          )
        ),
        functions = list(
          list(
            script_score = list(
              script = "cran_search_score"
            )
          )
        )
      )
    )
  )

  toJSON(query_object, auto_unbox = TRUE, pretty = TRUE)
}

do_query <- function(query, server, port, index, type, from, size) {
  app$alert_info("Searching...")
  url <- paste0(
    "http://seer.r-pkg.org:9200/cran-devel/package/_search?from=",
    as.character(from - 1), "&size=", as.character(size))
  result <- POST(url, body = query)
  stop_for_status(result)
  content(result, as = "text")
}

format_result <- function(json, from, size) {
  obj <- fromJSON(json, simplifyVector = FALSE)
  if (!obj$hits$total) {
    app$alert_danger("No results :(")
    return()
  }

  app$
    alert_success("Found {obj$hits$total} packages in {pretty_ms(obj$took)}")$
    text()$
    div(theme = list(ul = list("list-style-type" = "")))
  app$ul()

  hits <- obj$hits$hits
  nums <- format(from + seq_len(size) - 1L)
  for (i in seq_along(hits)) format_hit(hits[[i]], nums[i])
}

format_hit <- function(hit, num) {
  src <- hit$`_source`
  date <- as.POSIXct(src$date, origin = "1970-01-01")
  ago <- vague_dt(Sys.time() - date)
  app$it("{num}. {pkg {src$Package}} {src$Version}  --
          {emph {src$Title}}")
  app$par()
  app$text(src$Description)
  app$verbatim("{emph {ago} by {src$Maintainer}}")
}

search(opts$term,
       from = as.numeric(opts$f %||% 1),
       size = as.numeric(opts$n %||% 5))
