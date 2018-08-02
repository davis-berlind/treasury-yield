library(rvest)
library(plotly)

# Set year
year <- 2018

# Current month only?
current_month <- FALSE

# create URL to US Treasury website
url <- ifelse(current_month,
              "https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yield",
              paste0("https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldYear&year=",year)
              )

# read HTML code
download.file(url, destfile = "scrapedpage.html", quiet=TRUE)
content <- read_html("scrapedpage.html")

# scrape yield data
yield_data_html <- html_nodes(content,'th , .text_view_data')

# convert to text
yield_data <- html_text(yield_data_html)

# initialize df of dates and yields
yields <- data.frame(matrix(nrow = 0, ncol = 12))
names(yields) <- yield_data[1:12]

# fill df with data
rows <- length(yield_data[13:length(yield_data)])/12

for (i in 1:rows){
  yields[i,] <- yield_data[(12*i)+1:(12*(i+1))]
}

# convert text to dates
yields$Date <- as.Date(yields$Date, format = "%m/%d/%y")

# convert yields to numeric
yields[,2:ncol(yields)] <- apply(yields[,2:ncol(yields)],2,as.numeric)

# find largest/smallest date/yield to set bounds for plot
minmax <- data.frame(matrix(ncol = 2))
names(minmax) <- c("date", "rate")
minmax$date <- as.Date(minmax$date)
minmax[1,1] <- min(yields$Date)
minmax[1,2] <- min(yields[,2:ncol(yields)])
minmax[2,1] <- max(yields$Date)
minmax[2,2] <- max(yields[,2:ncol(yields)])

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
