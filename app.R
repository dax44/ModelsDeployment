library(shiny)

# Definicja interfejsu użytkownika (UI)
ui <- fluidPage(
  titlePanel("Licznik Znaków"),
  textInput("tekst_input", "Wprowadź tekst:"),
  textOutput("licznik_wynik")
)

# Definicja serwera
server <- function(input, output) {
  # Obserwator reagujący na zmiany w tekście wprowadzonym przez użytkownika
  observe({
    # Sprawdzamy, czy pole tekstowe nie jest puste
    if (is.null(input$tekst_input) || input$tekst_input == "") {
      output$licznik_wynik <- renderText({
        "Wprowadź tekst, aby zobaczyć liczbę znaków."
      })
      return()
    }
    
    # Pobieramy tekst z pola tekstowego
    wprowadzony_tekst <- input$tekst_input
    
    # Obliczamy liczbę znaków w tekście
    liczba_znakow <- nchar(wprowadzony_tekst)
    
    # Aktualizujemy wynik w interfejsie
    output$licznik_wynik <- renderText({
      paste("Liczba znaków: ", liczba_znakow)
    })
  })
}

# Uruchomienie aplikacji Shiny
shinyApp(ui, server)
