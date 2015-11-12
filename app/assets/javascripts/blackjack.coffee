# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'ready page:load', ->
  updateGame = ->
    id = get_game_id()
    $.getJSON "#{get_root()}players?game_id=#{id}"
    .done (data1) ->
      if data1[0].score || data1[0].left_score
        window.location.href = "#{get_root()}blackjack/end?game_id=#{id}&player_id=#{get_player_id()}"
      $("#game-data tr").remove()
      for player in data1
        if player.has_turn == true
          if player.id == get_player_id()
            $("#player-turn").text("Your turn")
          else
            $("#player-turn").text("Player #{player.name} turn")
        card_string = ""
        card_string2 = ""
        for card in player.cards
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
        $("#game-data").append "<tr><td>Player #{player.name} Hand 1</td></tr><tr id=\"player-#{player.name}-hand\" class=\"hand\" data-player=\"#{player.name}\" >#{card_string}</tr>"
        if card_string2
          $("#game-data").append "<tr><td>Player #{player.name} Hand 2</td></tr><tr id=\"player-#{player.name}-hand\" class=\"hand\" data-player=\"#{player.name}\" >#{card_string2}</tr>"

  poll = ->
    $.post "#{get_root()}blackjack/poll", { game_id: get_game_id(), player_id: get_player_id() }

  autoUpdate = ->
    if window.location.pathname == "#{get_root()}blackjack/join" || window.location.pathname == "#{get_root()}blackjack/split"
      poll()
      updateGame()
      setTimeout autoUpdate, 4000

  autoPoll = ->
    if window.location.pathname == "#{get_root()}blackjack/join" || window.location.pathname == "#{get_root()}blackjack/split"
      poll()
      setTimeout autoPoll, 5000

  $(".action").click ->
    action = $(this).data "action"
    split = $(this).data("split") || null
    $.post "#{get_root()}blackjack/#{action}", { game_id: get_game_id(), player_id: get_player_id(), split: split }
    .done ->
      if action == "split"
        window.location.href = "#{get_root()}blackjack/split?game_id=#{get_game_id()}&player_id=#{get_player_id()}"
      $("#notice").text "#{action} success"
    .fail ->
      $("#notice").text "#{action} fail"

  get_player_id = ->
    $("#player-id").data "id"

  get_game_id = ->
    $("#game-id").data "id"

  get_root = ->
    $("#app-root").attr "href"

  autoUpdate()
  autoPoll()
