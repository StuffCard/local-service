$ ->
  checkins = $(".chart-container").data('checkins')

  $(".chart-container").highcharts
    chart:
      type: "column"

    title:
      text: "Checkins"

    yAxis:
      allowDecimals: false
      title:
        text: "Checkins Here"
      labels:
        format: "{value}x"

    xAxis:
      allowDecimals: false
      labels:
        format: "{value}:00 Uhr"

    series: [
      {
        name: "Checkins"
        data: checkins
        color: '#785200'
      }
    ]
