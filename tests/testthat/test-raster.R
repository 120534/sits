context("Raster classification")
test_that("Working with raster coverages", {
    #skip_on_cran()
    library(rgdal)
    library(raster)
    library(sf)
    files <- c(system.file("extdata/raster/mod13q1/sinop-crop-ndvi.tif", package = "sits"))
    data("timeline_modis_392")
    raster.tb <- sits_coverage(service = "RASTER",
                               name = "Sinop-crop",
                               timeline = timeline_modis_392,
                               bands = "ndvi",
                               files = files)

    r_obj <- raster.tb[1,]$r_objs[[1]][[1]]
    expect_true(raster::nrow(r_obj) == raster.tb$nrows)
    expect_true(raster::xmin(r_obj) == raster.tb$xmin)

    point.tb <- sits_get_data(coverage = raster.tb, longitude = -55.55502, latitude = -11.52774)

    expect_true(length(point.tb$time_series[[1]]$Index) == length(timeline_modis_392))

    rfor_model <- sits_train(samples_mt_ndvi, sits_rfor())

    raster_class.tb <- sits_classify_raster(file = "raster-class", raster.tb,
                                            rfor_model, memsize = 4, multicores = 1)

    expect_true(all(file.exists(unlist(raster_class.tb$files))))
    rc_obj <- raster_class.tb[1,]$r_objs[[1]][[1]]
    expect_true(raster::nrow(rc_obj) == raster_class.tb[1,]$nrows)

    raster_class_bayes.tb <- sits::sits_bayes_postprocess(raster_class.tb,
                                                          file = "raster-class-bayes")

    expect_true(all(file.exists(unlist(raster_class_bayes.tb$files))))
    rc_obj2 <- raster_class_bayes.tb[1,]$r_objs[[1]][[1]]
    expect_true(raster::nrow(rc_obj2) == raster_class_bayes.tb[1,]$nrows)
    expect_true(raster::nrow(rc_obj2) == raster::nrow(rc_obj))

    expect_true(all(file.remove(unlist(raster_class.tb$files))))
    expect_true(all(file.remove(unlist(raster_class_bayes.tb$files))))
})
