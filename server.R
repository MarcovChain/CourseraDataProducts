# Financial Forecasting Tool
# Marc Boulet, 2017-06-25
# Coursera: Developing Data Products, Week 4

# load required libraries
library(shiny)
library(readr)
library(forecast)
library(zoom)

# load monthly Dow Jones Index, S&P500 and TSE data & convert to time series
# data source: https://finance.yahoo.com/

dji <- read_csv("DJImonthly.csv", 
                col_types = cols(Date = col_skip()))
dji.ts <- ts(dji, start=c(1985,2), end=c(2017,6), frequency = 12)

sp500 <- read_csv("SPCmonthly.csv", 
                  col_types = cols(Date = col_skip()))
sp500.ts <- ts(sp500, start=c(1950,2), end=c(2017,6), frequency = 12)

tse <- read_csv("TSEmonthly.csv", 
                  col_types = cols(Date = col_skip()))
tse.ts <- ts(tse, start=c(1979,7), end=c(2017,6), frequency = 12)

# define server logic to plot financial data
shinyServer(function(input, output) {
        
# subset time series to use as forecast input
        data.subset <- reactive({
                if(input$finset == "dji") {
                               data.ts <-  ts(dji, start=c(1985,2), end=c(2017,6), frequency = 12)
                        }
                if(input$finset == "sp500") {
                           data.ts <-  ts(sp500, start=c(1950,2), end=c(2017,6), frequency = 12)
                }
                if(input$finset == "tse") {
                        data.ts <-  ts(tse, start=c(1979,7), end=c(2017,6), frequency = 12)
                }
                window(data.ts, input$sliderYears[1], input$sliderYears[2])
        })
        
# plotting function     
  output$data.plot <- renderPlot({
        minYear <- input$sliderYears[1]
        maxYear <- input$sliderYears[2]
        numMonths <- input$Months
        ConfIntsmall <- input$ConfInts[1]
        ConfIntlarge <- input$ConfInts[2]
        data.zoom <- max(data.subset())
# conditional statements used to load appropriate financial index
        if(input$finset == "dji") {
                data.ts <-  ts(dji, start=c(1985,2), end=c(2017,6), frequency = 12)
                minX <- 1985
        }
        if(input$finset == "sp500") {
                data.ts <-      ts(sp500, start=c(1950,2), end=c(2017,6), frequency = 12)
                minX <- 1950
        }
        if(input$finset == "tse") {
                data.ts <-      ts(tse, start=c(1979,7), end=c(2017,6), frequency = 12)
                minX <- 1979
        }
# plot the subset data using a thick red line
        plot(data.subset(), xlim=c(minX,2018), ylim=c(0,max(data.ts)), lwd =3, col="red", ann=FALSE) + 
                title(main="Financial Index Forecast", xlab="Year", ylab="Monthly Close")
        par(new=T)
          
# plot forecast data, with user-selectable forecast length & confidence intervals
        plot(forecast(data.subset(), h=numMonths, level = c(ConfIntsmall, ConfIntlarge)),
                xlim=c(minX,2018), ylim=c(0,max(data.ts)), ann=FALSE)
        par(new=T)
        
# plot entire financial index data using thin black line  
        plot(data.ts, xlim=c(minX,2018), ylim=c(0,max(data.ts)), ann=FALSE) + grid()
          
# zoom function  
        if(input$zoom) {
                  zoomplot.zoom(fact=1.5, x= maxYear, y= data.zoom)
        }
    
  })
  
})
