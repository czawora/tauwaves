
library(shiny)
library(deSolve)
library(Rcpp)

system("R CMD SHLIB model.c")
dyn.load("model.so")


shinyServer(function(input, output, session){

  	n <- 1024
	u <- 24
	sd_factor <- 0.05

	periods <- rnorm(n, mean = u, sd = sd_factor*u)
	dPhi <- (2*pi)/periods


	# Initialize my_data
  	my_data <<- rep(0, n)
  	timer <<- 1
  	timesteps <- rep(0, 500)
  	stim <<- 0

  	r <- reactiveValues(start = FALSE)

	output$histo <- renderPlot({

		input$reset
		if(r$start == TRUE){
			invalidateLater(100, session)
			update_data()
		}
  		hist(my_data %% (2*pi), breaks = 50, ylim = c(0, n/5), xlim = c(0, 2*pi), main = paste(timer))
			
  	})

  	output$histo_text <- renderText({

  		s <- "Phase distribution of oscillators"
  	})
  	
  	# Function to update my_data
  	update_data <- function(){

  		if(stim == 0){
  			stim <<- timesteps[timer]
  		}

    	my_data <<- sapply(1:length(dPhi), new_oscillator, stim)

    	timer <<- timer + 1
    	stim <<- 0
  	}

  	new_oscillator <- function(idx, tim){

  		parms <- c(omega = dPhi[idx], eps = 1000, beta = 25, stim = tim)
  		Y <- c(Phi = my_data[idx])
  		times <- seq(0, 1, 1)
  		out <- ode(Y, times, func = "derivs", parms = parms, dllname = "model",
             initfunc = "initmod", nout = 0, outnames = "none")
  		return(out[2,2])

	}

  	observe({

		input$start_simul
  		r$start <- TRUE

  	})

  	observe({

  		input$stop_simul
  		r$start <- FALSE

  	})

  	observe({

  		input$stim_click
  		stim <<- 1

  	})

  	observe({
		
		input$reset
  		my_data <<- rep(0, n)
  		timer <<- 1

  	})


})