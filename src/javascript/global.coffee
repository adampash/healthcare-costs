d3 = require 'd3'
$ = require 'jQuery'

window.BarChart =
  barHeight: 43
  width: 420
  init: ->
    @width = $('.chart').width()
    $('.chart').height(DATA.length * (@barHeight))

  clean_num: (dollar_amount) ->
    parseFloat dollar_amount.replace("$", "").replace(',', '')
  getXData: (key) ->
    DATA.map (data) =>
      @clean_num data[key]

  toTitleCase: (str) ->
    str.replace /\w\S*/g, (txt) ->
      txt.charAt(0).toUpperCase() + txt.substr(1).toLowerCase()

  formatKey: (key) ->
    initial_type = key.match(/([A-Z,]+ )+/)[0]
    type = @toTitleCase(initial_type).replace(/with /i, 'w/')
    "<span class=\"type\">#{type}</span> #{key.split(initial_type)[1]}"

  renderGraph: (key) ->
    $('h2.operation').html(@formatKey(key))
    @init()
    X_DATA = @getXData(key)
    x = d3.scale.linear()
          .domain([0, d3.max(X_DATA)])
          .range([0, @width - 135])

    @chart = d3.select(".chart")
      .attr("width", @width)
      .attr("height", @barHeight * X_DATA.length)

    @bar = @chart.selectAll('g')
        .data(DATA)
      .enter().append("g")
        .attr("transform", (d, i) => "translate(0, #{i * @barHeight})")

    @bar.append('rect')
        .attr('class', 'gray')
        .attr('x', 150)
        .attr('width', "100%")
        .attr('height', @barHeight - 5)

    @bar.append('rect')
        .attr('x', 135)
        .attr('class', 'data')
        .attr('width', (d) => x(@clean_num d[key]))
        .attr('height', @barHeight - 5)

    @bar.append("text")
        .attr("x", 145)
        .attr("y", 19)
        .attr("dy", ".35em")
        .text (d) -> d[key].replace(/\.\d\d/, '')

    @bar.append("text")
        .attr('class', 'name')
        .attr("x", 121)
        .attr("y", 19)
        .attr("dy", ".35em")
        .text (d) -> d["Region"]

  updateGraph: (key) ->
    @formatKey(key)
    $('h2.operation').text()
    $('h2.operation').html(@formatKey(key))
    X_DATA = @getXData(key)
    x = d3.scale.linear()
          .domain([0, d3.max(X_DATA)])
          .range([0, @width - 135])

    @chart.attr("height", @barHeight * X_DATA.length)
    @bar.data(DATA)
      .transition()
      .select('rect.data')
        .attr('width', (d) =>
          x(@clean_num d[key]) or 0
        )

    @bar.transition()
      .select("text")
        .attr("x", 145)
        .attr("dy", ".35em")
        .text (d) -> d[key].replace(/\.\d\d/, '')

  showOperations: ->
    _ = require 'underscore'
    operations = _.keys(DATA[0])
    operations.shift()

    for operation in operations
      display_operation = @toTitleCase operation
      display_operation = display_operation
                    # .toLowerCase()
                    .replace("Inpatient", "(In)")
                    .replace("Outpatient", "(Out)")
                    .replace("With ", "w/")
      $('.operations').append """
        <div class="operation" data-op="#{operation}">
         #{display_operation}
        </div>
      """

    $('div.operation').first().addClass('selected')

    $('div.operation').on 'click', (e) =>
      $el = $(e.target)
      @updateGraph $el.data('op')

      $('.selected').removeClass('selected')
      $el.addClass('selected')

BarChart.showOperations()
BarChart.renderGraph("APPENDECTOMY Inpatient")

