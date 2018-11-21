
context("subprocess")

test_that("events are properly generated", {
  do <- function() {
    cliapp::cli_div()
    cliapp::cli_h1("title")
    cliapp::cli_text("text")
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  msgs <- list()
  handler <- function(msg) {
    msgs <<- c(msgs, list(msg))
    if (!is.null(findRestart("muffleMessage"))) {
      invokeRestart("muffleMessage")
    }
  }

  withCallingHandlers(
    rs$run(do),
    cliapp_message = handler)

  expect_equal(length(msgs), 4)
  lapply(msgs, expect_s3_class, "cliapp_message")
  expect_equal(msgs[[1]]$type, "div")
  expect_equal(msgs[[2]]$type, "h1")
  expect_equal(msgs[[3]]$type, "text")
  expect_equal(msgs[[4]]$type, "end")
})

test_that("subprocess with default handler", {
  ## This needs callr >= 3.0.0.90001, which is not yet on CRAN
  if (packageVersion("callr") < "3.0.0.9001") skip("Need newer callr")

  do <- function() {
    cliapp::cli_div()
    cliapp::cli_h1("title")
    cliapp::cli_text("text")
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  msgs <- list()
  withr::with_options(list(
    cli.default_handler = function(msg)  {
      msgs <<- c(msgs, list(msg))
      if (!is.null(findRestart("muffleMessage"))) {
        invokeRestart("muffleMessage")
      }
    }),
    rs$run(do)
  )

  expect_equal(length(msgs), 4)
  lapply(msgs, expect_s3_class, "cliapp_message")
  expect_equal(msgs[[1]]$type, "div")
  expect_equal(msgs[[2]]$type, "h1")
  expect_equal(msgs[[3]]$type, "text")
  expect_equal(msgs[[4]]$type, "end")
})