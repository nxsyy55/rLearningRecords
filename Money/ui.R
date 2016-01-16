
library(shiny)

shinyUI(fluidPage(

  fluidPage(
    fluidRow(
      column(8, plotOutput('plot')),
      column(4, tableOutput('table'))
    ),
    hr(),
    fluidRow(
      
      column(2, h4('Basic Control', align = 'center'),
             
             numericInput('ini', 'Enter your initial monthly salary', value = 3500, min = 0),
             numericInput('len', 'Enter your length of the years', value = 10, min = 0),
             numericInput('inc', 'Enter the annual increment of your salary', value = 500,
                          min = 0),
             br(),
             submitButton("Submit")
            ),
      
      column(2, h4('Advanced Control', align = 'center'),
             numericInput('rate1', 'Enter the interest rate', value = .035, min = 0, max = 1, step =.001),
             numericInput('rate2', 'Enter the inflation rate', value = .033, min = 0, max = 1, step = .001),
             selectizeInput('type', 'You can select the plot type here ( Bars or Lines).', choices = list('Bars', 'Lines')),
             br(),
             submitButton("Submit")
      ),
      
      column(8,
             
             helpText(h4('How to use this calculator', align = 'center'),
                      br(),
                      helpText('This calculator is designed to calculate the total money you can earn in your work period.'),
                      helpText('Just follow the description and enter your number.'),
                      strong('This is only a naive approach! Do not take it serious. Nothing is linear in real world!'),
                      helpText('If you do not understand what the interest rate and inflation rate do here, ignore them OR set them zero.'),
                      helpText('The formulas: n is the year number, B is your initial salary, I is the increment and, R is the net rate (interest - inflation)'),
                      withMathJax(p("$$12 \\cdot (B+I\\cdot(n-1))\\cdot(1+R^{n-1})$$")),
             hr(),
             h3('Summary', align = 'center'),
             tableOutput('table2')          
            )
      
    )
  ) ) 
))