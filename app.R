library(shiny)
library(shinydashboard)
library(rmarkdown)
library(dplyr)
library(ggplot2)


data <- read.csv("winequality_all.csv")
dat <- read.csv("group_level_accuracy.csv")
dat$model[which(dat$model == "RF")] <- "Random Forest"

ui <- dashboardPage(
    
    dashboardHeader(title = "Wine Analysis"),
    
    dashboardSidebar(
        sidebarMenu(id = "sidebarmenu",
                    
                    menuItem("Project Overview", tabName = "project_overview"
                    ),
                    
                    menuItem("Exploratory Analysis", startExpanded = TRUE,
                             menuSubItem("Acidity Analysis",icon = icon("clipboard"), tabName = "acidity"),
                             menuSubItem("Sugar Analysis",icon = icon("clipboard"), tabName = "sugar"),
                             menuSubItem("Chloride Analysis",icon = icon("clipboard"), tabName = "chloride"),
                             menuSubItem("Sulfur Dioxide Analysis",icon = icon("clipboard"), tabName = "sd"),
                             menuSubItem("Density Analysis",icon = icon("clipboard"), tabName = "density"),
                             menuSubItem("pH Analysis",icon = icon("clipboard"), tabName = "pH"),
                             menuSubItem("Sulphate Analysis",icon = icon("clipboard"), tabName = "sulphate"),
                             menuSubItem("Alcohol Analysis",icon = icon("clipboard"), tabName = "alcohol"),
                             menuSubItem("Correlation",icon = icon("clipboard"), tabName = "correlation")
                             
                    ),
                    
                    menuItem("Clustering Analysis", tabName = "cluster_html"
                    ),
                    
                    menuItem("Principal Component Analysis", tabName = "pca_html"
                    ),
                    
                    menuItem("Quality Prediction", tabName = "quality_html"
                    ),
                    
                    menuItem("Wine Type Prediction", tabName = "wine_type_html"
                    )
                    
                    
        )
    ),
    
    dashboardBody(
        
        tabItems(
            tabItem(tabName = "project_overview", fluidPage(
              includeHTML("Docs.html")
            )),
            
            
            tabItem(tabName = "acidity", 
                    navbarPage('Acidity Analysis',
                               tabPanel(fluidPage(
                                   fluidRow(valueBoxOutput("fix_acidity_red"),
                                            valueBoxOutput("citric_acid_red"),
                                            valueBoxOutput("volatile_acidity_red")),
                                   fluidRow(valueBoxOutput("fix_acidity_white"),
                                            valueBoxOutput("citric_acid_white"),
                                            valueBoxOutput("volatile_acidity_white")),
                                   fluidRow(includeHTML("Acdity-Analysis-Formatted.html")))
                    )
                    
            )),
            
            tabItem(tabName = "sugar", 
                    navbarPage('Sugar Analysis',
                               tabPanel(fluidPage(
                                   fluidRow(valueBoxOutput("residual_sugar_red"),
                                            valueBoxOutput("residual_sugar_white")),
                                   fluidPage(includeHTML("Sugar-Analysis-Formatted.html")))
                               )
                    )),
            
            tabItem(tabName = "chloride", 
                    navbarPage('Chloride Analysis',
                               tabPanel(fluidPage(
                                   fluidRow(valueBoxOutput("chlorides_red"),
                                            valueBoxOutput("chlorides_white")),
                                   fluidPage(includeHTML("Chloride-Analysis-Formatted.html")))
                               )
                    )),
            
            tabItem(tabName = "sd", fluidPage(
                navbarPage('Sulfur Dioxide Analysis',
                           tabPanel(fluidPage(
                               fluidRow(valueBoxOutput("total_sd_red"),
                                        valueBoxOutput("free_sd_red")),
                               fluidRow(valueBoxOutput("total_sd_white"),
                                        valueBoxOutput("free_sd_white")),
                               fluidPage(includeHTML("Sulfur-Dioxide-Analysis-Formatted.html"))))
                ))),
            
            tabItem(tabName = "density", fluidPage(
                navbarPage('Density Analysis',
                           tabPanel(fluidPage(
                               fluidRow(valueBoxOutput("density_red"),
                                        valueBoxOutput("density_white")),
                               fluidPage(includeHTML("Density-Analysis-Formatted.html")))
                           )))),
            
            tabItem(tabName = "pH", fluidPage(
                navbarPage('pH Analysis',
                           tabPanel(fluidPage(
                               fluidRow(valueBoxOutput("ph_red"),
                                        valueBoxOutput("ph_white")),
                               fluidPage(includeHTML("pH-Analysis-Formatted.html")))))
            )),
            
            tabItem(tabName = "sulphate", fluidPage(
                navbarPage('Sulphates Analysis',
                           tabPanel(fluidPage(
                               fluidRow(valueBoxOutput("sulphates_red"),
                                        valueBoxOutput("sulphates_white")),
                               fluidPage(includeHTML("Sulphates-Analysis-Formatted.html")))))
            )),
            
            tabItem(tabName = "alcohol", fluidPage(
                navbarPage('Alcohol Analysis',
                           tabPanel(fluidPage(
                               fluidRow(valueBoxOutput("alcohol_red"),
                                        valueBoxOutput("alcohol_white")),
                               fluidPage(includeHTML("Alcohol-Analysis-Formatted.html")))))
            )),
            
            tabItem(tabName = "correlation", fluidPage(
                navbarPage('Variables Correlation'),
                fluidPage(includeHTML("Correlation-Plot-Formatted.html"))
            )),
            
            
            tabItem(tabName = "cluster_html",
                    navbarPage('Clustering Analysis',
                               tabPanel('Optimal Number of Clusters',
                                        fluidPage(
                                            box(
                                                width = 12,
                                                includeHTML("Clustering-Analysis-Formatted-1.html")
                                            ))
                               ),
                               tabPanel('Clustering Analysis',
                                        fluidPage(
                                            box(
                                                width = 12,
                                                includeHTML("Clustering-Analysis-Formatted-2.html")
                                            ))
                               ),
                    )
                              
            ),
            
            tabItem(tabName = "pca_html",
                    navbarPage('Principle Components Analysis',
                               tabPanel('Optimal Number of Principle Components',
                                        fluidPage(
                                          box(
                                            width = 12,
                                            includeHTML("Princple-Components-Selection-Formatted.html")
                                          ))
                               ),
                               tabPanel('Principle Components Analysis',
                                        fluidPage(
                                          box(
                                            width = 12,
                                            includeHTML("Principle-Components-Analysis-Formatted.html")
                                          ))
                               ),
                    )
            ),
           
            tabItem(tabName = "quality_html",
                    navbarPage('Quality Classification',
                               tabPanel('Overall Performance',
                                    fluidPage(
                                        box(
                                            width = 12,
                                            includeHTML("Quality-Classification-Formatted.html")
                                        ))
                               ), 
                               
                               tabPanel('Group-level Performance',
                                        fluidPage(
                                            sidebarLayout(
                                                sidebarPanel(
                                                    selectInput('quality_model_choice', 
                                                                label = 'Choose a model',
                                                                choices = unique(dat$model),
                                                                selected = unique(dat$model)[1])
                                                ),
                                                mainPanel(
                                                    fluidPage(plotOutput('quality_model_performance'),width = '60%')
                                                )
                                            ),
                                        )
                               )
                           
                    )    
            ),
            tabItem(tabName = "wine_type_html",
                    navbarPage('Wine Type Classification',
                               tabPanel('Variable Distribution',
                                        fluidPage(
                                          box(
                                            width = 12,
                                            includeHTML("Classification-Wine-Type-Formatted-1.html")
                                          ))
                               ),
                               tabPanel('Models Using all Predictors',
                                        fluidPage(
                                          box(
                                            width = 12,
                                            includeHTML("Classification-Wine-Type-Formatted-2.html")
                                          ))
                               ),
                               tabPanel('Models Using Two Predictors',
                                        fluidPage(
                                          box(
                                            width = 12,
                                            includeHTML("Classification-Wine-Type-Formatted-3.html")
                                          ))
                               ),
                               
                    )
            )
            
        )
    )
)



