$ ->
  title = $(".chart-container").data('title')
  checkins = $(".chart-container").data('checkins')
  colors = ["#009900", "#3399FF", "#993333", "#FFCC66", "#FF3300", "#993399", "#003366", "#00FFFF"]

  $(".chart-container").highcharts
    chart:
      type: "areaspline"

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

    series: [
      {
        name: title
        data: checkins
        color: colors[0]
      }
    ]
