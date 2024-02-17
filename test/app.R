library(shiny)

ui <- fluidPage(
  titlePanel("Wyświetlanie obrazów w Shiny"),
  selectInput("imageChoice", "Wybierz obraz:", choices = c("Screen 1", "Screen 2")),
  imageOutput("selectedImage")
)

server <- function(input, output) {
  output$selectedImage <- renderImage({
    # Ścieżki do obrazów
    imagePath <- switch(input$imageChoice,
                        "Screen 1" = "~/Desktop/Pollub/wyklady/ModelDeployment/images/Zrzut ekranu 2024-01-20 o 16.41.52.png",
                        "Screen 2" = "~/Desktop/Pollub/wyklady/ModelDeployment/images/Zrzut ekranu 2024-01-20 o 16.43.24.png")
    
    # Zwracanie listy z informacjami o obrazie
    list(src = imagePath,
         contentType = "image/jpeg",
         width = 400, # Można dostosować
         height = "auto")
  }, deleteFile = FALSE) # Ustawienie na FALSE, jeśli obrazy nie są tymczasowe
}

shinyApp(ui = ui, server = server)