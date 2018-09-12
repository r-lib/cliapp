
## nocov start

dummy <- function() { }

cli <- NULL

.onLoad <- function(libname, pkgname) {
  pkgenv <- environment(dummy)
  cli <- cli_class$new()
  assign("cli", cli, envir = pkgenv)
}

## nocov end
