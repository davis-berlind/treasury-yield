yield_plot <- function(start, stop, aspect, yield_data) {
  plot_data <- filter(yield_data, Date <= stop & Date >= start)
  x <- plot_data$Date
  y <- names(plot_data)[!grepl("Date", names(plot_data))]
  z <- plot_data %>% 
    select(-Date) %>% 
    as.matrix() %>% 
    t()
  
  plot_ly(x = x, y = y, z = z, type = "surface",
          opacity = 0.9) %>% 
    layout(title = paste("Daily Treasury Yield Curve Rates from\n", 
                         format(start, format = "%B %d, %Y"), 
                         "to", 
                         format(stop, format = "%B %d, %Y")),
           scene = list(xaxis = list(title = 'Date', 
                                     titlefont = list(size = 15),
                                     tickfont = list(size = 12),
                                     backgroundcolor = "#FFFFFF",
                                     gridcolor = "#000000",
                                     showbackground = TRUE),
                        yaxis = list(title = 'Maturity', 
                                     titlefont = list(size = 15),
                                     tickfont = list(size = 12),
                                     backgroundcolor = "#FFFFFF",
                                     gridcolor = "#000000",
                                     showbackground = TRUE),
                        zaxis = list(title = 'Yield (%)', 
                                     titlefont = list(size = 15),
                                     tickfont = list(size = 12),
                                     backgroundcolor = "#FFFFFF",
                                     gridcolor = "#000000",
                                     showbackground = TRUE),
                        aspectmode = "manual",
                        aspectratio = list(x = aspect, y = 1, z = 1),
                        camera = list(eye = list(x = 1.25, y = -3, z =1.25))))
}
