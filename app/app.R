#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(bslib)
library(ggplot2)
library(AmesHousing)

ames <- make_ames()

# Define UI for application 
ui <- page_sidebar(
  sidebar=sidebar(
    selectInput(
      inputId="neighborhood",
      label="Neighborhood",
      choices=c(
        "North Ames"="NAmes",
        "Edwards"="edwards",
        "Brookside"="Brkside"
      ),
      selected="Names"
    )
  ),
  card(
    plotOutput(outputId = "scatterplot")
  )
)

# Define server logic required to render output
server <- function(input, output) {
  output$scatterplot <- renderPlot({
    ggplot(data=ames, aes_string(x=input$sqft, y=input$price)) +
      geom_point(method="lm")
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
