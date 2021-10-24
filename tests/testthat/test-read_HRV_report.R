test_that("multiplication works", {
  expect_equal(2 * 2, 4)
})


# Read HRV report ---------------------------------------------------------


test_that("Read HRV report file", {

  path <- system.file("testdata","HRV", package="physiolab")
  hrv_df <- physiolab::read_HRV_report(path)
  expect_s3_class(hrv_df, "data.frame")

})
