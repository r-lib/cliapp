% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/simple-theme.R
\name{simple_theme}
\alias{simple_theme}
\title{A simple CLI theme}
\usage{
simple_theme(dark = "auto")
}
\arguments{
\item{dark}{Whether the theme should be optiomized for a dark
background. If \code{"auto"}, then cliapp will try to detect this.
Detection usually works in recent RStudio versions, and in iTerm
on macOS, but not on other platforms.}
}
\description{
Note that this is in addition to the builtin theme. To use this theme,
you can set it as the \code{cli.theme} option:
}
\details{
\if{html}{\out{<div class="sourceCode">}}\preformatted{options(cli.theme = cliapp::simple_theme())
}\if{html}{\out{</div>}}

and then CLI apps started after this will use it as the default theme.
You can also use it temporarily, in a div element:

\if{html}{\out{<div class="sourceCode">}}\preformatted{cli_div(theme = cliapp::simple_theme())
}\if{html}{\out{</div>}}
}
\examples{
\dontshow{if (!cliapp:::is_cran_check()) (if (getRversion() >= "3.4") withAutoprint else force)(\{ # examplesIf}
cli_div(theme = cliapp::simple_theme())

cli_h1("Header 1")
cli_h2("Header 2")
cli_h3("Header 3")

cli_alert_danger("Danger alert")
cli_alert_warning("Warning alert")
cli_alert_info("Info alert")
cli_alert_success("Success alert")
cli_alert("Alert for starting a process or computation",
  class = "alert-start")

cli_text("Packages and versions: {pkg cliapp} {version 1.0.0}.")
cli_text("Time intervals: {timestamp 3.4s}")

cli_text("{emph Emphasis} and  {strong strong emphasis}")

cli_text("This is a piece of code: {code sum(x) / length(x)}")
cli_text("Function names: {fun cliapp::simple_theme} and {arg arguments}.")

cli_text("Files: {file /usr/bin/env}")
cli_text("URLs: {url https://r-project.org}")

cli_h2("Longer code chunk")
cli_par(class = "r-code")
cli_verbatim(
  '# window functions are useful for grouped mutates',
  'mtcars \%>\%',
  '  group_by(cyl) \%>\%',
  '  mutate(rank = min_rank(desc(mpg)))')
cli_end()

cli_h2("Even longer code chunk")
cli_par(class = "r-code")
cli_verbatim(format(ls))
cli_end()

cli_end()
\dontshow{\}) # examplesIf}
}
\seealso{
\link{themes}, \code{\link[=builtin_theme]{builtin_theme()}}.
}
