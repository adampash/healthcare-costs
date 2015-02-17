d3 = require 'd3'

window.BarChart =
  barHeight: 25
  width: 420
  clean_num: (dollar_amount) ->
    parseFloat dollar_amount.replace("$", "").replace(',', '')
  getXData: (key) ->
    DATA.map (data) =>
      @clean_num data[key]

  renderGraph: (key) ->
    X_DATA = @getXData(key)
    x = d3.scale.linear()
          .domain([0, d3.max(X_DATA)])
          .range([0, @width])

    @chart = d3.select(".chart")
      .attr("width", @width)
      .attr("height", @barHeight * X_DATA.length)

    @bar = @chart.selectAll('g')
        .data(DATA)
      .enter().append("g")
        .attr("transform", (d, i) => "translate(0, #{i * @barHeight})")

    @bar.append('rect')
        # .attr('width', x)
        .attr('width', (d) => x(@clean_num d[key]))
        .attr('height', @barHeight - 3)

    @bar.append("text")
        .attr("x", (d) =>
          x(@clean_num d[key]) - 3
        )
        .attr("y", @barHeight / 2)
        .attr("dy", ".35em")
        .text (d) -> d[key]

  updateGraph: (key) ->
    X_DATA = @getXData(key)
    x = d3.scale.linear()
          .domain([0, d3.max(X_DATA)])
          .range([0, @width])

    @chart.attr("height", @barHeight * X_DATA.length)
    @bar.data(DATA)
      .transition()
      .select('rect')
        .attr('width', (d) => x(@clean_num d[key]))

    @bar.transition()
      .select("text")
        .attr("x", (d) =>
          x(@clean_num d[key]) - 3
        )
        .attr("y", @barHeight / 2)
        .attr("dy", ".35em")
        .text (d) -> d[key]


BarChart.renderGraph("APPENDECTOMY Inpatient")

setTimeout ->
  console.log 'update graph'
  BarChart.updateGraph("APPENDECTOMY Outpatient")
, 500
