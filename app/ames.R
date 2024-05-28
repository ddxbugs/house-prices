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

ames <- read.csv("data/train.csv")

# Define UI for application 
ui <- page_sidebar(
  title="Century 21 Ames Housing Market Analysis",
  sidebar=sidebar(
    selectInput(
    inputId="neighborhood",
    label="Neighborhood",
    choices=c(
      "North Ames"="NAmes",
      "Edwards"="Edwards",
      "Brookside"="BrkSide"
      ),
    selected="Names"
    ),
    checkboxGroupInput(
      inputId="checkGroup",
      "Log Transformation",
      choices=list("X-axis"="X", "Y-axis"="Y"),
    )
  ),
  card(
    card_header("Variable Selection"),
    textOutput("selected_var"),
    style = "height: 100px;"
    )
  ,
  card(
    card_header("Plot Visualization"),
    plotOutput(outputId = "scatterplot"),
  )
)

# Define server logic required to render output
server <- function(input, output) {
  output$selected_var <- renderText({
    paste("log(", input$checkGroup, ")")
  })
  output$scatterplot <- renderPlot({
    ames_subset <- subset(ames, Neighborhood==input$neighborhood)
    if ("X" %in% input$checkGroup) ames_subset$GrLivArea <- log(ames_subset$GrLivArea)
    if ("Y" %in% input$checkGroup) ames_subset$SalePrice <- log(ames_subset$SalePrice)
    ggplot(data=ames_subset, aes(x=GrLivArea, y=SalePrice)) +
      geom_point() +
      geom_smooth(method="lm") +
      ggtitle("Scatter plot: Sale Price (USD) vs. Living Area (sqft)") +
      labs(x = if ("X" %in% input$checkGroup) "Log(GrLivArea)" else "GrLivArea",
           y = if ("Y" %in% input$checkGroup) "Log(SalePrice)" else "SalePrice",
           subtitle = paste(ames_subset$Neighborhood, ", n =", nrow(ames_subset)))
  })
}

# Run the application 
shinyApp(ui = ui, server = server)
