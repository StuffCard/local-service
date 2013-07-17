$ ->
  dispatcher = new WebSocketRails("localhost:3000/websocket")

  checkin_channel = dispatcher.subscribe("checkin")

  checkin_channel.bind "new_checkin", (data) ->
    $(".chart-container").highcharts().series[0].setData data.checkins
