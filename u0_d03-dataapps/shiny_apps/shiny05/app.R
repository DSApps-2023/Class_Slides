library(shiny)
library(glmnet)

res_list <- list()

get_poly_coef <- function(x, y, max_degree = 5) {
  if (length(x) < 20) {
    warning('x length less than 20')
  }
  mm <- model.matrix(~ poly(x, degree = max_degree, raw = TRUE))[, -1]
  cvfit <- cv.glmnet(mm, y)
  c(as.matrix(coef(cvfit, s = "lambda.min")))
}

polynomize <- function(x, y, max_degree = 5) {
  coef <- get_poly_coef(x, y, max_degree)
  mm <- model.matrix(~ poly(x, degree = max_degree, raw = TRUE))
  list(xy = cbind(x, mm %*% coef), formula_ = form_latex(coef, x), coef_ = coef)
}

nice <- function(n) {
  if (abs(n) %% 1 < 0.001) {
    sprintf("%.4f", abs(n))
  } else if (abs(n) %% 1 < 0.01) {
    sprintf("%.3f", abs(n))
  } else if (abs(n) %% 1 < 0.1) {
    sprintf("%.2f", abs(n))
  } else {
    sprintf("%.1f", abs(n))
  }
}

signit <- function(n) ifelse(n > 0, "+", "-")
pass <- function(n, eps = 0.000001) abs(n - 0) >= eps

format_x_range <- function(x) {
  paste0("x\\in(", nice(min(x)), ",\\space", nice(max(x)), ")")
}

form_latex <- function(coef, x) {
  formula_ <- "$$"
  if (length(coef) > 0 && pass(coef[1])) {
    formula_ <- paste0(formula_, nice(coef[1]))
  }
  if (length(coef) > 1 && pass(coef[2])) {
    formula_ <- paste0(formula_, signit(coef[2]), nice(coef[2]), "x")
  }
  if (length(coef) > 2) {
    deg <- 2
    for (co in coef[3:length(coef)]) {
      if (pass(co)) {
        formula_ <- paste0(formula_, signit(co), nice(co), "x^{", deg, "}")
        deg <- deg + 1
      }
    }
  }
  paste0(formula_, ";\\space ", format_x_range(x), "$$")
}

ui <- fluidPage(
  withMathJax(),
  h4("Click on plot to start drawing, click again to pause"),
  fluidRow(
    column(2,
           numericInput("xmin", "xmin", min = -10, max = 0, step = 1, value = 0)),
    column(2,
           numericInput("xmax", "xmax", min = 1, max = 100, step = 1, value = 10)),
    column(2,
           numericInput("ymin", "ymin", min = -10, max = 0, step = 1, value = 0)),
    column(2,
           numericInput("ymax", "ymax", min = 1, max = 100, step = 1, value = 10)),
    column(2,
           numericInput("max_degree", "max degree", min = 1, max = 20, step = 1, value = 5))
  ),
  actionButton("reset", "reset"),
  actionButton("jf", "just formulas"),
  fluidRow(
    column(6,
           plotOutput("plot", width = "500px", height = "500px",
                      hover = hoverOpts(id = "hover", delay = 100, delayType = "throttle", clip = TRUE, nullOutside = TRUE),
                      click = "click")),
    column(6, uiOutput("formulas"))
  )
)

server <- function(input, output, session) {
  vals <- reactiveValues(x = NULL, y = NULL,
                         xpred = NULL, ypred = NULL)
  global_vals <- reactiveValues(x = NULL, y = NULL,
                                xpred = NULL, ypred = NULL)
  formulas_text <- reactiveVal("")
  draw <- reactiveVal(FALSE)
  just_formulas <- reactiveVal(FALSE)
  
  observeEvent(input$click, handlerExpr = {
    temp <- draw(); draw(!temp)
    if(!draw()) {
      global_vals$x <- c(global_vals$x, NA)
      global_vals$y <- c(global_vals$y, NA)
      global_vals$xpred <- c(global_vals$xpred, NA)
      global_vals$ypred <- c(global_vals$ypred, NA)
      output$plot <- renderPlot({
        plot(x = global_vals$x, y = global_vals$y, xlim = c(input$xmin, input$xmax),
             ylim = c(input$ymin, input$ymax), ylab = "y", xlab = "x", type = "l", lwd = 5)
        lines(global_vals$xpred, global_vals$ypred, type = "l", col = 2, lwd = 5)
        if (!draw()) {
          if (!is.null(vals$x) && !is.null(vals$y)) {
            res <- polynomize(vals$x, vals$y, input$max_degree)
            res_list <<- c(res_list, list(res))
            global_vals$xpred <- c(global_vals$xpred, res$xy[, 1])
            global_vals$ypred <- c(global_vals$ypred, res$xy[, 2])
            formulas_text(paste(formulas_text(), res$formula_, sep = " "))
            output$formulas <- renderUI({withMathJax(HTML(formulas_text()))})
            vals$x <- NULL
            vals$y <- NULL
          }
        }
      })
    }})
  
  observeEvent(input$reset, handlerExpr = {
    vals$x <- NULL; vals$y <- NULL
    global_vals$x <- NULL; global_vals$y <- NULL
    global_vals$x_backup <- NULL; global_vals$y_backup <- NULL
    global_vals$xpred <- NULL; global_vals$ypred <- NULL
    formulas_text("")
    res_list <<- list()
  })
  
  observeEvent(input$jf, handlerExpr = {
    if (!just_formulas()) {
      vals$x <- NULL; vals$y <- NULL
      global_vals$x_backup <- global_vals$x; global_vals$y_backup <- global_vals$y
      global_vals$x <- NULL; global_vals$y <- NULL
      just_formulas(TRUE)
      updateActionButton(session, "jf", label = "show all")
    } else {
      global_vals$x <- global_vals$x_backup; global_vals$y <- global_vals$y_backup
      just_formulas(FALSE)
      updateActionButton(session, "jf", label = "just formulas")
    }
  })
  
  observeEvent(input$hover, {
    if (draw()) {
      vals$x <- c(vals$x, input$hover$x)
      vals$y <- c(vals$y, input$hover$y)
      global_vals$x <- c(global_vals$x, input$hover$x)
      global_vals$y <- c(global_vals$y, input$hover$y)
    }})
  
  output$plot <- renderPlot({
    plot(x = global_vals$x, y = global_vals$y, xlim = c(input$xmin, input$xmax),
         ylim = c(input$ymin, input$ymax), ylab = "y", xlab = "x", type = "l", lwd = 5)
  })
}

shinyApp(ui, server)