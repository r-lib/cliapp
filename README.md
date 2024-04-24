cliapp
================


> Create Rich Command Line Applications

<!-- badges: start -->
[![lifecycle](https://img.shields.io/badge/lifecycle-superseded-blue.svg)](https://lifecycle.r-lib.org/articles/stages.html)
[![R-CMD-check](https://github.com/r-lib/cliapp/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/r-lib/cliapp/actions/workflows/R-CMD-check.yaml)
[![](https://www.r-pkg.org/badges/version/cliapp)](https://www.r-pkg.org/pkg/cliapp)
[![CRAN RStudio mirror downloads](https://cranlogs.r-pkg.org/badges/cliapp)](https://www.r-pkg.org/pkg/cliapp)
[![Codecov test coverage](https://codecov.io/gh/r-lib/cliapp/branch/main/graph/badge.svg)](https://app.codecov.io/gh/r-lib/cliapp?branch=main)
<!-- badges: end -->

Create rich command line applications, with colors, headings, lists, alerts,
progress bars, etc. It uses CSS for theming.

---

- [Superseded](#superseded)
- [Installation](#installation)
- [Usage](#usage)
  - [Headings](#headings)
  - [Text and inline markup](#text-and-inline-markup)
  - [Alerts](#alerts)
  - [Lists](#lists)
  - [Progress bars](#progress-bars)
- [License](#license)

## Superseded

This package is superseded, and we focus on the cli package now:
<https://github.com/r-lib/cli>

## Installation

Stable version:

``` r
install.packages("cliapp")
```

Development version:

``` r
pak::pak("r-lib/cliapp")
```

## Usage

This README uses the simple theme, included in the package, see
`?simple_theme()`.

``` r
library(cliapp)
start_app(theme = simple_theme())
```

### Headings

`cli_h1()`, `cli_h2()` and `cli_h3()` create three levels of headings:

``` r
cli_h1("Title")
cli_h2("Subtitle")
cli_h3("Subsubtitle")
```

![](man/figures/headings-1.png)<!-- -->![](man/figures/headings-2.png)<!-- -->![](man/figures/headings-3.png)<!-- -->

### Text and inline markup

All (non-verbatim) outputted text runs through `glue::glue()`. In
addition to glue interpolation, cliapp also supports inline markup via
the `{markup text}` form. The builtin theme defines inline markup
classes, see `?inline-markup`.

``` r
cli_text("{emph Emphasized text}, {strong Strong} importance.
  A piece of code: {code  sum(a) / length(a)}. Package names:
  {pkg cliapp}, file names: {path /usr/bin/env}, etc.")
```

![](man/figures/inline-markup-1.png)<!-- -->

### Alerts

``` r
cli_alert("Generic alert")
cli_alert_danger("Something went horribly wrong")
cli_alert_warning("Better watch out!")
cli_alert_info("About to download 1.4GiB of data.")
cli_alert_success("All downloads finished successfully")
```

![](man/figures/alerts-1.png)<!-- -->![](man/figures/alerts-2.png)<!-- -->![](man/figures/alerts-3.png)<!-- -->![](man/figures/alerts-4.png)<!-- -->![](man/figures/alerts-5.png)<!-- -->

### Lists

Ordered, unordered and definition lists, they can be nested. See
`?cli_ol()`, `?cli_ul()`, `?cli_dl()` and `?cli_it()`.

``` r
cli_div(theme = list(ol = list("margin-left" = 2)))
cli_ul("one", .close = FALSE)
cli_ol(c("foo", "bar", "foobar"))
cli_it("two")
cli_end()
cli_end()
```

![](man/figures/lists-1.png)<!-- -->

### Progress bars

Progress bars are supported via the [progress
package](https://github.com/r-lib/progress).

## License

MIT © RStudio
