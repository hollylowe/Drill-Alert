/**
 * master is an object that contains all the graphing logic to create and update plots.
 * master has 2 main functions--init and tick--which creates and updates a plot respectively.
 */
master = {};

/**
 * master.init takes in a config object --> master.init(config)
 *  where config contains the information needed to create a plot
 * 
 * config example: 
 * config = {yMax : 10, 
 *           xMax : 10, 
 *           data : [1, 2, 3, 4, 5,2,3,4,5,2,7,3,6,8], 
 *           idata: [0, 1, 2, 3, 4,5,6,7,8,9,10,11,12,13]
 *           width : 500, 
 *           height : 300, 
 *           id : 0}
*/
master.init = function (config) {

    id = config.id;

    master[id] = {};

    yMax = config.yMax;
    xMax = config.xMax;

    data = config.data;
    // n = max amount of data to be displayed on the y axis (domain max for y axis)
    master[id].n = yMax;
    master[id].random = d3.random.normal(xMax/2, .2);
    //d3.range(master[id].n);

    master[id].data = data;
    master[id].idata = config.idata;

    master[id].xAxisMin = 0; 
    master[id].xAxisMax = yMax >= d3.max(master[id].idata) ? yMax : d3.max(master[id].idata);
    
    if (master[id].data === undefined || master[id].idata === undefined) {
        alert('Both data and idata must be defined');
    }

    // if (data === undefined) {
    //     master[id].data = d3.range(master[id].n).map(master[id].random);
    // }

    master[id].margin = {top: 20, right: 20, bottom: 20, left: 40};
    
    master[id].width = config.width === undefined ? 500 : config.width;
    master[id].height = config.height === undefined ? 300 : config.height;

    master[id].x = d3.scale.linear()
    .domain([master[id].n - 1, 0])
    .range([0, master[id].width]);

    master[id].y = d3.scale.linear()
    .domain([xMax, 0])
    .range([master[id].height, 0]);

    // Properties for x-axis (tick size, length, etc)
    master[id].xAxis = d3.svg.axis()
    .scale(master[id].x)
    .orient("top");
    
    // Properties for y-axis (tick size, length, etc)
    master[id].yAxis = d3.svg.axis()
    .scale(master[id].y)
    .orient("right");

    master[id].line = d3.svg.line()
    .x(function(d, i) { return master[id].x(master[id].idata[i]); })
    .y(function(d, i) { return master[id].y(d); });

    // Creating the svg for the plots
    master[id].svg = d3.select("body").append("svg").attr("id", id)
    .attr("width", master[id].height + master[id].margin.left + master[id].margin.right)
    .attr("height", master[id].width + master[id].margin.top + master[id].margin.bottom)
    .append("g")
    .attr("transform", "translate(" + master[id].margin.left + "," + master[id].width + "), rotate(-90)");

    // Creating the x axis and making it pretty
    master[id].svg.append("g")
    .attr("class", "x axis")
    .attr("transform", "translate(-25,0)")
    .call(master[id].xAxis)
    .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "-.8em")
    .attr("dy", "1.2em")
    .attr("transform", rotate90);

    // Creating the y axis and making it pretty
    master[id].svg.append("g")
    .attr("class", "y axis")
    .call(master[id].yAxis)
    .attr("transform", "translate("+ (master[id].width-25) +")")
    .selectAll("text")
    .style("text-anchor", "end")
    .attr("dx", "-0.4em")
    .attr("dy", "-1.0em")
    .attr("transform", rotate90);

    // Base rectangle of plot (used for dragging?)
    master[id].svg.append("g")
    .append("rect")
    .attr("id", "base")
    .attr("width", master[id].width)
    .attr("height", master[id].height)
    .attr("transform", "translate(-25,0)")

    // Creating the clipPath
    master[id].svg.append("clipPath")
    .attr("id", "clip")
    .append("rect")
    .attr("width", master[id].width)
    .attr("height", master[id].height)
    .attr("transform", "translate(-25,0)");
    
    // Adding the data specified in the config
    master[id].path = master[id].svg.append("g")
    .attr("clip-path", "url(#clip)")
    .append("path")
    .datum(master[id].data)
    .attr("class", "line")
    .attr("d", master[id].line)
    .attr("transform", "translate(-25,0)");

    // Dragging behavior (zooming not [yet] implemented)
    master[id].zoom = d3.behavior.zoom()
        .scaleExtent([1,1])
        .x(master[id].x)
        .on("zoom", function() {
            var t = master[id].zoom.translate(),
                tx = t[0],
                ty = t[1]; // Not implemented
            // Set the max and min bounds of dragging (may need adjustments if new data going down is NEGATIVE instead of current's POSITIVE new data)
            //  For min: Length of data * Size of tick size in pixels
            tx = Math.min(tx,(master[id].xAxisMax-master[id].n + 2) * (master[id].width)/(master[id].n - 1));
            tx = Math.max(tx,0);
            master[id].zoom.translate([tx,ty]);
            
            // Redraw line so it moves
            master[id].svg.selectAll("path.line").attr("d", master[id].line);
            // Redraw x axis so it moves
            master[id].svg.select(".x.axis")
                .call(master[id].xAxis)
                .selectAll("text")
                .style("text-anchor", "end")
                .attr("dx", "-.8em")
                .attr("dy", "1.2em")
                .attr("transform", rotate90);
        });
        
    master[id].svg.call(master[id].zoom);
}

/**
 * master.tick takes in a data point and an id referring to a created plot --> master.tick(data, id)
 */
master.tick = function (val, time, pid) {
    // push a new data point onto the back
    // data.push(random());
    master[pid].data.push(val);
    master[pid].idata.push(time);
    
    // redraw the line, and slide it to the left
    master[pid].path
    .attr("d", master[pid].line);
    
    // pop the old data point off the front
    if (time >= master[pid].n) {
        //Change the size of current data for drag to increase
        master[pid].xAxisMax = d3.max(master[pid].idata);
    }
}

/**
 * master.tickBulk takes in arrays of data and updates it to the plot 
 * as opposed to master.tick, which updates the plot one point at a time
 */
master.tickBulk = function (vals, times, pid) {
    if (vals.length == times.length) {
        for (i=0; i<vals.length; i++) {
            master.tick(vals[i], times[i], pid);
        }
    }
}

/**
 *  Helper function used to help rotate certain elements 90 degrees
 */
function rotate90(d) {
    return "rotate(90)";
}
