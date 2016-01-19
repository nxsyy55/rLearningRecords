library(shiny)

shinyUI(fluidPage(

  titlePanel("Test.test, Chinese failed! NO CHINESE!"),

  sidebarLayout(
    sidebarPanel(
    textInput(inputId = 'num1', label = 'Enter the initial number!', value = 'abcde1fghij2klmnopqrst1uvxy'),
    textInput(inputId = 'num2', label = 'Enter the final number!', value = 'pqrst1uvxyabcde1fghij2klmno'),
    textInput(inputId = 'num3', label = 'Enter the MULT.', value = 4)),

    mainPanel(textOutput('number1'),
              textOutput('number2'))
  )
))
