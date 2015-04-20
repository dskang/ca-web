# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# binding on document instead of #fb-share allows us to set up a delegated event handler
# http://api.jquery.com/on/#direct-and-delegated-events
# this allows us to not worry about turbolinks breaking things since we're not using jquery's ready() to wait for the DOM to load
$(document).on "click", "#fb-share", ->
  FB.ui
    method: 'share'
    href: 'http://www.campusanonymous.com'
  , (response) ->

# homepage school carousel
$(document).on 'ready page:load', ->
  carouselClass = 'carousel-entrance'
  schools = $('.carousel')
  schools.eq(0).addClass carouselClass
  counter = 0
  showNextSchool = ->
    schools.eq(counter).removeClass carouselClass
    counter++
    if counter == schools.length then counter = 0
    schools.eq(counter).addClass carouselClass
  setInterval showNextSchool, 2000
