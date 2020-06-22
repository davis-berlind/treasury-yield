yield_scraper <- function(){
  # URL to US Treasury website
  url <- "https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldAll"
  
  # get table header
  maturities <- url %>% 
    read_html() %>% 
    html_nodes('th') %>% 
    html_text()
  
  # scraping yield data
  yield_data <- url %>%
    read_html() %>% 
    html_nodes('.text_view_data') %>% 
    html_text()
  
  # reparing NAs
  yield_data[grepl("N/A", yield_data)] <- NA
  
  # making data.frame of yields
  yield_data <- yield_data %>% 
    matrix(ncol = length(maturities), byrow = TRUE) %>% 
    data.frame(stringsAsFactors = FALSE)
  names(yield_data) <- maturities
  yield_data <- yield_data %>% 
    mutate_at(vars(-Date), ~as.numeric(.)) %>% 
    mutate(Date = as.Date(Date, format = "%m/%d/%y"))
  
  return(yield_data)
}