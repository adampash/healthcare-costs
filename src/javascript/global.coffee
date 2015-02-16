# Browserify entry point for the global.js bundle (yay CoffeeScript!)
clean_num = (dollar_amount) ->
  parseFloat dollar_amount.replace("$", "").replace(',', '')

d3 = require 'd3'

# DATA = [1,2,3,4,5]
key = "APPENDECTOMY Inpatient"
X_DATA = DATA.map (data) ->
  clean_num data[key]

x = d3.scale.linear()
      .domain([0, d3.max(X_DATA)])
      .range([0, 420])

d3.select('.chart')
  .selectAll("div")
    .data(DATA)
  .enter().append("div")
    .style("width", (d) ->
      style = parseFloat(
        x(clean_num d[key])
      ) + "px"
    )
    .text (d) -> "#{d.Region}: #{d[key]}"

