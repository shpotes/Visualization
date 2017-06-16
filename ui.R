library(leaflet)
library(ggplot2)
library(plotly)

navbarPage("EAFIT",
  #img(src='logo_eafit_completo.png', width=70, height=35), id="nav",
  tabPanel("Centro de Egresados",
           h1("Centro de Egresados"),
           tags$video(src =
              "Línea del Tiempo - Centro de Egresados - Universidad EAFIT.mp4",
              type = "video/mp4", autoplay = NA, controls = NA)), 
  tabPanel("Mapa Interactivo",
    div(class="outer",

      tags$head(
        includeCSS("styles.css"),
        includeScript("gomap.js")
      ),

      leafletOutput("map", width="100%", height="100%"),

      absolutePanel(id = "controls", class = "panel panel-default",
                    fixed = TRUE, draggable = TRUE, top = 60, left = "auto",
                    right = 20, bottom = "auto", width = 330, height = "auto",

        h2("Localizacion de los eafitenses"),
        sliderInput("year", "Año", min = 2001, max = 2017, value = 2001,
                    animate = animationOptions(interval = 5000, loop = F)),
        plotlyOutput("Gener", height = 250, width = 250),
        plotlyOutput("Carrera", height = 250, width = 250)
      ),

      tags$div(id="cite",
        'Vigilada Mineducación.'
      )
    )
  )
)
