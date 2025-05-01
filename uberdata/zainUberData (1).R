# Load necessary libraries
library(shiny)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(leaflet)
library(tidyverse)
library(reshape2)
library(caret)

# Set working directory
setwd("~/Desktop/DATA 332")

# Read and combine Uber data files
file_names <- list.files(pattern = "uber-raw-data-.*\\.csv$")
uber_data <- lapply(file_names, read.csv)
combined_UberRides <- bind_rows(uber_data)

# Data preprocessing
combined_UberRides <- combined_UberRides %>%
  separate(Date.Time, into = c("Date", "Time"), sep = "\\s+(?=[^\\s]+$)") %>%
  mutate(
    Date = as.Date(Date, format = "%m/%d/%y"),
    Month = month(Date, label = TRUE),
    Day = day(Date),
    day_of_week = wday(Date, label = TRUE),
    hour = as.integer(sub("^(\\d+):.*$", "\\1", Time)),
    minute = as.integer(sub("^\\d+:(\\d+):.*$", "\\1", Time)),
    seconds = as.integer(sub("^\\d+:\\d+:(\\d+)$", "\\1", Time))
  )

# Summarize data for plotting
trips_hour_month <- combined_UberRides %>%
  group_by(hour, Month) %>%
  summarize(num_trips = n(), .groups = 'drop')

trips_per_day_month <- combined_UberRides %>%
  group_by(Month, Day) %>%
  summarize(num_trips = n(), .groups = 'drop')

trips_per_base_month <- combined_UberRides %>%
  group_by(Month, Base) %>%
  summarize(total_trips = n(), .groups = 'drop')

# Prepare data for heatmaps
trips_per_hour_day <- combined_UberRides %>%
  group_by(hour, day_of_week) %>%
  summarize(total_trips = n(), .groups = 'drop')

trips_per_month_day <- combined_UberRides %>%
  group_by(Month, Day) %>%
  summarize(total_trips = n(), .groups = 'drop')

# Define UI for Shiny app
ui <- fluidPage(
  titlePanel("Uber Rides Analysis"),
  sidebarLayout(
    sidebarPanel(
      radioButtons("graph_type", label = "Select a graph type:",
                   choices = c("Trips by Hour and Month", "Trips by Day and Month", "Trips by Base and Month",
                               "Heatmap: Hour vs Day of Week", "Heatmap: Month vs Day", "Prediction Model")),
      leafletOutput("map", width = "100%", height = "700px")
    ),
    mainPanel(
      plotOutput("graph")
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Reactive expression to filter data based on selected date range
  filtered_data <- reactive({
    req(input$date_range)
    combined_UberRides %>%
      filter(Date >= input$date_range[1] & Date <= input$date_range[2])
  })
  
  # Render Leaflet map
  output$map <- renderLeaflet({
    leaflet(data = filtered_data()) %>%
      addTiles() %>%
      addMarkers(lng = ~Lon, lat = ~Lat, popup = ~paste(Base, "<br>", Date))
  })
  
  # Render selected graph
  output$graph <- renderPlot({
    req(input$graph_type)
    
    switch(input$graph_type,
           "Trips by Hour and Month" = {
             ggplot(trips_hour_month, aes(x = hour, y = num_trips, fill = Month)) +
               geom_col(position = "dodge") +
               labs(x = "Hour of Day", y = "Number of Trips", fill = "Month")
           },
           "Trips by Day and Month" = {
             ggplot(trips_per_day_month, aes(x = Day, y = num_trips, fill = Month)) +
               geom_col(position = "dodge") +
               labs(x = "Day of Month", y = "Number of Trips", fill = "Month")
           },
           "Trips by Base and Month" = {
             ggplot(trips_per_base_month, aes(x = Base, y = total_trips, fill = Month)) +
               geom_col(position = "dodge") +
               labs(x = "Base", y = "Number of Trips", fill = "Month")
           },
           "Heatmap: Hour vs Day of Week" = {
             ggplot(melt(dcast(trips_per_hour_day, hour ~ day_of_week, value.var = "total_trips")), aes(x = variable, y = hour, fill = value)) +
               geom_tile() +
               scale_fill_gradient(low = "white", high = "steelblue") +
               labs(x = "Day of Week", y = "Hour of Day", fill = "Number of Trips")
           },
           "Heatmap: Month vs Day" = {
             ggplot(melt(dcast(trips_per_month_day, Day ~ Month, value.var = "total_trips")), aes(x = variable, y = Day, fill = value)) +
               geom_tile() +
               scale_fill_gradient(low = "white", high = "purple") +
               labs(x = "Month", y = "Day", fill = "Number of Trips")
           },
           "Prediction Model" = {
             model <- lm(total_trips ~ hour + Month + day_of_week, data = combined_UberRides)
             ggplot(combined_UberRides, aes(x = hour, y = total_trips)) +
               geom_point() +
               geom_smooth(method = "lm") +
               labs(x = "Hour of Day", y = "Total Trips")
           }
    )
  })
}

# Run the application
shinyApp(ui = ui, server = server)
