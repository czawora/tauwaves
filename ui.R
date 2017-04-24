

library(shiny)

shinyUI(fluidPage(


	sidebarLayout(

		sidebarPanel(

			 actionButton("start_simul", label= "Start"),
			 actionButton("stop_simul", label = "Stop"),
			 actionButton("stim_click", label = "Stimulus!"),
			 actionButton("reset", label = "reset")



		),
		mainPanel(

			verbatimTextOutput("histo_text"),
			plotOutput("histo"),
			tags$style(type="text/css", "#histo.recalculating { opacity: 1.0; }")


		)

	)

))