library(shiny)
library(dplyr)
library(ggplot2)

# UI
ui <- fluidPage(
  titlePanel("Dynamiczne filtrowanie danych z użyciem any_of/all_of"),
  sidebarLayout(
    sidebarPanel(
      selectInput("vars", "Wybierz zmienne:", choices = names(mtcars), multiple = TRUE),
      numericInput("min_value", "Minimalna wartość:", 0),
      actionButton("filter_btn", "Filtruj")
    ),
    mainPanel(
      DT::dataTableOutput("filtered_table")
    )
  )
)

# Server
server <- function(input, output) {
  observeEvent(input$filter_btn, {
    filtered_data <- reactive({
      req(input$vars) # upewniamy się, że co najmniej jedna zmienna została wybrana
      # Używamy any_of, aby uniknąć błędów, jeśli wybrana zmienna nie istnieje
      mtcars %>%
        filter(across(any_of(input$vars), ~ . >= input$min_value))
    })
    
    output$filtered_table <- DT::renderDataTable({
      filtered_data()
    })
  })
}

# Uruchomienie aplikacji
shinyApp(ui, server)
