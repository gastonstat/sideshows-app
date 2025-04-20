# Title: Sideshows in Oakland
# Description: R code to "forward" geocode addresses using R package "opencage"
# Note: App idea in collaboration with Selene Banuelos.
# Author: Gaston Sanchez
# Date: 7/22/2024


# Packages
library(opencage)  # geocode with OpenCage API
library(leaflet)   # web interactive maps
library(lubridate) # string manipulation


# Replace 'your_api_key' with your actual OpenCage API key
key = "19dd60aac7b94c4cb47c194b7fe90e18"


# new function "oc_forward" does not have a 'key' argument
#x = oc_forward(placename = "34TH ST&ADELINE ST, OAKLAND, CA", key = key)
#y = oc_forward(placename = "82ND AV&MACARTHUR BLVD, OAKLAND, CA")


# deprecated function opencage_forward() lets you specify an API key
y1 = opencage_forward(
  placename = "82ND AV&MACARTHUR BLVD", 
  key = "19dd60aac7b94c4cb47c194b7fe90e18")


addresses <- c(
  "34TH ST&ADELINE ST, OAKLAND, CA",
  "82ND AV&MACARTHUR BLVD, OAKLAND, CA",
  "PARK BLVD&WELLINGTON ST, OAKLAND, CA"
)

geocoded_addresses <- data.frame(
  Address = character(), 
  Latitude = numeric(), 
  Longitude = numeric(), 
  stringsAsFactors = FALSE)


for (address in addresses) {
  result <- opencage_forward(placename = address, key = key)
  if (nrow(result$results) > 0) {
    latitude <- result$results$geometry.lat[1]
    longitude <- result$results$geometry.lng[1]
  } else {
    latitude <- NA
    longitude <- NA
  }
  # adding geocoded data
  geocoded_addresses <- rbind(
    geocoded_addresses, 
    data.frame(Address = address, 
               Latitude = latitude, 
               Longitude = longitude, 
               stringsAsFactors = FALSE))
}

geocoded_addresses


# interactive map
geocoded_addresses |>
leaflet() |>
  addTiles() |> # default OpenStreetMap map tiles
  addMarkers()

