#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)

# Define server logic required to draw a histogram
function(input, output, session) {
  
  data_2021 <- read.csv("gss2021.csv")
  smaller_data <- select(data_2021, NATENVIR, RELIG, IMMLIMIT, SEXNOW1)
  
  data1 <- reactive({
    if (input$religious == "Religious") {
      smaller_data %>%
        filter(RELIG != 4)
    } else {
      smaller_data %>%
        filter(RELIG == 4)
    }
  })
  
  variable_key <- c("Religion" = "RELIG", "Gender" = "SEXNOW1", 
           "Immigration" = "IMMLIMIT", "Environment" = "NATENVIR")
  
  religion_key <- ("1 = Protestant, 2 = Catholic, 3 = Jewish,
                    4 = None, 5 = Other, 6 = Buddhism,
                    7 = Hinduism, 8 = Other Eastern Religions,
                    9 = Muslim/Islam, 10 = Orthodox Christian,
                    11 = Christian, 12 = Native American,
                    13 = Inter/nondenominational")
  #religion_factor <- factor(c("1", "2", "3", "4", "5", "6", "7", "8", 
   #                           "9", "10", "11", "12", "13"))

  
  output$barplot <- renderPlot({
    if (input$variable == "Gender") {
      ggplot(data1(), aes(x = SEXNOW1, fill = factor(input$color))) +
        geom_bar() +
        scale_fill_manual(values = input$color) +
        labs(x = "Gender", y = "Count", fill = "Color Chosen")
    } else if (input$variable == "Immigration") {
      ggplot(data1(), aes(x = IMMLIMIT, fill = factor(input$color))) +
        geom_bar() +
        scale_fill_manual(values = input$color) +
        labs(x = "Prompt: America should limit immigration", y = "Count",
             fill = "Color Chosen")
    } else if (input$variable == "Environment") {
      ggplot(data1(), aes(x = NATENVIR, fill = factor(input$color))) +
        geom_bar() +
        scale_fill_manual(values = input$color) +
        labs(x = "Prompt: Opinion on current US spending on environmental 
             protection", y = "Count", fill = "Color Chosen")
    }
  })
  
  output$labels <- renderText({
    if(input$variable == "Gender") {
      return("1 = Male, 2 = Female, 3 = Transgender, 4 = None")
    } else if (input$variable == "Immigration") {
      return("1 = Strongly agree, 2 = Agree, 3 = Neither agree nor disagree,
             4 = Disagree, 5 = Strongly disagree")
    } else if (input$variable == "Environment") {
      return("1 = Too little, 2 = About right, 3 = Too much")
    }
  })
  
  filteredData <- reactive({
    check_for <- which(input$column == names(variable_key))
    col_name <- variable_key[[check_for]]
    factor(smaller_data[, col_name])
  })
  
  output$freqtable <- renderTable({
    table(filteredData())
  })
  
  output$tablelabels <- renderText({
    if(input$column == "Religion") {
      return("What is your religion? 1 = Protestant, 2 = Catholic, 3 = Jewish,
                    4 = None, 5 = Other, 6 = Buddhism,
                    7 = Hinduism, 8 = Other Eastern Religions,
                    9 = Muslim/Islam, 10 = Orthodox Christian,
                    11 = Christian, 12 = Native American,
                    13 = Inter/nondenominational")
    } else if (input$column == "Gender") {
      return("1 = Male, 2 = Female, 3 = Transgender, 4 = None of these")
    } else if (input$column == "Environment") {
      return("What do you think of US spending on the environment?
             1 = Too little, 2 = About right, 3 = Too much")
    } else {
      return("America should limit immigration? 1 = Strongly agree, 2 = Agree, 3 = Neither agree nor disagree,
             4 = Disagree, 5 = Strongly disagree")
    }
  })


}
