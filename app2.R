library(shiny)

ui <- fluidPage(
    numericInput("a", "a", value = 10),
    numericInput("b", "b", value = 1),
    numericInput("c", "c", value = 1),
    plotOutput("x"),
    tableOutput("y"),
    textOutput("z")
  )

server <- function(input, output, session) {
  rng <- reactive(input$a * 2)
  smp <- reactive(sample(rng(), input$b, replace = TRUE))
  bc <- reactive(input$b * input$c)
  
  output$x <- renderPlot(hist(smp()))
  output$y <- renderTable(max(smp()))
  output$z <- renderText(bc())
}

shinyApp(ui, server)