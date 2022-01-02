library(shiny)

options_list <- c("R", "Python", "Go")

server <- function(input, output) {}

ui <- fluidPage(

    titlePanel("Wow, what an app."),

    sidebarLayout(
      sidebarPanel(
        sliderInput(inputId = "slider1",
                    label = "Slider options",
                    min = 1, max = 50, value = 30),
        actionButton("button", "Update"),
        textInput("text", "Write something"),
        radioButtons("radio", "Choose a single option:",
                     choices = c("a", "b", "c"),
                     selected = 2)
        ),

        mainPanel(
          tabsetPanel(
            tabPanel("Tab",
                     checkboxGroupInput("checkbox", "Check me:",
                                        choices = options_list),
                     fileInput("file", "Choose a file:"),
                     selectInput("dropdown", "Select:", options_list)
                     ), 
            tabPanel("Tabby"), 
            tabPanel("Tabula")
          )
        )
    )
)

shinyApp(ui = ui, server = server)
