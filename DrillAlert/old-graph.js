

graph = {};


graph.init = function (config) {

	yMax = config.yMax;
	xMax = config.xMax;

	var xAxisMin = 0, xAxisMax = yMax;
	data = config.data;
	// n = domain max for y axis
	graph.n = yMax;
	graph.random = d3.random.normal(xMax/2, .2);
	d3.range(graph.n);

	graph.data = data;
     if (data === undefined) {
     	graph.data = d3.range(graph.n).map(graph.random);
     }

	graph.margin = {top: 20, right: 20, bottom: 20, left: 40};
	
	graph.width = config.width === undefined ? 500 : config.width;
	graph.height = config.height === undefined ? 300 : config.height;

	graph.x = d3.scale.linear()
	.domain([0, graph.n - 1])
	.range([0, graph.width]);

	graph.y = d3.scale.linear()
	.domain([xMax, 0])
	.range([graph.height, 0]);

	graph.line = d3.svg.line()
	.x(function(d, i) { return graph.x(i); })
	.y(function(d, i) { return graph.y(d); });

	graph.svg = d3.select("body").append("svg")
	.attr("width", 300 + graph.margin.left + graph.margin.right)
	.attr("height", graph.width + graph.margin.top + graph.margin.bottom)
	.append("g")
	.attr("transform", "translate(" + graph.margin.left + "," + graph.width + "), rotate(-90)");

	graph.svg.append("defs").append("clipPath")
	.attr("id", "clip")
	.append("rect")
	.attr("width", graph.width)
	.attr("height", graph.height);

	graph.svg.append("g")
	.attr("class", "x axis")
	.attr("transform", "translate(0,0)")
	.call(d3.svg.axis().scale(graph.x).orient("top"))
	.selectAll("text")
	.style("text-anchor", "end")
	.attr("dx", "-.8em")
	.attr("dy", "1.2em")
	.attr("transform", function(d) {
	return "rotate(90)" 
	});

	graph.svg.append("g")
	.attr("class", "y axis")
	.call(d3.svg.axis().scale(graph.y).orient("left"))
	.selectAll("text")
	.style("text-anchor", "end")
	.attr("dx", "1.3em")
	.attr("dy", "1.5em")
	.attr("transform", function(d) {
	return "rotate(90)" 
	});

	graph.path = graph.svg.append("g")
	.attr("clip-path", "url(#clip)")
	.append("path")
	.datum(graph.data)
	.attr("class", "line")
	.attr("d", graph.line);

	// tick();
	graph.tick = function (val) {

		// push a new data point onto the back
		// data.push(random());
		graph.data.push(val);

		// redraw the line, and slide it to the left
		graph.path
		.attr("d", graph.line)
		.attr("transform", null)
		.transition()
		.duration(250)
		.ease("linear")
		.attr("transform", "translate(" + graph.x(-1) + ", 0)");
		// .each("end", tick);

		// pop the old data point off the front
		if (graph.data.length >= graph.n + 1) {
	                // redraw the line, and slide it to the left
	                graph.path
	                .attr("d", graph.line)
	                .attr("transform", null)
	                .transition()
	                .duration(250)
	                .ease("linear")
	                .attr("transform", "translate(" + graph.x(-1) + ", 0)");
	                // .each("end", tick);
	                xAxisMin += 1;
	                xAxisMax += 1;
	                
	                //redraws xAxis to increase
	                graph.svg.selectAll("g.x.axis")
	                .call(d3.svg.axis().scale(
	                  d3.scale.linear()
	                  .domain([xAxisMin, xAxisMax - 1])
	                  .range([0, graph.width]))
	                .orient("top"))
	                .selectAll("text")
	                .style("text-anchor", "end")
	                .attr("dx", "-.8em")
	                .attr("dy", "1.2em")
	                .attr("transform", function(d) {
	                   return "rotate(90)" 
	                   });

			graph.data.shift();
	}

	}
}
