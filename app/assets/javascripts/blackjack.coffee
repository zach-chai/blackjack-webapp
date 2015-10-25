# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  updateGame = ->
    id = $("#game-id").data "id"
    $.getJSON "/players?game_id=#{id}"
    .done (data) ->
      $("#game-data tr").remove()
      for player in data
        $("#game-data").append "<tr><td>Player #{player.id}</td><td>Hand</td></tr>"

  autoUpdate = ->
    if $("#game-id").get 0
      updateGame()
      setTimeout autoUpdate, 5000

  $(".action").click ->
    action = $(this).data "action"
    $.post "/blackjack/#{action}", { game_id: get_game_id(), player_id: get_player_id() }
    .fail ->
      alert "not your turn"

  get_player_id = ->
    $("#player-id").data "id"

  get_game_id = ->
    $("#game-id").data "id"

  autoUpdate()
