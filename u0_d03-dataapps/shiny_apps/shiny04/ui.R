library(shiny)

ui <- fluidPage(
  
  titlePanel("Wow, what an app."),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput(inputId = "slider1",
                  label = "Slider options",
                  min = 1, max = n_mtcars, value = 30, step = 1),
      actionButton("button", "Update"),
      textInput("text", "Write something", value = "Something"),
      radioButtons("radio", "Choose a single option:",
                   choices = c("a", "b", "c"),
                   selected = "b")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Tab",
                 basicPage(
                   column(6,
                          fileInput("file", "Choose a file:", accept = ".csv"),
                          uiOutput("col1"),
                          uiOutput("col2")
                   ),
                   column(6,
                          plotOutput("plot"))
                 )
        ), 
        tabPanel("Tabby"), 
        tabPanel("Tabula")
      )
    )
  )
)
