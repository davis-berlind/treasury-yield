library(shiny)
library(rvest)
library(plotly)
library(dplyr)

source("yield_scraper.R")
source("yield_plot.R")

yield_data <- yield_scraper()

# Define UI ----
ui <- fluidPage(
  titlePanel("US Treasury Yields"),
  sidebarLayout(
    sidebarPanel(
      width = 3,
      helpText("Create 3D Visualization of the Daily Treasury Yield Curve Rates changing over time."),
      dateRangeInput("dates", label = "Date Range:",
                     start = min(yield_data$Date), end = max(yield_data$Date),
                     min = min(yield_data$Date), max = max(yield_data$Date)),
      sliderInput("slider", label = "Width:",
                  min = 1, max = 10, value = 4)
    ),
    mainPanel(
      plotlyOutput("yield_curve")
    )
  )
)

# Define server logic ----
server <- function(input, output) {
  output$yield_curve <- renderPlotly({
    yield_plot(input$dates[1], input$dates[2], input$slider, yield_data)
  })
}

# Run the app ----
shinyApp(ui = ui, server = server)