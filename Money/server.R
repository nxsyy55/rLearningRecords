library(shiny)
library(ggplot2)
library(reshape2)

cal <- function(ini = 3500, len = 10, inc = 500, rate1 = .035, rate2 = 0.033){
  # rate1: the interest rate
  # rate2: the inflation rate
  year <- 1:len
 
  Rate <- rate1 - rate2
  yr.inc <- (year-1) * inc
  annual.incoming <- (ini+yr.inc) * 12 # PVs
  actual.amt <- annual.incoming * (1+Rate)^(0:(len-1)) # Fvs w/ rates  
  
  table <- data.frame(year = year, Annual.incoming = annual.incoming,
                      Act.annual.incoming = actual.amt)
 
  return(table)
}


shinyServer(function(input, output) {

  output$plot <- renderPlot({
    
    data <- melt(cal(input$ini, input$len, input$inc, input$rate1, input$rate2), 'year')
      
    if (input$type == 'Lines') {
      q1 <- ggplot(data = data, aes(x = year , y = value, group = variable, fill = variable, linetype = variable)) + 
           geom_line(lwd = 1.25) + geom_point(size = 5, shape = 21) + theme(legend.position = 'bottom')
      
      q1 <- q1 + scale_x_discrete() + labs(x = 'Year', y = 'Money Amount', fill = NULL, linetype = NULL) 
     
      q1 <- q1 + scale_fill_discrete(labels = c('Without Rates', 'With Rates')) +
            scale_linetype_discrete(labels = c('Without Rates', 'With Rates'))
    
      q1      
    }
    
    else {
      q1 <- ggplot(data = data, aes(x = as.factor(year), y = value, fill = variable)) + 
            geom_bar(pos = 'dodge', stat="identity", col = 'black') + theme(legend.position = 'bottom')
      q1 + labs(x = 'Year', y = 'Money Amount', fill = NULL) + scale_fill_discrete(labels = c('Without Rates', 'With Rates'))
    
    }
  })
  
  output$table <- renderTable(include.rownames = F, {
    data <- cal(input$ini, input$len, input$inc, input$rate1, input$rate2)
    data
  })
  
  output$table2 <- renderTable(include.rownames = F, {
    data <- cal(input$ini, input$len, input$inc, input$rate1, input$rate2)
    table <- data.frame(Lifetime.earned.with.rates = sum(data$Act.annual.incoming),
                        Lifetime.earned.without.rates = sum(data$Annual.incoming),
                        Total.worktime = dim(data)[1])
    table$Difference <- table[,1] - table[,2]
    table
  })

})
