library(shiny)

shinyServer(function(input, output) {

  
  
  
  output$number1 <- renderText({input$num1})
  output$number2 <- renderText({input$num2})
})
result <- c()
for (i in 1:2.5e+10){
  a <- i
  b <- 2.5e+10
  result[i] <- b/a
}