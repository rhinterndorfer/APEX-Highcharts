// version 0.1
! function (apexHighcharts, $, server, util, debug) {
    "use strict";

    apexHighcharts.chart = {
        init: function (pRegionSelector, pApexAjaxIdentifier, initCodeCallback) {
            console.log(`Init highchart for region ${pRegionSelector} and ajax ${pApexAjaxIdentifier}`);
            
            $(pRegionSelector).on("apexrefresh",function(){
                apexHighcharts.chart.load(pRegionSelector, pApexAjaxIdentifier, initCodeCallback);
            });

            apexHighcharts.chart.load(pRegionSelector, pApexAjaxIdentifier, initCodeCallback);
        },
        load: function(pRegionSelector, pApexAjaxIdentifier, initCodeCallback){
            console.log(`Load highchart data for region ${pRegionSelector}`);
            server.plugin(pApexAjaxIdentifier, {}, {
                success: function (pData) {
                    console.log(pData);
                    apexHighcharts.chart.render(pRegionSelector, pData, initCodeCallback);
                }
            });
        },
        render: function(pRegionSelector, pData, initCodeCallback) {
            console.log(`Render highchart for region ${pRegionSelector}`);
            
            var highchartsOption = Highcharts.getOptions();
            highchartsOption.chart = highchartsOption.chart || {};
            highchartsOption.credits = highchartsOption.credits || {};
            highchartsOption.title = highchartsOption.title || {};
            highchartsOption.legend = highchartsOption.legend || {};
            highchartsOption.exporting = highchartsOption.exporting || {};


            highchartsOption.chart.renderTo = $(pRegionSelector + "_chart")[0];
            // settings
            highchartsOption.credits.enabled = false;

            highchartsOption.chart.backgroundColor = pData.background_color;
            highchartsOption.chart.zoomType = pData.zoom_type == "NONE" ? undefined : pData.zoom_type;

            highchartsOption.title.text = pData.title;
            highchartsOption.title.verticalAlign = 'top';
            
            highchartsOption.legend.enabled = pData.display_legend == "N" ? false : true;
            
            highchartsOption.exporting.enabled = pData.allow_exporting == "N" ? false : true;

            
            // dynamic settings
            var userChartOption = pData.chartOptions[0];
            highchartsOption = Highcharts.merge(highchartsOption, userChartOption);
            
            
            if(initCodeCallback){
                initCodeCallback(highchartsOption);
            }

            var chart = new Highcharts.Chart(highchartsOption);

            // add series
            $(pRegionSelector).find('.div-APEX-Highcharts-Serie').each(function(i, element){
                var ajaxId = $(element).attr('ajax-id');
                var initCodeFuncStr = $(element).attr('initCode');
                var elementId = $(element).attr('id');
                console.log(`Load highchart serie for region ${elementId}`);
                server.plugin(ajaxId, {}, {
                    success: function (pData) {
                        apexHighcharts.chart.addSerie(i, chart, pData, initCodeFuncStr);
                    }
                });
            });
        },
        addSerie: function(pIndex, pChart, pData, pInitCodeFuncStr){
            console.log(pData);
            if(!pData.index) { pData.index = pIndex; }
            if(!pData.legendIndex) { pData.legendIndex = pIndex; }
            if(!pData.zIndex) { pData.zIndex = pIndex; }
            
            var serie = pChart.addSeries(pData, false, true);
            var func = new Function("return "+pInitCodeFuncStr);
            func()(serie);
            pChart.redraw();
        }
    }
}(window.apexHighcharts = window.apexHighcharts || {}, apex.jQuery, apex.server, apex.util, apex.debug);