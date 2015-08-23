mortgage <- function(loan_amount=500000, apr=8, biweekly=FALSE) { 
  if (biweekly) {
    i <- apr/100
    z30 <- (1 + i/26)^780
    z15 <- (1 + i/26)^390
    payment_30years <- (i/26)*loan_amount*z30/(z30-1)
    payment_15years <- (i/26)*loan_amount*z15/(z15-1)
    interest_30years <- (payment_30years * 780) - loan_amount
    interest_15years <- (payment_15years * 390) - loan_amount
  } else {
    i <- apr/(12 * 100)
    payment_30years <- loan_amount * i / (1 - (1 + i)^(-360))
    payment_15years <- loan_amount * i / (1 - (1 + i)^(-180))
    interest_30years <- (payment_30years * 360) - loan_amount
    interest_15years <- (payment_15years * 180) - loan_amount
  }
  savings <- interest_30years - interest_15years
  result <- list(
    payment_30years=payment_30years,
    payment_15years=payment_15years,
    interest_30years=interest_30years,
    interest_15years=interest_15years,
    savings=savings,
    payment_frequency=ifelse(biweekly,"Biweekly","Monthly")
  )
  return(result)
}

shinyServer(
function(input, output){
  x <- reactive({mortgage(input$in1, input$in2, input$in3)})

  output$total_savings <- renderText({
    paste("$", formatC(x()$savings, format="d", big.mark=','))
  })

  output$payment <- renderPlot({
    par(mfrow=c(1,2))
    bp1<-barplot(c(x()$payment_30years,x()$payment_15years),
            names.arg=c("30-year","15-year"),
            col=c("yellow", "green"),
            ylim=c(0,6000),
            main=paste("Fig. 1 - ", x()$payment_frequency,"Payment Amount",sep=" "),
            ylab=paste(x()$payment_frequency,"Payment Amount (Dollars)",sep=" "),
            xlab="Mortgage Type")
    text(x=bp1, y=0, pos=3, xpd=TRUE,
         labels=c(paste("$", as.character(round(x()$payment_30years), digits=2)),
                  paste("$", as.character(round(x()$payment_15years), digits=2))))
    bp2<-barplot(c(x()$interest_30years/1000,x()$interest_15years/1000), 
            names.arg=c("30-year","15-year"),
            col = c("yellow", "green"),
            ylim=c(0,1000),
            main="Fig. 2 - Total Interest Paid",
            ylab="Total Interest (Dollars in Thousands)",
            xlab="Mortgage Type")
    text(x=bp2, y=0, pos=3, xpd=TRUE,
         labels=c(paste("$", as.character(round(x()$interest_30years), digits=2)),
                  paste("$", as.character(round(x()$interest_15years), digits=2))))
  })
})
