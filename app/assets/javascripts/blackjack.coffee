# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  updateGame = ->
    id = get_game_id()
    $.getJSON "/players?game_id=#{id}"
    .done (data1) ->
      if data1[0].score
        window.location.href = "/blackjack/end?game_id=#{id}&player_id=#{get_player_id()}"
      $("#game-data tr").remove()
      for player in data1
        do (player) ->
          $.getJSON "/cards?player_id=#{player.id}"
          .done (data2) ->
            card_string = ""
            card_string2 = ""
            for card in data2
              if card.split_hand == null || card.split_hand == "left"
                if get_player_id() != player.id && card.hidden
                  card_string += "<td> hidden </td>"
                else
                  card_string += "<td> #{card.value} of #{card.suit} </td>"
              else
                if get_player_id() != player.id && card.hidden
                  card_string2 += "<td> hidden </td>"
                else
                  card_string2 += "<td> #{card.value} of #{card.suit} </td>"
            $("#game-data").append "<tr><td>Player #{player.name} Hand 1</td></tr><tr>#{card_string}</tr>"
            if card_string2
              $("#game-data").append("<tr><td>Player #{player.name} Hand 2</td></tr><tr>#{card_string2}</tr>")

  autoUpdate = ->
    if window.location.pathname == "/blackjack/join"
      updateGame()
      setTimeout autoUpdate, 5000

  $(".action").click ->
    action = $(this).data "action"
    split = $(this).data("split") || null
    $.post "/blackjack/#{action}", { game_id: get_game_id(), player_id: get_player_id(), split: split }
    .done ->
      alert "success"
    .fail ->
      alert "fail"

  get_player_id = ->
    $("#player-id").data "id"

  get_game_id = ->
    $("#game-id").data "id"

  autoUpdate()
