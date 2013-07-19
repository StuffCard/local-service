$ ->
  title = $(".chart-container").data('title')
  checkins = $(".chart-container").data('checkins')

  $(".chart-container").highcharts
    chart:
      type: "column"

    title:
      text: "Checkins"

    yAxis:
      allowDecimals: false
      title:
        text: "Checkins"
      labels:
        format: "{value}x"

    xAxis:
      allowDecimals: false
      labels:
        format: "{value}:00 Uhr"

    series: [
      {
        name: title
        data: checkins
        color: '#785200'
      }
    ]
