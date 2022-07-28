library(shiny)
library(data.table)
library(spotifyr)
library(tidyverse)
library(knitr)
library(devtools)
library(caret)
library(class)

## loading dataframes

data_label_target <- read_csv("https://github.com/Muhammadzaryab22/Artistrecommender/blob/main/datalabel.csv")
mldataframest <- read_csv("https://github.com/Muhammadzaryab22/Artistrecommender/blob/main/mldataframest.csv")


## User interface

ui <- pageWithSidebar(
  
  ## Page header
  
  headerPanel('Artist Recommender'),
  
  # Input values
  sidebarPanel(
    #HTML("<h3>Input parameters</h3>"),
    tags$label(h3('Input parameters')),
    numericInput("tempo", 
                 label = "tempo", 
                 value = 140),
    numericInput("popularitymean", 
                 label = "popularitymean", 
                 value = 50),
    numericInput("keymode", 
                 label = "keymode", 
                 value = 1),
    
    
    actionButton("submitbutton", "Submit", 
                 class = "btn btn-primary")
  ),
  
  mainPanel(
    tags$label(h3('Status/Output')), # Status/Output Text Box
    verbatimTextOutput('contents'),
    tableOutput('tabledata') # Prediction results table
    
  )
)

# Server                           #
####################################
set.seed(123)
server<- function(input, output, session) {
  
  # Input Data
  datasetInput <- reactive({  
    
    df <- data.frame(
      Name = c("tempo",
               "popularitymean",
               "keymode"),
      Value = as.numeric(c(((input$tempo-130.9652)/21.80103),
                           ((input$popularitymean-53.77677)/8.502132),
                           ((input$keymode-11.46453)/6.867353))),
      stringsAsFactors = FALSE)
    
    
    ###  Standardize inputs df so that it can go through the model
    
    df2 <- transpose(df)
    
    write.table(df2,"df2.csv", sep=",", quote = FALSE, row.names = FALSE, col.names = FALSE)
    
    test1 <- read.csv(paste("df2", ".csv", sep=""), header = TRUE)
set.seed(123)
    Output <- data.frame(Prediction= knn(mldataframest, test1, cl= data_label_target, k=1))
    print(Output)
    
  })
  
  # Status/Output Text Box
  output$contents <- renderPrint({
    if (input$submitbutton>0) { 
      isolate("Calculation complete.") 
    } else {
      return("Server is ready for calculation.")
    }
  })
  
  # Prediction results table
  output$tabledata <- renderTable({
    if (input$submitbutton>0) { 
      isolate(datasetInput()) 
    } 
  })
  
}

shinyApp(ui = ui, server = server)
