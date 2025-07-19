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

  yield <- read.csv("yield_data.csv") %>%
    rename_all(~gsub("X", "", .)) %>%
    rename_all(~gsub("\\.([A-Z])", " \\1", .)) %>%
    mutate(Date = as.Date(Date)) %>%
    arrange(Date)

  max_yr <- lubridate::year(max(yield$Date))
  years <- (max_yr + 1):lubridate::year(Sys.time())

  for (year in years) {
    link <- url(paste0("https://home.treasury.gov/resource-center/data-chart-center/interest-rates/daily-treasury-rates.csv/",
                       year,
                       "/all?type=daily_treasury_yield_curve&field_tdr_date_value=",
                       year,
                       "&page&_format=csv"))

    yield_new <- read.csv(link) %>%
      rename_all(~gsub("X", "", .)) %>%
      rename_all(~gsub("Month", "Mo", .)) %>%
      rename_all(~gsub("Year", "Yr", .)) %>%
      rename_all(~gsub("\\.([A-Z])", " \\1", .)) %>%
      mutate(Date = as.Date(Date, format = "%m/%d/%Y")) %>%
      arrange(Date)

    all_cols <- c("Date",
                  all_cols[grepl("Mo",all_cols)][order(as.numeric(gsub(" Mo", "", all_cols[grepl("Mo",all_cols)])))],
                  all_cols[grepl("Yr",all_cols)][order(as.numeric(gsub(" Yr", "", all_cols[grepl("Yr",all_cols)])))])
    for (col in setdiff(all_cols, names(yield))) yield[[col]] <- NA
    for (col in setdiff(all_cols, names(yield_new))) yield_new[[col]] <- NA

    yield <- rbind(yield[all_cols],yield_new[all_cols])
  }

  return(yield)
}
