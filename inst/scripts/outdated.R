#! /usr/bin/env Rscript

## To get the pkgcache package:
## source("https://install-github.me/r-lib/pkgcache")

theme <- list(
  "url" = list(color = "blue"),
  ".pkg" = list(color = "orange"))
app <- cliapp::cliapp$new(theme = theme, output = "stdout")

tryCatch({
  library(cli)
  library(pkgcache)
  library(docopt) },
  error = function(e) {
    app$alert_danger("The {pkg pkgcache} and {pkg docopt} packages are needed!")
    q(save = "no", status = 1)
  })

"Usage:
  outdated.R [-l lib] [-x]
  outdated.R -h | --help

Options:
  -x         Print not CRAN/BioC packages as well
  -l lib     Library directory, default is first directory in the lib path
  -h --help  Print this help message

Check for outdated packages in a package library.
" -> doc

opts <-  docopt(doc)

outdated <- function(lib = NULL, notcran = FALSE) {
  if (is.null(lib)) lib <- .libPaths()[1]
  inst <- utils::installed.packages(lib = lib)
  app$alert_info("Getting repository metadata")
  repo <- meta_cache_list(rownames(inst))

  if (!notcran) inst <- inst[inst[, "Package"] %in% repo$package, ]

  for (i in seq_len(nrow(inst))) {
    pkg <- inst[i, "Package"]
    iver <- inst[i, "Version"]

    if (! pkg %in% repo$package) {
      app$alert_info("{pkg {pkg}}: \tnot a CRAN/BioC package")
      next
    }

    rpkg <- repo[repo$package == pkg, ]
    newer <- rpkg[package_version(rpkg$version) > iver, ]
    if (!nrow(newer)) next

    nver <- package_version(newer$version)
    mnver <- max(nver)
    newest <- newer[mnver == nver, ]
    bin <- if (any(newest$platform != "source")) "bin" else ""
    src <- if (any(newest$platform == "source")) "src" else ""

    app$alert_danger(
          "{pkg {pkg}} \t{iver} {symbol$arrow_right} {mnver}  {emph ({bin} {src})}")
  }
}

outdated(opts$l, opts$x)
