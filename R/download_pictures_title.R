#' Download the google image pictures for a title
#'
#' Saves image files for a single movie title. Uses
#' \href{http://phantomjs.org/}{phantomjs} to load the google image results and
#' downloads the selected amount of jpeg images for that title.
#'
#' @param dir Character string path to save the images.
#' @param title Character string of the movie title. The google image search is
#'   actually for \code{paste(title, "movie poster")}.
#' @param n_pictures Integer number indicating how many images to download from
#'   the search. Capped at 20.
#' @examples
#' download_pictures_title(".", "The Shape of Water")
#' download_pictures_title(".", "The Shape of Water", n_pictures = 10)
#'
#' @export
download_pictures_title <- function(dir, title, n_pictures = 5) {
  # check inputs
  validate_inputs(dir = dir, title = title, n_pictures = n_pictures)

  # status
  cat(paste0("Downloading images for ", title, "..."), "\n")

  # build google image search url
  google_image_base <- "https://www.google.com/search?tbm=isch&q="
  url_title <- tolower(gsub(" ", "+", title))
  google_image_url <- paste0(google_image_base, url_title, "+movie+poster")

  # make testing easier
  TESTING_ = FALSE # set to TRUE when testing in RStudio
  if (TESTING_) {
    phantomjs_folder <- "inst/phantomjs"
  } else {
    phantomjs_folder <- system.file("phantomjs", package = "moviepics")
  }

  # create js script to pass to phantomjs
  lines <- readLines(paste0(phantomjs_folder, "/imageScrape.js"))
  lines[1] <- paste0('var url = "', google_image_url, '";')
  lines[2] <- paste0('var html_save = "', phantomjs_folder, '/1.html";')
  writeLines(lines, paste0(phantomjs_folder, "/imageScrape.js"))

  # create 1.html using phantomjs
  system(paste0(phantomjs_folder, "/phantomjs ", phantomjs_folder, "/imageScrape.js"))

  # parse 1.html and grap image urls
  page <- read_html(paste0(phantomjs_folder, "/1.html"))
  files <- page %>%
    html_nodes("img") %>%
    html_attr("src")

  # limit number of pictures to download
  files <- files[1:n_pictures]

  # download files
  for (i in seq_along(files)) {
    destfile <- paste0(dir, "/", gsub(" ", "-", title), "-", i, ".jpg")
    download.file(files[i], destfile = destfile, mode = "wb")
  }
}