server <- function(input, output) { 
    output$'quality_model_performance' = renderPlot({
        dat <- read.csv("group_level_accuracy.csv")
        dat$model[which(dat$model == "RF")] <- "Random Forest"
        dat %>% filter(model == input$'quality_model_choice') %>%
            ggplot() + geom_bar(aes(Class,Accuracy),stat = "identity", fill = "steelblue") +
            scale_x_continuous(breaks = seq(3,9,1), name = "Quality Group") + 
            scale_y_continuous(name = "Balanced Accuracy", limits = c(0,1.05)) +
            ggtitle(paste0("Balanced Accuracy per Group for ", input$'quality_model_choice')) +
            geom_text(aes(Class,Accuracy,label = round(Accuracy,2)),
                      hjust = 0.5, size = 3, color = "blue",
                      #position = position_dodge(width = 5),
                      position = position_nudge(y = 0.05),
                      inherit.aes = TRUE)
            
        })
    
    output$'fix_acidity_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(fixed.acidity))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Fixed Acidity Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
    
    })
    output$'fix_acidity_white' = renderValueBox({
      
        mean <- data %>% group_by(red) %>% summarize(mean(fixed.acidity))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Fixed Acidity Mean',
            icon = icon('glass-martini'),
            col = 'teal')
    })
    
    output$'citric_acid_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(citric.acid))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Citric Acidity Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    output$'citric_acid_white' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(citric.acid))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Citric Acidity Mean',
            icon = icon('glass-martini'),
            col = 'teal')
    })
    
    output$'volatile_acidity_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(volatile.acidity))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Volatile Acidity Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'volatile_acidity_white' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(volatile.acidity))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Volatile Acidity Mean',
            icon = icon('glass-martini'),
            col = 'teal')
    })
    
    output$'residual_sugar_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(residual.sugar))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Residual Sugar Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'residual_sugar_white' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(residual.sugar))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Residual Sugar Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    
    output$'chlorides_red' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(chlorides))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Chlorides Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'chlorides_white' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(chlorides))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Chlorides Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    
    output$'total_sd_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(total.sulfur.dioxide))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Total Sulfur Dioxide Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    output$'free_sd_red' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(free.sulfur.dioxide))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Free Sulfur Dioxide Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    output$'total_sd_white' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(total.sulfur.dioxide))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Total Sulfur Dioxide Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    output$'free_sd_white' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(free.sulfur.dioxide))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Free Sulfur Dioxide Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    
    
    output$'density_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(density))
        valueBox(
            value = round(mean[2,2],3),
            subtitle = 'Density Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'density_white' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(density))
        valueBox(
            value = round(mean[1,2],3),
            subtitle = 'Density Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    
    output$'ph_red' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(pH))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'pH Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'ph_white' = renderValueBox({
       
        mean <- data %>% group_by(red) %>% summarize(mean(pH))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'pH Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    
    output$'sulphates_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(sulphates))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Sulphates Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'sulphates_white' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(sulphates))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Sulphates Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    output$'alcohol_red' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(alcohol))
        valueBox(
            value = round(mean[2,2],2),
            subtitle = 'Alcohol Mean',
            icon = icon('glass-martini'),
            col = 'fuchsia')
        
    })
    
    output$'alcohol_white' = renderValueBox({
        
        mean <- data %>% group_by(red) %>% summarize(mean(alcohol))
        valueBox(
            value = round(mean[1,2],2),
            subtitle = 'Alcohol Mean',
            icon = icon('glass-martini'),
            col = 'teal')
        
    })
    
    
}

shinyApp(ui, server)