library(shiny)
library(vroom)
library(janitor)

# UI
ui <- fluidPage(
  titlePanel("Przetwarzanie i pobieranie danych"),
  
  # Upload i parsowanie pliku
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Wybierz plik danych", accept = ".csv"),
      textInput("delim", "Separator (domyślnie ,)", value = ","),
      numericInput("skip", "Pomiń wiersze", 0),
      numericInput("rows", "Podgląd wierszy", 5),
      checkboxInput("snake", "Nazwy kolumn do snake_case"),
      checkboxInput("constant", "Usuń kolumny stałe"),
      checkboxInput("empty", "Usuń puste kolumny"),
      downloadButton("download", "Pobierz przetworzone dane")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Podgląd surowych danych", tableOutput("preview_raw")),
        tabPanel("Podgląd oczyszczonych danych", tableOutput("preview_clean"))
      )
    )
  )
)

# Server
server <- function(input, output) {
  # Odczytanie i podgląd surowych danych
  data_raw <- reactive({
    req(input$file)
    read.csv(input$file$datapath, sep = input$delim, skip = input$skip)
  })
  
  output$preview_raw <- renderTable({
    head(data_raw(), n = input$rows)
  })
  
  # Oczyszczanie danych
  data_clean <- reactive({
    df <- data_raw()
    if (input$snake) {
      df <- df %>% janitor::clean_names(case = "snake")
    }
    if (input$constant) {
      df <- df %>% janitor::remove_constant()
    }
    if (input$empty) {
      df <- df %>% janitor::remove_empty("cols")
    }
    df
  })
  
  output$preview_clean <- renderTable({
    head(data_clean(), n = input$rows)
  })
  
  # Pobieranie oczyszczonych danych
  output$download <- downloadHandler(
    filename = function() {
      paste(Sys.Date(), "-clean-data.csv", sep = "")
    },
    content = function(file) {
      write.csv(data_clean(), file, row.names = FALSE)
    }
  )
}

# Uruchomienie aplikacji
shinyApp(ui = ui, server = server)
