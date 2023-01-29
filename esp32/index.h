const char HOME[] PROGMEM = R"=====(
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style>
           .flex-wrapper {
            display: flex;
            flex-flow: row nowrap;
		    }

            .single-chart {
            width: 100%;
            justify-content: space-around ;
            }

            .circular-chart {
            display: block;
            margin: 10px auto;
            max-width: 100%;
            max-height: 250px;
            }

            .circle-bg {
            fill: none;
            stroke: #eee;
            stroke-width: 3.8;
            }

            .circle {
            fill: none;
            stroke-width: 2.8;
            stroke-linecap: round;
            }

            @keyframes progress {
            0% {
            stroke-dasharray: 0 100;
            }
            }

            .circular-chart.yellow .circle {
            stroke: #d6e41a;
            }

            .circular-chart.blue .circle {
            stroke: #3c9ee5;
            }

            .percentage {
            fill: #666;
            font-family: sans-serif;
            font-size: 0.5em;
            text-anchor: middle;
            }
        </style>
    </head>
    
    <body>
        <div class="flex-wrapper">
            <div id="battery-svg" class="single-chart">
            </div>  
        </div>   

        <div class="flex-wrapper">
            <div id="humidity-svg" class="single-chart">
            </div>  
        </div>  

        <script>
            var battery = 0.0;
            var relativeHumidity = 0;
            var periodicCheck;

            updateCharts("80", "38");
            function updateCharts(batteryPercentage, humidityPercenage) {
                var svg = `
                <h1 align = center> Batería</h1>
                <svg viewBox="0 0 36 36" class="circular-chart yellow">
                    <path  class="circle-bg"
                    d="M18 2.0845
                        a 15.9155 15.9155 0 0 1 0 31.831
                        a 15.9155 15.9155 0 0 1 0 -31.831"
                    />
                    <path id="battery-graphic" class="circle"
                    stroke-dasharray="`+batteryPercentage+` ,100"
                    d="M18 2.0845
                        a 15.9155 15.9155 0 0 1 0 31.831
                        a 15.9155 15.9155 0 0 1 0 -31.831"
                    />
                    <text x="18" y="20.35" id="battery-value" class="percentage">`+batteryPercentage+`%</text>
                </svg>`;
                document.getElementById("battery-svg").innerHTML= svg;

                var svg = `
                <h1 align = center> Humedad</h1>
                <svg viewBox="0 0 36 36" class="circular-chart blue">
                    <path  class="circle-bg"
                    d="M18 2.0845
                        a 15.9155 15.9155 0 0 1 0 31.831
                        a 15.9155 15.9155 0 0 1 0 -31.831"
                    />
                    <path id="battery-graphic" class="circle"
                    stroke-dasharray="`+humidityPercenage+` ,100"
                    d="M18 2.0845
                        a 15.9155 15.9155 0 0 1 0 31.831
                        a 15.9155 15.9155 0 0 1 0 -31.831"
                    />
                    <text x="18" y="20.35" id="battery-value" class="percentage">`+humidityPercenage+`%</text>
                </svg>`;
                document.getElementById("humidity-svg").innerHTML= svg;
            }

            function getDataFromServer()
            {
                var xmlhttp = new XMLHttpRequest();
                xmlhttp.onreadystatechange = function() {
                    if (this.readyState == 4 && this.status == 200) {
                        var myObj = JSON.parse(this.responseText);
                        battery = parseFloat(myObj.battery);
                        relativeHumidity = parseFloat(myObj.humidity);
                        updateView();
                    }
                };
                xmlhttp.open("GET", "/getSensorData");
                xmlhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
                xmlhttp.send();
            }

            function updateView(){
                updateCharts(battery, relativeHumidity);
            }
            
            function startDataChecks(){
                periodicCheck = setInterval(getDataFromServer, 2500);
            }

            function stopDataChecks(){
                clearInterval(periodicCheck);
            }
            
            getDataFromServer();
            startDataChecks();
        </script>
    </body>
</html>
)=====";