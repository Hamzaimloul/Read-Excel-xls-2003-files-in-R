library(rjson)
library(rvest)
library(tidyverse)

json_file_path <- "data/leaflet.json"
html_file_path <- "export/leaflet.html"
file_path <- "data/recent.rds"

#*' Extracts data from a JSON file and a Leaflet map stored in HTML file and saves it as a tibble
#' the map contains markers, and these markers are with popus containing information, so we want to ingest this data to a dataframe.
#'
#' @param json_file_path Path to the JSON file
#' @param html_file_path Path to the HTML file
#' @return A tibble containing extracted data

extract_data_form_map <- function(json_file_path, html_file_path) {
  # Read JSON file and parse it
  json_content <- paste(readLines(json_file_path), collapse = "")
  json_data <- fromJSON(json_content)
  
  # Read HTML file and extract scripts
  html_content <- paste(readLines(html_file_path), collapse = "\n")
  html_scripts <- read_html(html_content) %>% html_nodes("script") %>% html_text()
  
  # Extract data from JSON and create a tibble
  vectorList <- json_data$x$calls[[2]]$args[c(1, 2, 7)] %>% lapply(unlist)
  dt <- do.call(cbind, vectorList) %>% 
    as_tibble() %>% 
    rename(lat = 1, lon = 2, html = 3) %>%
    mutate(html = str_replace_all(html, c("</br>" = "(br)", "<[^>]*>" = " ", "   " = "  ", " " = " ", "&#9742 : " = ""))) %>%
    separate(html, into = c("na", "vehicle", "datetime", "Name", "telephone"), sep = "  ") %>%
    mutate(datetime = str_replace_all(datetime, c("_" = " ", "[^0-9.-: -]" = ""))) %>%
    mutate(datetime = as.POSIXct(datetime, format = "%Y-%m-%d %H:%M:%S", tz = Sys.timezone())) %>%
    select(datetime, vehicle, lat, lon) %>%
    mutate(lon = as.numeric(lon), lat = as.numeric(lat))
  
  return(dt)
}

#*' Saves a tibble as an RDS file
#'
#' @param data The tibble to be saved
#' @param file_path Path to the output RDS file
#' @return NULL
save_as_rds <- function(data, file_path) {
  saveRDS(data, file_path)
  invisible(NULL)
}
