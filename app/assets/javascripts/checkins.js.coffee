$ ->
  title = $(".chart-container").data('title')
  checkins = $(".chart-container").data('checkins')

  # Convert Rails Unix-Time to JS Unix-Time
  checkins = convertTimestamp(checkins)

  colors = ["#FFCC66", "#FF3300", "#993399", "#003366", "#3399FF", "#00FFFF"]

  Highcharts.setOptions
    global:
      useUTC: false

  $(".chart-container").highcharts
    chart:
      type: "spline"

    title:
      text: "Checkins"

    yAxis:
      allowDecimals: false
      title: false
      labels:
        format: "{value}"

    xAxis:
      type: 'datetime'
    #   # allowDecimals: false
      # labels:
      #   format: "{value}"

    tooltip:
      headerFormat: "<span style='font-size: 10px'><b>{point.key} Uhr</b></span><br/>"

    plotOptions:
      spline:
        lineWidth: 3
        states:
          hover:
            lineWidth: 4
        marker:
            enabled: false

    series: [
      name: title
      data: checkins
      color: colors[0]
    ]

convertTimestamp = (data) ->
  # Convert Rails Unix-Time to JS Unix-Time
  $.each data, (k,v) ->
    data[k][0] = v[0]*1000

  return data