library(shiny)
shinyUI(
  fluidPage(
    titlePanel("Mortgage Savings Calculator"),
    sidebarLayout(
      sidebarPanel(
        h4("Input Controls:"),
        br(),
        numericInput("in1", "1. Loan Amount in Dollars", min=10000, max=1000000, value=500000, step=10000),
        br(),
        sliderInput("in2", "2. Interest Rate (APR)", min=1,  max=10, value=8.0, step=0.25, post="%", animate=TRUE),
        br(),
        radioButtons("in3", "3. Payment Frequency", c("Monthly"=FALSE,"Biweekly"=TRUE), selected = NULL, inline = FALSE),
        br(), hr(),
        h1("Total Savings:", tags$span(textOutput("total_savings"), style="color:red"), style="font-weight:bold")
      ),
      mainPanel(
        p(HTML("<strong>Description:</strong> Pay off your mortgage early to save money by paying less interest!
                This calculator shows your total savings when you pay off your mortgage in 15 years instead of 30 years.
                Your monthly or biweekly payment will be higher, as shown in Figure 1, but the total interest paid
                over the life of the loan will be much lower, as show in Figure 2. Your total savings are shown in red.")),
        p("Instructions:", style="font-weight: bold"),
        tags$div(
          tags$ol(
            tags$li("Enter your loan amount in dollars."),
            tags$li("Select the loan interest rate using the slider."),
            tags$li("Select Monthly or Biweekly payment frequency.")
          )
        ),
        plotOutput("payment")
      )
    )
  )
)