testthat::context("Data input")
testthat::test_that("Creating a WTSS coverage", {
    coverage.tb <- sits_coverage(service = "WTSS", product = "MOD13Q1",
                                 coverage = "mod13q1_512")
    testthat::expect_true(coverage.tb$service == "WTSS")
})
testthat::test_that("Creating a SATVEG coverage", {
    coverage.tb <- sits_coverage(service = "SATVEG", product = "MOD13Q1",
                                 coverage = "terra")
    testthat::expect_true(coverage.tb$service == "SATVEG")
})

testthat::test_that("Reading a CSV file from WTSS", {
    testthat::skip_on_cran()
    csv_file <- system.file("extdata/samples/samples_matogrosso.csv", package = "sits")
    points.tb <- sits_fromCSV(csv_file = csv_file, service = "WTSS", product = "MOD13Q1",
                              coverage = "mod13q1_512")
    testthat::expect_true(NROW(points.tb) > 1)
    testthat::expect_true(length(points.tb[1,]$time_series[[1]]$Index) ==
                              length(points.tb[NROW(points.tb),]$time_series[[1]]$Index))
})

testthat::test_that("Reading a point from WTSS ",{
    testthat::skip_on_cran()
    point.tb <- sits_fromWTSS(longitude = -55.50563, latitude = -11.71557,
                                      product = "MOD13Q1", coverage = "mod13q1_512")
    timeline <- as.vector(point.tb$time_series[[1]]$Index)

    testthat::expect_true(point.tb$start_date == timeline[1])
    testthat::expect_true(point.tb$end_date == timeline[length(timeline)])
})

testthat::test_that("Reading a point from SATVEG ",{
    testthat::skip_on_cran()
    point_terra.tb <- sits_fromSATVEG(longitude = -55.50563, latitude = -11.71557,
                                      product = "MOD13Q1", coverage = "terra")
    point_comb.tb <- sits_fromSATVEG(longitude = -55.50563, latitude = -11.71557,
                                     product = "MOD-MYD13Q1", coverage = "comb")

    testthat::expect_true(length(point_comb.tb$time_series[[1]]$Index) >=
                              length(point_terra.tb$time_series[[1]]$Index))
})

testthat::test_that("Reading a ZOO time series", {
    data(ts_zoo)
    data.tb <- sits_fromZOO(ts_zoo, longitude = -54.2313, latitude = -14.0482,
                            label = "Cerrado", coverage = "mod13q1")

    testthat::expect_true(NROW(ts_zoo) == NROW(data.tb$time_series[[1]]))
})

testthat::test_that("Reading a shapefile", {
    shp_file <- system.file("extdata/shapefiles/santa_cruz_de_minas/santa_cruz_de_minas.shp", package = "sits")
    munic.tb <- sits_fromSHP(shp_file, service = "SATVEG", product = "MOD13Q1", coverage = "terra")

    sf_shape <- sf::read_sf(shp_file)
    bbox <- sf::st_bbox(sf_shape)

    s <- paste0(product = "MOD13Q1","_resolution")
    res          <- vector(length = 2)
    names(res)  <- c("xres", "yres")
    for (c in names(res))
        res[c] <- sits:::sits.env$config[[s]][[c]]

    longitudes_box <- seq(from = bbox["xmin"], to = bbox["xmax"], by = res["xres"])
    longitudes_shp <- munic.tb$longitude

    testthat::expect_true(all(unique(longitudes_shp) %in% unique(longitudes_box)))

})

testthat::test_that("Labels and re-label",{
    data(prodes_226_064)
    conv.lst = list("Deforestation_2014" = "NonForest",
                    "Deforestation_2015" = "NonForest",
                    "Forest" = "Forest",
                    "Pasture" = "NonForest")
    new_data.tb <- sits_relabel(prodes_226_064, conv.lst)

    testthat::expect_true(length(sits_labels(prodes_226_064)$label) > length(sits_labels(new_data.tb)$label))
})