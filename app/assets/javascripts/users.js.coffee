# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  console.log "The page loaded!"

  $('.standingsBtn').on 'click', ->
    console.log("hey man@")

  $('#standingsPanelTitle').on 'click', ->
    console.log("you clicked the title")
