month_dictionary <- c(
  "January" = 1,
  "Febraury" = 2,
  "March" = 3,
  "April" = 4,
  "May" = 5,
  "June" = 6,
  "July" = 7,
  "August" = 8,
  "September" = 9,
  "October" = 10,
  "November" = 11,
  "December" = 12
)

# convert either numeric or character month to the other
convert_month <- function(month) {
  if (is.numeric(month)) {
    names(month_dictionary)[month]
  } else {
    month <- toupper(as.character(month))
    compare_names <- substr(names(month_dictionary), start = 1, stop = nchar(month))
    which(month == toupper(compare_names))
  }
}

validate_inputs <- function(month = 1, year = 2018, n_movies = 5, movies_only = TRUE,
                            dir = ".", title = "Jumanji", n_pictures = 5, subdir_organize = FALSE) {
  if (is.numeric(month)) {
    stopifnot(month %% 1 == 0)
  } else {
    stopifnot(is.character(month))
  }
  stopifnot(year %% 1 == 0)
  stopifnot(n_movies %% 1 == 0)
  stopifnot(n_movies > 0)
  stopifnot(is.logical(movies_only))

  stopifnot(is.character(dir))
  stopifnot(is.character(title))
  stopifnot(n_pictures %% 1 == 0)
  stopifnot(n_pictures <= 20)
  stopifnot(n_pictures > 0)

  stopifnot(is.logical(subdir_organize))
}
