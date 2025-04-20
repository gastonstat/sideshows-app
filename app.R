# Title: Sideshows in Oakland
# Description: Prototype shiny app to display a map of sideshows in Oakland.
# Note: App idea in collaboration with Selene Banuelos.
# Author: Gaston Sanchez
# Date: 7/22/2024


# packages
library(shiny)
library(tidyverse)  # data science packages
library(leaflet)    # web interactive maps


# import data (this is just a test data set)
data = read.csv(
  file = "specific_date.csv", 
  colClasses = c("double", "double", "character", "Date"))


# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Prototype App: Sideshows in Oakland"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            dateRangeInput(inputId = "dates", 
                           label = "Date range", 
                           start = "2023-01-01", 
                           end = "2023-01-31")
        ),

        # Show a plot of the generated map
        mainPanel(
           leafletOutput(outputId = "map")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$map <- renderLeaflet({
      data |>
        filter(between(date, input$dates[1], input$dates[2])) |>
        leaflet() |>
        addProviderTiles("CartoDB.Positron") |>
        addCircleMarkers(lat = ~oc_lat, 
                         lng = ~oc_lng, 
                         radius = 5,
                         stroke = 0.5,
                         fillOpacity = 1,
                         fillColor = "red",
                         popup = ~ADDRESS)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
