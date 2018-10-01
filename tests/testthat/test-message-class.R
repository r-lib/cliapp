
context("message-classes")

test_that("message classes are added properly", {
  msg <- tryCatch(
    clix$alert_success("wow"),
    message = function(x) x)
  expect_s3_class(msg, "callr_message")
  expect_s3_class(msg, "cliapp_message")
})

test_that("progress bar message classes", {
  x <- 100
  msgs <- list()
  withr::with_options(
    list(cli.width = 40, crayon.enabled = FALSE, crayon.colors = 1), {
    out <- capt0({
      clix$verbatim("so far so good: {x}")
      bar <- clix$progress_bar(total = 5, force = TRUE, show_after = 0)
      msgs[[1]] <- tryCatch(bar$tick(), message = function(x) x)
      msgs[[2]] <- tryCatch(bar$tick(), message = function(x) x)
      msgs[[3]] <- tryCatch(clix$verbatim("still very good: {x}!"),
                            message = function(x) x)
      msgs[[4]] <- tryCatch(bar$tick(), message = function(x) x)
      msgs[[5]] <- tryCatch(clix$text(strrep("1234567890 ", 6)),
                            message = function(x) x)
      msgs[[6]] <- tryCatch(bar$tick(), message = function(x) x)
      msgs[[7]] <- tryCatch(bar$tick(), message = function(x) x)
      msgs[[8]] <- tryCatch(clix$verbatim("aaaaand we are done"),
                            message = function(x) x)
    })
    })

  for (m in msgs) {
    expect_s3_class(m, "callr_message")
    expect_s3_class(m, "cliapp_message")
  }
})
