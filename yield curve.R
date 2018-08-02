library(rvest)
library(plotly)

# current month only?
current_month <- FALSE

# set year
years <- seq(2017,2018)

# create URL to US Treasury website for current month if current month is set to TRUE
if (current_month) {
  url <- "https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield"
  
  # read HTML code
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
  content <- read_html("scrapedpage.html")
  
  # scrape yield data
  yield_data_html <- html_nodes(content,'.text_view_data')
  
  # convert to text
  yield_data <- html_text(yield_data_html)
  
  # initialize df of dates and yields
  yields <- data.frame(matrix(nrow = 0, ncol = 12))
  
  # creating names for yields df
  maturities_html <- html_nodes(content,'th')
  maturities <- html_text(maturities_html)
  names(yields) <- maturities
  
  # calculate number of rows for yields df
  rows <- length(yield_data)/12
  
  # fill yields df with data (with bug fix for first day of the month)
  if (rows > 1){
    for (i in 0:rows-1){
      yields[i+1,] <- yield_data[(12*i)+1:(12*(i+1))]
    } 
  } else {
    yields[1,] <- yield_data
  }  
} else {
  
  # initialize yields df
  yields <- data.frame(matrix(nrow = 0, ncol = 12))
  
   # scrape names names for yields df
  url <- paste0("https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldYear&year=",years[1])
  download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
  content <- read_html("scrapedpage.html")
  maturities_html <- html_nodes(content,'th')
  maturities <- html_text(maturities_html)
  names(yields) <- maturities
  
  # scrape yield data for each year in "years"
  for (i in seq_along(years)){
    
    # create URL to US Treasury website
    url <- paste0("https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldYear&year=",years[i])
    
    # read HTML code
    download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
    content <- read_html("scrapedpage.html")
    
    # scrape yield data
    yield_data_html <- html_nodes(content,'.text_view_data')
    
    # convert to text
    yield_data <- html_text(yield_data_html)
    
    # save yields and dates to df for year i in years
    yields_temp <- data.frame(matrix(nrow = 0, ncol = 12))
    
    # calculate number of rows for year i yields df
    rows <- length(yield_data)/12
    
    # fill year i yields df with data
    for (j in 0:(rows-1)){
      yields_temp[j+1,] <- yield_data[(12*j)+1:(12*(j+1))]
      } 
    
    # rename year i yields df
    names(yields_temp) <- maturities
    
    # save year i yields data to master yields df
    yields <- rbind(yields, yields_temp)
  }
}

# convert text to dates
yields$Date <- as.Date(yields$Date, format = "%m/%d/%y")

# convert yields to numeric
yields[,2:ncol(yields)] <- apply(yields[,2:ncol(yields)],2,as.numeric)

# find largest/smallest date/yield to set bounds for plot
minmax <- data.frame(matrix(ncol = 2))
names(minmax) <- c("date", "rate")
minmax$date <- as.Date(minmax$date)
minmax[1,1] <- min(yields$Date, na.rm = TRUE)
minmax[1,2] <- min(yields[,2:ncol(yields)], na.rm = TRUE)
minmax[2,1] <- max(yields$Date, na.rm = TRUE)
minmax[2,2] <- max(yields[,2:ncol(yields)], na.rm = TRUE)

#### 2D Plot ####

# initialize plot
plot(minmax$date,minmax$rate, 
     col = "white", 
     xlab = "Date", 
     ylab = "Yield", 
     main = ifelse(current_month, 
                   paste(format(Sys.Date(), format="%B %Y"), "Treasury Yields \nas of", format(max(yields$Date), format="%B %d")),
                   paste(year, "Treasury Yields \nas of", format(max(yields$Date), format="%B %d")))
    )

# set colors
color_list <- terrain.colors(ncol(yields)-1)
color_list[length(color_list)] <- "gray"

# plot yields
for (i in 2:ncol(yields)){
  lines(yields$Date,yields[,i], col = color_list[i-1], lwd = 2)
}

legend(ifelse(current_month,"center","bottomright"), 
       inset = 0.01, 
       ncol = 3, 
       legend = rev(names(yields)[2:ncol(yields)]), 
       col = rev(color_list), 
       lty = 1, 
       cex = .65, 
       lwd = 2)

#### 3D Plot ####
x = yields$Date
y = names(yields)[2:ncol(yields)]
z = t(data.matrix(yields[,2:ncol(yields)]))

plot_ly(x = x, y = y, z = z, type = "surface")
