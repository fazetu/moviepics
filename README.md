# moviepics

R package for automating the image download of movie poster files.

This package uses [DVD Release Dates](https://www.dvdsreleasedates.com/) to get the titles that are being released for the date.

It also relies on [phantomjs](http://phantomjs.org/) to load the google image search results. This exe is bundled in the `inst\` folder of the package.

## Installation:

```
devtools::install_github("fazetu/moviepics")
library(moviepics)
```

## Useage:

Use the function `get_titles` to get a list structure of movies that are being released on DVD/Blu-ray for the designated month and year. This scrapes [DVD Release Dates](https://www.dvdsreleasedates.com/).

```
jan18_titles <- get_titles(month = 1, year = 2018, n_movies = 5, movies_only = TRUE)
```

Use `download_pictures_title` to get the images for a given title. This uses [phantomjs](http://phantomjs.org/).

```
download_pictures_title(dir = ".", title = "The Shape of Water", n_pictures = 5)
```

Use `download_pictures` to get all the images for the titles of a given month and year. Combines the above two functions.

```
download_pictures(dir = ".", month = 1, year = 2018, n_movies = 5, movies_only = TRUE, n_pictures = 5, subdir_organize = FALSE)
```
