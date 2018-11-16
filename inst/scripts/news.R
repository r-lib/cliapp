#! /usr/bin/env Rscript

theme <- list(
  "url" = list(color = "blue"),
  ".pkg" = list(color = "orange"),
  "it" = list("margin-bottom" = 1))
app <- cliapp::cliapp$new(theme = theme, output = "stdout")

tryCatch({
  library(httr)
  library(jsonlite)
  library(prettyunits)
  library(glue)
  library(parsedate)
  library(docopt) },
  error = function(e) {
    app$alert_danger(
          "The {pkg glue}, {pkg httr}, {pkg jsonlite}, {pkg prettyunits},",
          " {pkg parsedate} and {pkg docopt} packages are needed!")
    q(save = "no", status = 1)
  })

"Usage:
  news.R [-r | --reverse] [-n num ]
  news.R [-r | --reverse] --day | --week | --since date
  news.R [-h | --help]

Options:
  -n num        Show the last 'n' releases [default: 10].
  --day         Show releases in the last 24 hours
  --week        Show relaases in the last 7 * 24 hours
  --since date  Show releases since 'date'
  -r --reverse  Reverse the order, show older on top
  -h --help     Print this help message

New package releases on CRAN
" -> doc

opts <- docopt(doc)

news <- function(n, day, week, since, reverse) {

  result <- if (day)
    news_day()
  else if (week)
    news_week()
  else if (!is.null(since))
    news_since(since)
  else
    news_n(as.numeric(n))

  if (reverse) result <- rev(result)

  format_results(result)
  invisible()
}

news_day <- function() {
  date <- format_iso_8601(Sys.time() - as.difftime(1, units="days"))
  ep <- glue("/-/pkgreleases?descending=true&endkey=%22{date}%22")
  do_query(ep)
}

news_week <- function() {
  date <- format_iso_8601(Sys.time() - as.difftime(7, units="days"))
  ep <- glue("/-/pkgreleases?descending=true&endkey=%22{date}%22")
  do_query(ep)
}

news_since <- function(since) {
  date <- format_iso_8601(parse_date(since))
  ep <- glue("/-/pkgreleases?descending=true&endkey=%22{date}%22")
  do_query(ep)
}

news_n <- function(n) {
  ep <- glue("/-/pkgreleases?limit={n}&descending=true")
  do_query(ep)
}

do_query <- function(ep) {
  base <- "https://crandb.r-pkg.org"
  url <- glue("{base}{ep}")
  response <- GET(url)
  stop_for_status(response)
  fromJSON(content(response, as = "text"), simplifyVector = FALSE)
}

format_results <- function(results) {
  app$
    div(theme = list(ul = list("list-style-type" = "")))
  app$ul()

  for (i in seq_along(results)) format_result(results[[i]], i)
}

format_result <- function(result, num) {
  pkg <- result$package
  ago <- vague_dt(Sys.time() - parse_iso_8601(result$date))
  app$it()
  app$text("{num}. {pkg {pkg$Package}} {pkg$Version} --
           {ago} by {emph {pkg$Maintainer}}")
  app$text("{pkg$Title}")
  app$text("{url https://r-pkg.org/pkg/{pkg$Package}}")
}

news(opts$n, opts$day, opts$week, opts$since, opts$reverse)
