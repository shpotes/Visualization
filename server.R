library(sp)
library(rgdal)
library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(ggplot2)
library(plotly)

## TODO
# Implement Fenwick Tree to improve speed

data <- read.csv("https://www.dropbox.com/s/s322kovz7u6s0cn/datafix.csv?dl=1")

function(input, output, session) {
  ## Interactive Map ###########################################
  # Create the map
  output$map <- renderLeaflet({
    countries <- readOGR("countries.geojson.txt", "OGRGeoJSON")
    countries$eafit <- rep(0, 177)
    freq <- as.data.frame(table(
        data$País.de.residencia.[data$Año.de.grado <= input$year]))
    index <- match(c("Germany", "Argentina", "Australia",
                     "China", "Colombia", "Costa Rica",
                     "Denmark", "Spain", "United States",
                     "France", "Guatemala", "Hungary", "Italy",
                    "Mexico", "Netherlands", "Peru","United Kingdom"),
                  countries$name)
    countries$eafit[index] <- countries$eafit[index] + freq$Freq[-1]

    state_popup <- paste0("<strong>Estado: </strong>",
                          countries$name,
                          "<br><strong>Numero de Egresados: </strong>",
                          countries$eafit)

    map <- leaflet(countries) %>% setView(lng = 10, lat = 20,  zoom = 2)
    qpal <- function(y) unlist(
                 Map( y == 0, f = function(x)(ifelse(x, "#F7FBFF", "#084594"))))
    map %>%
      addPolygons(stroke = FALSE, smoothFactor = 0.2, fillOpacity = 1,
                color = ~qpal(eafit), popup = state_popup)
  })

  output$Gener <- renderPlotly({
      plot_ly(as.data.frame(table(
          data$Genero[data$Año.de.grado <= input$year])),
              labels = ~Var1, values = ~Freq, type = "pie", hole= 0.6,
              textposition = 'inside',
                  textinfo = 'label+percent') %>%
      layout(title = 'Distribucion por Genero')
  })

  output$Carrera <- renderPlotly({
    Carreras <- as.data.frame(table(data$Carrera[data$Año.de.grado <= input$year]))
    df <- data.frame(Escuelas = c("Admin", "Ing", "Der", "Eco", "Sci"),
                     Freq = c(Reduce(`+`,Carreras[c(1,20,4,18),]$Freq),
                              Reduce(`+`,Carreras[c(9:13, 17),]$Freq),
                              Reduce(`+`,Carreras[5,]$Freq),
                              Reduce(`+`,Carreras[6:7,]$Freq),
                              Reduce(`+`,Carreras[c(14:16, 8),]$Freq)))
    plot_ly(df, y=~Freq, x =~Escuelas, type = "bar", alpha = 0.6) %>%
        layout(title = 'Distribucion por escuelas',
               yaxis = list(title = 'Frecuencia'))
  })

}
