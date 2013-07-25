$ ->
  title = $(".chart-container").data('title')
  checkins = $(".chart-container").data('checkins')
  colors = ["#FFCC66", "#FF3300", "#993399", "#003366", "#3399FF", "#00FFFF"]

  $(".chart-container").highcharts
    chart:
      type: "spline"

    title:
      text: "Checkins"

    yAxis:
      allowDecimals: false
      title:
        text: "Checkins"
      labels:
        format: "{value}"

    xAxis:
      allowDecimals: false
      labels:
        format: "{value}:00 Uhr"

    plotOptions:
      spline:
        lineWidth: 4
        states:
          hover:
            lineWidth: 5
        marker:
            enabled: false

    series: [
      name: title
      data: checkins
      color: colors[0]
    ]
