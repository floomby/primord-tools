var colors = ["red", "blue", "green", "yellow"]

// dimensions
var h_timeline = 1000;
var v_timeline = 100;
var h_pad = 10;
var v_pad = 5;

var dataset = [];
var ws = new WebSocket("ws://localhost:8001/ws");

ws.onopen = function () {
    console.log('connected');
}
    
ws.onclose = function () {
    console.log('closed');
}
    
ws.onerror = function (ev) {
    console.log('error: ' + ev.data);
}

var header;
var waiting_for_header = true;

ws.onmessage = function(ev){
    if(waiting_for_header){
        header = JSON.parse(ev.data);
        waiting_for_header = false;
        go();
    }else{
        var obj = JSON.parse(ev.data);
        obj.date = new Date().setTime(obj.date);
        console.log(obj);
        dataset.push(obj);
    }
}

function go()
{

// scales
var time_scale = d3.time
    .scale()
    .domain([
        new Date().setTime(header.time_min),
        new Date().setTime(header.time_max)])
    .range([h_pad, h_timeline - h_pad]);

var v_scale = d3.scale
    .linear()
    .domain(header.categories)
    .range([v_pad, (v_timeline / 2) - v_pad]);

// timeline svg
var timeline = d3
    .select("body")
    .append("svg")
    .attr("width", h_timeline)
    .attr("height", v_timeline);

var time_axis = d3.svg
    .axis()
    .scale(time_scale)
    .orient("bottom");

timeline
    .append("g")
    .attr("class", "axis")
    .attr("transform", "translate(0," + v_timeline / 2 + ")");

    
timeline
    .append("rect")
    .attr("class", "pane")
    .attr("width", h_timeline)
    .attr("height", v_timeline)
    .call(d3.behavior.zoom()
        .on("zoom", draw)
        .x(time_scale)
        .scaleExtent([1, 300000])
    );

timeline
    .append("line")
    .attr("class", "sep")
    .attr("x1", 0)
    .attr("x2", h_pad)
    .attr("y1", v_timeline / 2)
    .attr("y2", v_timeline / 2);
timeline
    .append("line")
    .attr("class", "sep")
    .attr("x1", h_timeline)
    .attr("x2", h_timeline - h_pad)
    .attr("y1", v_timeline / 2)
    .attr("y2", v_timeline / 2);


// print out details at the bottom of the page
var curr = d3
    .select("body")
    .append("p");


/*
var area = d3.svg.area()
    .x(function(d){return time_scale(d[0])})
    .y0(timeline_height / 2)
    .y1(function(d){return y_scale(d[1])});
*/

draw();

function draw()
{
    //timeline
    //    .selectAll("path")
    //    .remove();
        
    timeline
        .selectAll("circle")
        .remove();
    
    timeline.select("g.axis")
        .call(time_axis);
    
    //timeline
    //    .append("path")
    //    .datum(dataset)
    //    .attr("d", area)
    //    .attr("class", "area");
    
    timeline
        .selectAll("circle")
        .data(dataset)
        .enter()
        .append("circle")
        .attr("cx", function(d){
            return time_scale(d.date);
        })
        .attr("cy", function(d){
            return v_scale(d.category);
        })
        .attr("r", 3)
        .attr("fill", function(d){
            return colors[d.category];
        })
        .attr("class", "datapoint")
        //.on("mouseover", function(d){
        //    curr.html(
        //        d.date + "<br>" +
        //        "Frequency: " + d.freq + "<br>" +
        //        "This data point is found in: <a href=\"data/" + d.file + "\">" + d.file + "</a>"
        //    );
        //})
        .on("click", function(d){console.log("you clicked me")});
}

} // end function go


console.log("waiting for header");
