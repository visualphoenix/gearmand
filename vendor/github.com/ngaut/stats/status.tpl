<!DOCTYPE html>
<html>
<head>
<title>Status for {{.BinaryName}}</title>
<style>
body {
font-family: sans-serif;
}
h1 {
clear: both;
width: 100%;
text-align: center;
font-size: 120%;
background: #eef;
}
.lefthand {
float: left;
width: 80%;
}
.righthand {
text-align: right;
}
</style>
</head>

<h1>Status for {{.BinaryName}}</h1>

<div>
<div class=lefthand>
Started: {{.StartTime}}<br>
</div>
<div class=righthand>
Running on {{.Hostname}}<br>
View <a href=/debug/vars>variables</a>,
     <a href=/debug/pprof>debugging profiles</a>,
</div>
</div>

State: {{.State}}<br>
<div id="state_chart">{{.Key}}</div>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javascript">
 
google.load("jquery", "1.4.0");
google.load("visualization", "1", {packages:["corechart"]});
 
function minutesAgo(d, i) {
  var copy = new Date(d);
  copy.setMinutes(copy.getMinutes() - i);
  return copy
}
 
function drawQPSChart() {
  var div = $('#state_chart').height(500).width(900).unwrap()[0]
  var chart = new google.visualization.LineChart(div);
 
  var options = {
    title: '{{.Key}}',
    focusTarget: 'category',
    vAxis: {
      viewWindow: {min: 0},
    }
  };

  var start = new Date().getTime() / 1000;
 
 
  var redraw = function() {
    var sec = new Date().getTime() / 1000 - start;
    $.getJSON("/debug/stats", function(input_data) {
      // console.log(input_data);
      var l = [];
      l.push(['time', '{{.Key}}']);
      $.each(input_data['{{.Key}}'], function(e) {
        l.push([e + sec, input_data['{{.Key}}'][e]])
      })
      console.log(l);
      chart.draw(google.visualization.arrayToDataTable(l), options);
    })
  };
 
  redraw();
 
  // redraw every 3 seconds.
  window.setInterval(redraw, 3000);
}
google.setOnLoadCallback(drawQPSChart);
</script>
</html> 



