library(shiny)
library(ggplot2)
library(maps)
library(dplyr)
library(lubridate)

quake_df <- read.csv("data/query.csv", stringsAsFactors = FALSE)
quake_df$time <- as.Date(quake_df$time)
quake_df <- mutate(quake_df, year = year(time))
quake_df <- select(quake_df, time:mag, place, year)

world.map <- map_data("world")

shinyServer(function(input, output) {
  
    output$text1 <- renderText({ 
      paste("You have chosen a date range that goes from",
          input$range[1], "to", input$range[2])
    })
  
    output$text2 <- renderText({ 
      paste("You have chosen a magnitude range that goes from",
          input$mag_range[1], "to", input$mag_range[2])
    })
  
    output$map <- renderPlot({
      data <- filter(quake_df, year >= year(input$range[1]) & year <= year(input$range[2]))
      data <- filter(data, mag >= input$mag_range[1] & mag <= input$mag_range[2])
      ggplot()+
      geom_polygon(data = world.map, aes(x = long, y = lat, group = group),
                   fill = "white",alpha=0.2) +
      theme_classic() +
      theme(axis.line = element_blank(), panel.background = element_rect(fill='black')) +
      geom_point(aes(x=longitude,y=latitude,size=mag, color=mag),data=data)
    })
  
  # Generate the About tab
    output$About <- renderText({
      ("This app produces a visualization and table of earthquake data.

      Data is from USGS http://earthquake.usgs.gov/earthquakes/search/

      Use the date range selection tool to select the range to display. 

      Use the slider tool to select the range of magnitudes to display.
       
      Click on the Map tab to see a world map of earthquake activity.

      Click on the Histogram tab to see the distribution. 

      Click on the Table tab to see the data.")
    })
  
  # Generate a histogram of the data
    output$hist <- renderPlot({
      data1 <- filter(quake_df, year >= year(input$range[1]) & year <= year(input$range[2]))
      data1 <- filter(data1, mag >= input$mag_range[1] & mag <= input$mag_range[2])
      qhist <- ggplot(data1, aes(mag))
      qhist + geom_histogram(stat = "bin", binwidth = 0.1, aes(fill = ..count..)) +
        ggtitle("Histogram of Earthquake Magnitude During Sample period") +
        xlab("Magnitude") + ylab("Frequency")
    })
  
  # Generate an HTML table view of the data
    output$table <- renderTable({
      data.frame(quake_df)
    })
  
})