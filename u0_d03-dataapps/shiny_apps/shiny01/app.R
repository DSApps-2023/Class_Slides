library(shiny)

server <- function(input, output, session) { } 

ui <- basicPage(h1("Wow, what an app."))

shinyApp(ui = ui, server = server)