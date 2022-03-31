yield_scraper <- function(){
  # # URL to US Treasury website
  # url <- "https://www.treasury.gov/resource-center/data-chart-center/interest-rates/Pages/TextView.aspx?data=yieldAll"
  # 
  # # get table header
  # maturities <- url %>% 
  #   read_html() %>% 
  #   html_nodes('th') %>% 
  #   html_text()
  # 
  # # scraping yield data
  # yield_data <- url %>%
  #   read_html() %>% 
  #   html_nodes('.text_view_data') %>% 
  #   html_text()
  # 
  # # reparing NAs
  # yield_data[grepl("N/A", yield_data)] <- NA
  # 
  # # making data.frame of yields
  # yield_data <- yield_data %>% 
  #   matrix(ncol = length(maturities), byrow = TRUE) %>% 
  #   data.frame(stringsAsFactors = FALSE)
  # names(yield_data) <- maturities
  # yield_data <- yield_data %>% 
  #   mutate_at(vars(-Date), ~as.numeric(.)) %>% 
  #   mutate(Date = as.Date(Date, format = "%m/%d/%y"))
  
  link <- url("https://home.treasury.gov/resource-center/data-chart-center/interest-rates/daily-treasury-rates.csv/all/all?type=daily_treasury_yield_curve&field_tdr_date_value=all&page&_format=csv")
  yield_data <- read.csv(link) %>% 
    rename_all(~gsub("X", "", .)) %>% 
    rename_all(~gsub("\\.", " ", .)) %>% 
    mutate(Date = as.Date(Date, format = "%m/%d/%Y"))
  
  return(yield_data)
}