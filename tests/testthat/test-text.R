
context("cli text")

setup(start_app())
teardown(stop_app())

test_that("text is wrapped", {
  cli_reset()
  cli_div(class = "testcli", theme = test_style())

  withr::with_options(c(cli.width = 60), {
    capt0(cli_h1("Header"))
    out <- capt0(cli_text(lorem_ipsum()))
    out <- strsplit(out, "\n")[[1]]
    len <- nchar(strsplit(out, "\n", fixed = TRUE)[[1]])
    expect_true(all(len <= 60))
  })
})

test_that("verbatim text is not wrapped", {
  cli_reset()
  cli_div(class = "testcli", theme = test_style())

  withr::with_options(c(cli.width = 60), {
    capt0(cli_h1("Header"))
    txt <- strrep("1234567890 ", 20)
    out <- capt0(cli_verbatim(txt))
    expect_equal(out, paste0(txt, "\n"))
  })
})
