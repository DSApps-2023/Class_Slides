library(shiny)

ui <- basicPage(h1("Wow, what an app."))

server <- function(input, output, session) { } 

shinyApp(ui = ui, server = server)