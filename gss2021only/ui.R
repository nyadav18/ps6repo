#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)

#data_2021 <- data_2021 <- read.csv("~/INFO201/ps6repo/data/gss2021.csv")
#smaller_data <- select(data_2021, NATENVIR, RELIG, IMMLIMIT, SEXNOW1)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    titlePanel("US Religious Environment"),

    tabsetPanel(
      tabPanel("About", 
               # add formatting markers!!
               h1("General Social Survey 2021"),
               p("The data here was collected by ", em("NORC"), "and was put together
                    through the admission of a comprehensive survey on a variety of
                    topics. For our purposes we will be examining the ", 
                    strong("variables related to religion"), "and other possibly 
                    correlated issues."), 
               p("This subsetted dataset contains 4032 observations and 4 
                  variables")
      ),
      tabPanel("Plot",
               sidebarLayout(
                 sidebarPanel(
                   selectInput("religious", "Select religiosity:", choices = 
                                 c("Religious", "Nonreligious")),
                   selectInput("variable", "Variable to Display:",
                               choices = c("Gender", "Immigration", 
                                           "Environment")),
                   radioButtons("color", "Pick a color:",
                                choices = c("Red", "Green", "Blue"),
                                selected = "Red")
                 ),
                 mainPanel(
                   plotOutput("barplot"),
                   textOutput("labels")
                 )
               )
      ),
      tabPanel("Table",
               sidebarLayout(
                 sidebarPanel(
                   selectInput("column", "What column would you like to
                                examine?",
                                choices = c("Religion", "Immigration",
                                            "Gender", "Environment"))
                 ),
                 mainPanel(
                   tableOutput("freqtable"),
                   textOutput("tablelabels")
                 )
               )
      )
    )
)
