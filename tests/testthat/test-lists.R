
context("cli lists")

setup(start_app())
teardown(stop_app())

test_that("ul", {
  cli_div(theme = list(ul = list("list-style-type" = "*")))
  lid <- cli_ul()
  out <- capt0({
    cli_it("foo")
    cli_it(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "* foo\n* bar\n* foobar\n")
  cli_end(lid)
})

test_that("ol", {
  cli_div(theme = list(ol = list()))
  lid <- cli_ol()
  out <- capt0({
    cli_it("foo")
    cli_it(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "1. foo\n2. bar\n3. foobar\n")
  cli_end(lid)
})

test_that("ul ul", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    "ul ul" = list("list-style-type" = "-"),
    it = list("margin-left" = 2)
  ))
  lid <- cli_ul()
  out <- capt0({
    cli_it("1")
    lid2 <- cli_ul()
    cli_it("1 1")
    cli_it(c("1 2", "1 3"))
    cli_end(lid2)
    cli_it("2")
  }, strip_style = TRUE)
  expect_equal(out, "* 1\n  - 1 1\n  - 1 2\n  - 1 3\n* 2\n")
  cli_end(lid)
})

test_that("ul ol", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- cli_ul()
  out <- capt0({
    cli_it("1")
    lid2 <- cli_ol()
    cli_it("1 1")
    cli_it(c("1 2", "1 3"))
    cli_end(lid2)
    cli_it("2")
  }, strip_style = TRUE)
  expect_equal(out, "* 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\n* 2\n")
  cli_end(lid)
})

test_that("ol ol", {
  cli_div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- cli_ol()
  out <- capt0({
    cli_it("1")
    lid2 <- cli_ol()
    cli_it("1 1")
    cli_it(c("1 2", "1 3"))
    cli_end(lid2)
    cli_it("2")
  }, strip_style = TRUE)
  expect_equal(out, "1. 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\n2. 2\n")
  cli_end(lid)
})

test_that("ol ul", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- cli_ol()
  out <- capt0({
    cli_it("1")
    lid2 <- cli_ul()
    cli_it("1 1")
    cli_it(c("1 2", "1 3"))
    cli_end(lid2)
    cli_it("2")
  }, strip_style = TRUE)
  expect_equal(out, "1. 1\n  * 1 1\n  * 1 2\n  * 1 3\n2. 2\n")
  cli_end(lid)
})

test_that("starting with an item", {
  cli_div(theme = list(ul = list("list-style-type" = "*")))
  out <- capt0({
    cli_it("foo")
    cli_it(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "* foo\n* bar\n* foobar\n")
})

test_that("ol, with first item", {
  cli_div(theme = list(ol = list()))
  out <- capt0({
    lid <- cli_ol("foo", .close = FALSE)
    cli_it(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "1. foo\n2. bar\n3. foobar\n")
  cli_end(lid)
})

test_that("ul, with first item", {
  cli_div(theme = list(ul = list("list-style-type" = "*")))
  out <- capt0({
    lid <- cli_ul("foo", .close = FALSE)
    cli_it(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "* foo\n* bar\n* foobar\n")
  cli_end(lid)
})

test_that("dl", {
  cli_div(theme = list(ul = list()))
  lid <- cli_dl()
  out <- capt0({
    cli_it(c(this = "foo"))
    cli_it(c(that = "bar", other = "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "this: foo\nthat: bar\nother: foobar\n")
  cli_end(lid)
})

test_that("dl dl", {
  cli_div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- cli_dl()
  out <- capt0({
    cli_it(c(a = "1"))
    lid2 <- cli_dl()
    cli_it(c("a-a" = "1 1"))
    cli_it(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_it(c(b = "2"))
  }, strip_style = TRUE)
  expect_equal(out, "a: 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\nb: 2\n")
  cli_end(lid)
})

test_that("dl ol", {
  cli_div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- cli_dl()
  out <- capt0({
    cli_it(c(a = "1"))
    lid2 <- cli_ol()
    cli_it(c("1 1"))
    cli_it(c("1 2", "1 3"))
    cli_end(lid2)
    cli_it(c(b = "2"))
  }, strip_style = TRUE)
  expect_equal(out, "a: 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\nb: 2\n")
  cli_end(lid)
})

test_that("dl ul", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- cli_dl()
  out <- capt0({
    cli_it(c(a = "1"))
    lid2 <- cli_ul()
    cli_it(c("1 1"))
    cli_it(c("1 2", "1 3"))
    cli_end(lid2)
    cli_it(c(b = "2"))
  }, strip_style = TRUE)
  expect_equal(out, "a: 1\n  * 1 1\n  * 1 2\n  * 1 3\nb: 2\n")
  cli_end(lid)
})

test_that("ol dl", {
  cli_div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- cli_ol()
  out <- capt0({
    cli_it("1")
    lid2 <- cli_dl()
    cli_it(c("a-a" = "1 1"))
    cli_it(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_it("2")
  }, strip_style = TRUE)
  expect_equal(out, "1. 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n2. 2\n")
  cli_end(lid)
})

test_that("ul dl", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- cli_ul()
  out <- capt0({
    cli_it("1")
    lid2 <- cli_dl()
    cli_it(c("a-a" = "1 1"))
    cli_it(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_it("2")
  }, strip_style = TRUE)
  expect_equal(out, "* 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n* 2\n")
  cli_end(lid)
})

test_that("dl, with first item", {
  cli_div(theme = list(ul = list()))
  out <- capt0({
    lid <- cli_dl(c(this = "foo"), .close = FALSE)
    cli_it(c(that = "bar", other = "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "this: foo\nthat: bar\nother: foobar\n")
  cli_end(lid)
})
