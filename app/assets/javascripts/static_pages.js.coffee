# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

# binding on document instead of #fb-share allows us to set up a delegated event handler
# http://api.jquery.com/on/#direct-and-delegated-events
# this allows us to not worry about turbolinks breaking things since we're not using jquery's ready() to wait for the DOM to load
$(document).on "click", "#fb-share", ->
  FB.ui
    method: 'share'
    href: 'http://campusanonymous.com'
  , (response) ->
