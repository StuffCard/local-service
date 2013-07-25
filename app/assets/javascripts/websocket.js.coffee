$ ->
  colors = ["#009900", "#3399FF", "#993333", "#FFCC66", "#FF3300", "#993399", "#003366", "#00FFFF"]

  # Local Websocket
  local_dispatcher = new WebSocketRails("localhost:3000/websocket")

  local_channel = local_dispatcher.subscribe(window.location_key)
  local_channel.bind "new_checkin", (checkin_data) ->
    chart = $(".chart-container").highcharts()
    $.each(chart.series, (key, series) ->
        if $(".chart-container").data('title') ==  series.name
          series.setData checkin_data.checkins
    )



  if (window.master_websocket != undefined)
    # Master Websocket
    master_dispatcher = new WebSocketRails(window.master_websocket)

    master_channel = master_dispatcher.subscribe('sync')
    master_channel.bind "new_sync", (locations_data) ->
      chart = $(".chart-container").highcharts()

      while(chart.series.length > 0)
        chart.series[0].remove()

      i = 0
      $.each(locations_data, (key, data) ->
        series = {name : key, data : [], color : colors[i++]}

        $.each(data, (index, value) ->
          series.data.push [value[0], value[1]]
        )

        chart.addSeries series
      )

      chart.redraw()