master = {};

/*
 config example:
 
 config = {yMax : 40, xMax : 10, data : [1, 2, 3, 4, 5, 6, 7, 6, 5], width : 500, height : 300, id : 0}
 */
master.init = function (config) {
    
    id = config.id;
    
    master[id] = {};
    
    yMax = config.yMax;
    xMax = config.xMax;
    
    var xAxisMin = 0, xAxisMax = yMax;
    data = config.data;
    // n = domain max for y axis
    master[id].n = yMax;
    master[id].random = d3.random.normal(xMax/2, .2);
    d3.range(master[id].n);
    
    master[id].data = data;
    // if (data === undefined) {
    //     master[id].data = d3.range(master[id].n).map(master[id].random);
    // }
    
    master[id].margin = {top: 20, right: 20, bottom: 20, left: 40};
    
    master[id].width = config.width === undefined ? 500 : config.width;
    master[id].height = config.height === undefined ? 300 : config.height;
    
    master[id].x = d3.scale.linear()
    .domain([0, master[id].n - 1])
    .range([0, master[id].width]);
    
    master[id].y = d3.scale.linear()
    .domain([xMax, 0])
    .range([master[id].height, 0]);
    
    master[id].line = d3.svg.line()
    .x(function(d, i) { return master[id].x(i); })
    .y(function(d, i) { return master[id].y(d); });
    
    master[id].svg = d3.select("body").append("svg").attr("id", id)
    .attr("width", 300 + master[id].margin.left + master[id].margin.right)
    .attr("height", master[id].width + master[id].margin.top + master[id].margin.bottom)
    .append("g")
    .attr("transform", "translate(" + master[id].margin.left + "," + master[id].width + "), rotate(-90)");
    
    master[id].svg.append("defs").append("clipPath")
    .attr("id", "clip")
    .append("rect")
    .attr("width", master[id].width)
    .attr("height", master[id].height);
    
    master[id].svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(0,0)")
    .call(d3.svg.axis().scale(master[id].x).orient("top"))
    .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "-.8em")
    .attr("dy", "1.2em")
    .attr("transform", function(d) {
          return "rotate(90)"
          });
    
    master[id].svg.append("g")
    .attr("class", "y axis")
    .call(d3.svg.axis().scale(master[id].y).orient("left"))
    .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "1.3em")
    .attr("dy", "1.5em")
    .attr("transform", function(d) {
          return "rotate(90)"
          });
    
    master[id].path = master[id].svg.append("g")
    .attr("clip-path", "url(#clip)")
    .append("path")
    .datum(master[id].data)
    .attr("class", "line")
    .attr("d", master[id].line);
    
}

master.tick = function (val, pid) {
    //master[pid].tick(val);
    
    // push a new data point onto the back
    // data.push(random());
    master[pid].data.push(val);
    
    // redraw the line, and slide it to the left
    master[pid].path
    .attr("d", master[pid].line)
    .attr("transform", null)
    .transition()
    .duration(250)
    .ease("linear")
    .attr("transform", "translate(" + master[pid].x(-0.1) + ", 0)");
    // .each("end", tick);
    
    // pop the old data point off the front
    if (master[pid].data.length >= master[pid].n + 1) {
        // redraw the line, and slide it to the left
        master[pid].path
        .attr("d", master[id].line)
        .attr("transform", null)
        .transition()
        .duration(250)
        .ease("linear")
        .attr("transform", "translate(" + master[pid].x(-0.1) + ", 0)");
        // .each("end", tick);
        xAxisMin += 1;
        xAxisMax += 1;
        
        //redraws xAxis to increase
        master[pid].svg.selectAll("g.x.axis")
        .call(d3.svg.axis().scale(
                                  d3.scale.linear()
                                  .domain([xAxisMin, xAxisMax - 1])
                                  .range([0, master[pid].width]))
              .orient("top"))
        .selectAll("text")
        .style("text-anchor", "end")
        .attr("dx", "-.8em")
        .attr("dy", "1.2em")
        .attr("transform", function(d) {
              return "rotate(90)" 
              });
        
        master[pid].data.shift();
    }
}