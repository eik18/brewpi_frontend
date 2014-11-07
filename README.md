brewpi_frontend
===============

This project is to create a lightweight Ruby based gui for the Brewberrypi project.

Requirements:
Ruby 2.0.0+
Gems: Sinatra, JSON, HAML

This project taks advantage of Bootstrap Frame for it's CSS.

Components on interest:

Brew.rb - Core Sinatra service for project.  This handles the GUI requests and posts, plus provides an interface with BeerberryPi's API

Brewservice.rb - Sinatra-based testing service that acts as the Beerberrypi backend API. This is not a required element

views/brewhome.haml - HAML template for root page 

views/brewedit.haml - HAML template for /brewedit page.

Configuration Instructions
 To Be Drafted

 Execution Instructions
 Start: ruby brew.rb

 