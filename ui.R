# Financial Forecasting Tool
# Marc Boulet, 2017-06-25
# Coursera: Developing Data Products, Week 4

# Define UI for application that plots financial data
shinyUI(fluidPage(
  
# Application title
  titlePanel("Financial Index Forecasting Tool"),
  
# Sidebar with radio button, slider, numeric and checkbox inputs 
  sidebarLayout(
    sidebarPanel(
            radioButtons("finset", "Select Financial Index:",
                        c("Dow Jones Industrial Average (USA)" = "dji",
                          "Standard & Poors 500 (USA)" = "sp500",
                          "Toronto Stock Exchange (Canada)" = "tse"
                          )),
            
           sliderInput("sliderYears", "Pick date range as input for forecast:",
                        1950, 2017, value = c(1990, 2010), sep = ""),
           numericInput("Months", "Number of Months to forecast:", 
                         value = 36, min = 6, max = 120, step = 6),
           sliderInput("ConfInts", "Forecast confidence intervals:",
                        1, 99, value = c(80, 95)),
           checkboxInput(inputId = "zoom", "Plot zoom", value = FALSE)
    ),
    
# Show two tabs, one with documentation, another a plot of the selected financial index
    mainPanel(
       tabsetPanel(
                tabPanel("Documentation", helpText("This app is designed to let you perform both
                        historical and future forecasts, using the forecast package, on three different
                        financial datasets. First, select a financial index, then choose a date range that
                        will be used as input for the forecast. Finally, select the number of months to
                        forecast. The forecast shows up as a blue line. You can adjust the two confidence
                        intervals (coloured light blue and gray) with the bottom slider bar. Click on 
                        Plot zoom to get a closer view. See if you can find a time in which the forecast
                        package cannot predict the future, even within a 95% confidence interval.")),
                tabPanel("Plot", plotOutput("data.plot", height ="500px"))
    )
  )
)))
