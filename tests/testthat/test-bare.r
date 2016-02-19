context("Bare expectations")

expect_that(1, equals(1))
expect_equal(2, 2)

expect_that(2, is_less_than(3))
expect_that(3, is_more_than(2))

expect_more_than(3, 2)
expect_gt(3, 2)
expect_gte(3, 3)
expect_less_than(2, 3)
expect_lt(2, 3)
expect_lte(2, 2)

expect_error(expect_false(FALSE), NA)
expect_error(expect_false(TRUE))
