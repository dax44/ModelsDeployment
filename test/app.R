library(shiny)
library(reactable)

ui <- fluidPage(
    reactableOutput("table")
)
server <- function(input, output, session) {
    output$table <- renderReactable({
        reactable(mtcars,
                  sortable = FALSE,
                  filterable = FALSE,
                  searchable = FALSE,
                  defaultPageSize = 5)
    })
}

shinyApp(ui, server)