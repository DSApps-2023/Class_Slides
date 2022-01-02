library(shiny)
library(tidyverse)

server <- function(input, output) {
  observeEvent(
    input$slider1, {
      output$plot <- renderPlot(
        ggplot(mtcars %>% slice(1:input$slider1)) +
          aes(mpg, hp) + geom_point(size=5) +
          theme_light() +
          title(main = "mtcars")
      )
    }
  )
}
