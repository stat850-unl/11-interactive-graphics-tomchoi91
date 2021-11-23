library(shiny)
require(dplyr)
require(readr)

# rawdata<-rawdata %>%
  # mutate(thumb=paste0('"<img src="',drink_thumb,'" height="52"></img>"'))

# rawdata<-read.csv('https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2020/2020-05-26/cocktails.csv')
# 
# nalist<-rawdata %>%
#   filter(measure=="\n") %>%
#   select(drink) %>%
#   unique()
# 
# cocktails<-rawdata %>%
#   filter(!drink %in% nalist$drink)
# 
# write.csv(cocktails,"cocktail-1/data/cocktails.csv")


cocktails<-read.csv("data/cocktails.csv")
ing <- unique(cocktails$ingredient)

# Define UI ----
ui <- fluidPage(
  titlePanel("title panel"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput("ing","Ingredients:",choices=ing,selected=c(),multiple=TRUE)
    ),
    mainPanel("main panel",
              helpText('yoyoyyo'),
              DT::dataTableOutput('drinks_table'))
  
))


# Define server logic ----
server <- function(input, output) {

  .drinks_table <- function(cocktails) {
    nalist <- cocktails %>%
      dplyr::filter(ingredient %in% input$ing) %>%
      select(drink) %>%
      unique()
    
    filtered <- cocktails %>%
      dplyr::filter(drink %in% nalist$drink) %>%
      mutate(thn=paste0('<img src="',drink_thumb,'" height="52"></img>')) %>%
      dplyr::select(drink,ingredient,measure,thn)
  }
  
  output$drinks_table <- DT::renderDataTable({
    filtered <- .drinks_table(cocktails)
    DT::datatable(filtered, escape=F)

  })
}

# Run the app ----
shinyApp(ui = ui, server = server)