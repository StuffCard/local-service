$ ->
  dispatcher = new WebSocketRails("localhost:3000/websocket")

  checkin_channel = dispatcher.subscribe(window.location_key)

  checkin_channel.bind "new_checkin", (data) ->
    $(".chart-container").highcharts().series[0].setData data.checkins
