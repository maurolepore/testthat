#' Expectation: does the object inherit from a S3 or S4 class, or is it a base type?
#'
#' @description
#' See <https://adv-r.hadley.nz/oo.html> for an overview of R's OO systems, and
#' the vocabulary used here.
#'
#' * `expect_type(x, type)` checks that `typeof(x)` is `type`.
#' * `expect_s3_class(x, class)` checks that `x` is an S3 object that
#'   [inherits()] from `class`
#' * `expect_s4_class(x, class)` checks that `x` is an S4 object that
#'   [is()] `class`.
#'
#' @param type String giving base type (as returned by [typeof()]).
#' @param class character vector of class names
#' @inheritParams expect_that
#' @family expectations
#' @examples
#' x <- data.frame(x = 1:10, y = "x")
#' # A data frame is an S3 object with class data.frame
#' expect_s3_class(x, "data.frame")
#' show_failure(expect_s4_class(x, "data.frame"))
#' # A data frame is built from a list:
#' expect_type(x, "list")
#'
#' # An integer vector is an atomic vector of type "integer"
#' expect_type(x$x, "integer")
#' # It is not an S3 object
#' show_failure(expect_s3_class(x$x, "integer"))
#'
#' # By default data.frame() converts characters to factors:
#' show_failure(expect_type(x$y, "character"))
#' expect_s3_class(x$y, "factor")
#' expect_type(x$y, "integer")
#' @name inheritance-expectations
NULL

#' @export
#' @rdname inheritance-expectations
expect_type <- function(object, type) {
  stopifnot(is.character(type), length(type) == 1)

  act <- quasi_label(enquo(object), arg = "object")
  act_type <- typeof(act$val)

  expect(
    identical(act_type, type),
    sprintf("%s has type `%s`, not `%s`.", act$lab, act_type, type)
  )
  invisible(act$val)
}

#' @export
#' @rdname inheritance-expectations
expect_s3_class <- function(object, class) {
  stopifnot(is.character(class))

  act <- quasi_label(enquo(object), arg = "object")
  act$class <- klass(act$val)
  exp_lab <- paste(class, collapse = "/")

  if (!isS3(act$val)) {
    fail(sprintf("%s is not an S3 object", act$lab))
  }

  expect(
    inherits(act$val, class),
    sprintf("%s inherits from `%s` not `%s`.", act$lab, act$class, exp_lab)
  )
  invisible(act$val)
}

#' @export
#' @rdname inheritance-expectations
expect_s4_class <- function(object, class) {
  stopifnot(is.character(class))

  act <- quasi_label(enquo(object), arg = "object")
  act_val_lab <- paste(methods::is(object), collapse = "/")
  exp_lab <- paste(class, collapse = "/")

  if (!isS4(act$val)) {
    fail(sprintf("%s is not an S4 object", act$lab))
  }

  expect(
    methods::is(act$val, class),
    sprintf("%s inherits from `%s` not `%s`.", act$lab, act_val_lab, exp_lab)
  )
  invisible(act$val)
}

isS3 <- function(x) is.object(x) && !isS4(x)

#' Expectation: does the object inherit from a given class?
#'
#' `expect_is()` is an older form that uses [inherits()] without checking
#' whether `x` is S3, S4, or neither. Intead, I'd recommend using
#' [expect_type()], [expect_s3_class()] or [expect_s4_class()] to more clearly
#' convey your  intent.
#'
#' @keywords internal
#' @inheritParams expect_type
#' @export
expect_is <- function(object, class, info = NULL, label = NULL) {
  stopifnot(is.character(class))

  act <- quasi_label(enquo(object), label, arg = "object")
  act$class <- klass(act$val)
  exp_lab <- paste(class, collapse = "/")

  expect(
    inherits(act$val, class),
    sprintf("%s inherits from `%s` not `%s`.", act$lab, act$class, exp_lab),
    info = info
  )
  invisible(act$val)
}
