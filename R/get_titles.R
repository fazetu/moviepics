get_url <- function(month, year) {
  # create url like this:
  # https://www.dvdsreleasedates.com/releases/2018/11/new-dvd-releases-november-2018
  url_base <- "https://www.dvdsreleasedates.com/releases"
  if (!is.numeric(month)) month <- convert_month(month)
  month_char <- tolower(convert_month(month))
  url <- paste(url_base, year, month, paste("new-dvd-releases", month_char, year, sep = "-"), sep = "/")
  url
}

isnt_movie_title <- function(title) {
  title <- tolower(title)
  stringr::str_detect(title, " s\\d ") | stringr::str_detect(title, " season ")
}

#' Get movies released on DVD/Blu-ray for specified month and year.
#'
#' Get the movies released for the month and year specified. Can optionally
#' include titles that look like TV series as well. Scrapes
#' \href{https://www.dvdsreleasedates.com/}{DVD Release Dates} for titles and
#' dates.
#'
#' @param month Integer or character month.
#' @param year Integer year.
#' @param n_movies Integer number of movies to include for each week of releases in the month.
#' @param movies_only Boolean indicator if only movie titles should be returned.
#'   Exclude TV series like titles.
#' @return List of character vectors of the movies released. List is structured
#'   by release date.
#' @examples
#' get_titles("JAN", 2018)
#' get_titles(1, 2018)
#'
#' @export
get_titles <- function(month, year, n_movies = 5, movies_only = TRUE) {
  # check inputs
  validate_inputs(month = month, year = year, n_movies = n_movies, movies_only = movies_only)

  # split the page by week
  url <- get_url(month = month, year = year)

  weekly_releases <- read_html(url) %>%
    html_nodes(".fieldtable-inner")

  # get dates
  dates <- weekly_releases %>%
    html_nodes(".reldate") %>%
    html_text()

  dates <- gsub("(.*)\\(.*\\)", "\\1", dates)

  # get titles
  titles <- lapply(weekly_releases, function(week) {
    week %>% html_nodes("br+ a") %>% html_text()
  })

  # filter out titles that look like TV series
  if (movies_only) {
    titles <- lapply(titles, function(title) {
      title[!isnt_movie_title(title = title)]
    })
  }

  # filter out based on number per week needed
  titles <- lapply(titles, function(title) {
    title[1:min(length(title), n_movies)]
  })

  # return
  names(titles) <- dates
  titles
}
