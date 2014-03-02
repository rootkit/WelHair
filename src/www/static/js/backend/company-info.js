// ==============================================================================
//
// This file is part of the WelStory.
//
// Create by Welfony Support <support@welfony.com>
// Copyright (c) 2012-2014 welfony.com
//
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code.
//
// ==============================================================================

$(function() {
    $('#frm-company-info').Validform({
        tiptype: 3
    });

    function initMap() {
        var center = '济南市';

        var map = new BMap.Map('company-map');
        map.enableScrollWheelZoom();

        var marker = new BMap.Marker(new BMap.Point(116.404, 39.915), {
            enableMassClear: false,
            raiseOnDrag: true
        });
        marker.enableDragging();
        map.addOverlay(marker);

        map.addEventListener('click', function(e){
            if(!(e.overlay)){
                map.clearOverlays();
                marker.show();
                marker.setPosition(e.point);

                setMapResult(e.point.lng, e.point.lat);
            }
        });
        marker.addEventListener('dragend', function(e) {
            setMapResult(e.point.lng, e.point.lat);
        });

        var local = new BMap.LocalSearch(map, {
            renderOptions:{map: map},
            pageCapacity: 1
        });
        local.setSearchCompleteCallback(function(results) {
            if(local.getStatus() !== BMAP_STATUS_SUCCESS) {
                WF.showMessage('info', '信息', '没有找到您所输入的区域信息');
            } else {
                 marker.hide();

                 var poi = results.getPoi(0);
                 if (poi) {
                    setMapResult(poi.point.lng, poi.point.lat);
                 }
             }
        });
        local.setMarkersSetCallback(function(pois) {
            for (var i = pois.length; i--;) {
                var marker = pois[i].marker;
                marker.addEventListener('click', function(e) {
                    marker_trick = true;

                    var pos = this.getPosition();
                    setMapResult(pos.lng, pos.lat);
                });
            }
        });

        local.search(center);
        document.getElementById('map-search').onclick = function() {
            local.search(document.getElementById('map-search-input').value);
        };
        document.getElementById('map-search-input').onkeyup = function(e) {
            console.log('a');
            var me = this;
            e = e || window.event;
            var keycode = e.keyCode;
            if (keycode === 13) {
                local.search(document.getElementById('map-search-input').value);
            }
        };
    }

    function setMapResult(lng, lat) {
        document.getElementById('latitude').value = lat;
        document.getElementById('longitude').value = lng;
    }

    initMap();
});