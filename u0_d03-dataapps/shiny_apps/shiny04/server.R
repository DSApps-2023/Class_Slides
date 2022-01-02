library(shiny)
library(tidyverse)

server <- function(input, output) {
  rv <- reactiveValues(
    plot = NULL,
    data = mtcars
  )
  
  observeEvent(input$file, {
    rv$data <- read_csv(input$file$datapath)
  })
  
  observeEvent(
    input$button, {
      col1 <- input$col1
      col2 <- input$col2
      
      rv$plot <- ggplot(rv$data %>% slice(1:input$slider1)) +
        aes_string(col1, col2) + geom_point(size=5) +
        labs(title = input$text) +
        theme_light()
    }
  )
  output$plot <- renderPlot({
    if (is.null(rv$plot)) return()
    rv$plot
  })
  
  output$col1 <- renderUI({
    selectInput("col1", "Select X var:", colnames(rv$data))
  })
  
  output$col2 <- renderUI({
    selectInput("col2", "Select Y var:", colnames(rv$data))
  })
}
