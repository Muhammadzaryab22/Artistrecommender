library(shiny)
library(data.table)
library(spotifyr)
library(tidyverse)
library(knitr)
library(devtools)
library(caret)
library(class)



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
