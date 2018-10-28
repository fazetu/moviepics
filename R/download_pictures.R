#' Download the google image pictures for all titles of a given month of a year.
#'
#' Uses \link{get_titles} to get the dates and titles for the given month of the
#' year. Then uses \link{download_pictures_title} to download the images for
#' each title.
#'
#' @param dir Character string pointing to a directory to save all the results.
#'   Within this directory a new folder will be created called
#'   moviepics-month-year.
#' @param month Integer or character month.
#' @param year Integer year.
#' @param n_movies Integer indicating the number of movies per week to get
#'   images for.
#' @param movies_only Boolean indicator if only movie titles should be returned.
#'   Exclude TV series like titles.
#' @param n_pictures Integer number indicating how many images to download from
#'   the search. Capped at 20.
#' @param subdir_organize Boolean indicator if the movie image file should be
#'   organized into further subdirectories by release date.
#' @examples
#' download_pictures(".", 1, 2018)
#' download_pictures("..", "january" , 2018, subdir_organize = TRUE)
#'
#' @export
download_pictures <- function(dir, month, year, n_movies = 5, movies_only = TRUE,
                              n_pictures = 5, subdir_organize = FALSE) {
  # check inputs
  validate_inputs(dir = dir, month = month, year = year, n_movies = n_movies, movies_only = movies_only,
                  n_pictures = n_pictures, subdir_organize = subdir_organize)

  # create output folder
  output_folder <- paste0(dir, "/moviepics-", month, "-", year)

  if (dir.exists(output_folder)) {
    stop(paste0("Folder already exits! ", output_folder, " Stopping."))
  } else {
    dir.create(output_folder)
  }

  # get the movie titles
  titles <- get_titles(month = month, year = year, n_movies = n_movies, movies_only = movies_only)

  if (subdir_organize) {
    for (i in seq_along(titles)) {
      # create subdirectories using dates movies come out
      subdir <- names(titles)[i]
      subdir <- gsub(",", "", subdir)
      subdir <- gsub(" ", "-", subdir)
      subdir <- paste0(output_folder, "/", subdir)
      dir.create(subdir)

      # download titles
      for (title in titles[[i]]) {
        download_pictures_title(subdir, title, n_pictures)
      }
    }
  } else {
    titles <- unlist(titles)

    # download titles
    for (title in titles) {
      download_pictures_title(output_folder, title, n_pictures)
    }
  }
}
