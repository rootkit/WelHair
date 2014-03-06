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
        var map = new BMap.Map('company-map');
        var point = new BMap.Point(document.getElementById('longitude').value, document.getElementById('latitude').value);
        map.centerAndZoom(point, 15);
        map.enableScrollWheelZoom();

        var marker = new BMap.Marker(point, {
            enableMassClear: false,
            raiseOnDrag: true
        });
        marker.enableDragging();
        marker.addEventListener('dragend', function(e) {
            setMapResult(e.point.lng, e.point.lat);
        });

        map.addOverlay(marker);

        map.addEventListener('click', function(e){
            if(!(e.overlay)){
                map.clearOverlays();
                marker.show();
                marker.setPosition(e.point);

                setMapResult(e.point.lng, e.point.lat);
            }
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

    function initUploader() {
        var liUploader = $('#company-image-uploader').parent().parent();
        function updateLiUploaderStatus() {
            if ($('input[name="company_picture_url[]"]').length >= 3) {
                liUploader.hide();
            } else {
                liUploader.show();
            }
        }
        function bindRemove() {
            $('.formimglst .remove-thumb').click(function() {
                $(this).parent().fadeOut('normal', function() {
                    $(this).remove();
                    updateLiUploaderStatus();
                });

                return false;
            });
        }
        bindRemove();

        var popup = $(' \
            <div class="crop-container"> \
                <div class="crop-content"> \
                    <img class="crop-img-o" src=""/> \
                    <input type="hidden" name="x1" value="" /> \
                    <input type="hidden" name="y1" value="" /> \
                    <input type="hidden" name="x2" value="" /> \
                    <input type="hidden" name="y2" value="" /> \
                </div> \
                <div class="crop-preview"> \
                    <p>拖拽或缩放曲线框，<br/>生成方形图片。</p> \
                    <div class="crop-preview-110"> \
                        <img class="crop-img-preview-110" src="" /> \
                    </div> \
                    <p>110*110像素</p> \
                    <div class="crop-preview-64"> \
                        <img class="crop-img-preview-64" src="" /> \
                    </div> \
                    <p>64*64像素</p> \
                    <div class="crop-preview-30"> \
                        <img class="crop-img-preview-30" src="" /> \
                    </div> \
                    <p>30*30像素</p> \
                </div> \
            </div> \
        ');

        $('#company-image-uploader').uploadify({
            fileObjName: 'uploadfile',
            width: 102,
            height: 102,
            multi: false,
            checkExisting: false,
            preventCaching: false,
            fileExt: '*.jpg;*.jpeg;*.png',
            fileDesc: 'Image file (.jpg, .jpeg, .png)',
            buttonText: '<i class="iconfont">&#xf0175;</i>',
            swf: WF.setting.staticAssetBaseUrl + '/swf/uploadify.swf',
            uploader: WF.setting.apiBaseUrl + '/upload/image',
            onUploadError: function(file, errorCode, errorMsg, errorString) {
                console.log(errorString);
            },
            onUploadSuccess: function(file, data, response) {
                var result = $.parseJSON(data);
                if (result.success !== false) {
                    var imgTemplate = $(' \
                        <li> \
                            <span class="u-img2"> \
                                <a href="javascript:;"> \
                                    <img class="company-picture" /> \
                                </a> \
                            </span> \
                            <input type="hidden" value="" name="company_picture_url[]" /> \
                            <a class="company-picture-update update-thumb" href="#">调整缩略图</a> \
                            <a class="remove-thumb" href="#">移除</a> \
                        </li> \
                    ');

                    imgTemplate.find('img').attr('src', result.Thumb110Url)
                                           .attr('data-110', result.Thumb110Url)
                                           .attr('data-ori', result.OriginalUrl);
                    imgTemplate.find('input[type=hidden]').val(result.Thumb480Url);

                    imgTemplate.insertBefore(liUploader).hide().fadeIn();

                    bindRemove();

                    imgTemplate.find('.update-thumb').click(function() {
                        var crop = null;
                        var img = $(this).parent().find('.company-picture');
                        var imgUrl = img.attr('data-ori');
                        if (!imgUrl) {
                            WF.showMessage('error', '注意', '请先上传一张图片');
                            return false;
                        }

                        $(popup).dialog({
                            resizable: false,
                            title: '编辑缩略图',
                            width: 600,
                            height:500,
                            modal: true,
                            draggable: false,
                            buttons: {
                                '保存': function() {
                                    var opts = {
                                        type: 'POST',
                                        url: WF.setting.apiBaseUrl + '/upload/image/crop',
                                        dataType: 'json',
                                        data: {
                                            x1: $('input[name="x1"]').val(),
                                            y1: $('input[name="y1"]').val(),
                                            x2: $('input[name="x2"]').val(),
                                            y2: $('input[name="y2"]').val(),
                                            img: img.attr('data-ori')
                                        },
                                        success: function(data, textStatus, jqXHR) {
                                            img.attr('src', img.attr('data-110') + '?timestamp=' + new Date().getTime());
                                            popup.dialog('close');
                                        }
                                    };
                                    $.ajax(opts);
                                },
                                '取消': function() {
                                    $(this).dialog('close');
                                }
                            },
                            open: function() {
                                var imgO = popup.find('.crop-img-o');
                                imgO.attr('src', imgUrl);

                                var imgPreview110 = popup.find('.crop-img-preview-110');
                                imgPreview110.attr('src', imgUrl).removeAttr('style');

                                var imgPreview64 = popup.find('.crop-img-preview-64');
                                imgPreview64.attr('src', imgUrl).removeAttr('style');

                                var imgPreview30 = popup.find('.crop-img-preview-30');
                                imgPreview30.attr('src', imgUrl).removeAttr('style');

                                WF.getImageSize(imgUrl, function(width, height) {
                                    if (width >= height) {
                                        imgO.css('width', imgO.parent().width())
                                            .css('height', 'auto')
                                            .css('margin-top', (imgO.parent().height() - imgO.height()) / 2)
                                            .show();
                                    } else {
                                        imgO.css('height', imgO.parent().height())
                                        .css('width', 'auto')
                                        .css('margin-left', (imgO.parent().width() - imgO.width()) / 2)
                                        .show();
                                    }

                                    crop = imgO.imgAreaSelect({
                                        instance: true,
                                        handles: true,
                                        aspectRatio: '1:1',
                                        onSelectEnd: function(img, selection) {
                                            var rate = width / imgO.width();

                                            $('input[name="x1"]').val(selection.x1 * rate);
                                            $('input[name="y1"]').val(selection.y1 * rate);
                                            $('input[name="x2"]').val(selection.x2 * rate);
                                            $('input[name="y2"]').val(selection.y2 * rate);
                                        },
                                        onSelectChange: function(img, selection) {
                                            var imgOWith = imgO.width();
                                            var imgOHeight = imgO.height();

                                            var scaleX = 110 / (selection.width || 1);
                                            var scaleY = 110 / (selection.height || 1);
                                            imgPreview110.css({
                                                width: Math.round(scaleX * imgOWith) + 'px',
                                                height: Math.round(scaleY * imgOHeight) + 'px',
                                                marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
                                                marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
                                            });

                                            scaleX = 64 / (selection.width || 1);
                                            scaleY = 64 / (selection.height || 1);
                                            imgPreview64.css({
                                                width: Math.round(scaleX * imgOWith) + 'px',
                                                height: Math.round(scaleY * imgOHeight) + 'px',
                                                marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
                                                marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
                                            });

                                            scaleX = 30 / (selection.width || 1);
                                            scaleY = 30 / (selection.height || 1);
                                            imgPreview30.css({
                                                width: Math.round(scaleX * imgOWith) + 'px',
                                                height: Math.round(scaleY * imgOHeight) + 'px',
                                                marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
                                                marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
                                            });
                                        }
                                    });
                                });
                            },
                            close: function() {
                                if (crop) {
                                    crop.remove(true);
                                }
                                popup.dialog('destroy').remove();
                            }
                        });

                        return false;
                    });

                    updateLiUploaderStatus();
                } else {
                    WF.showMessage('error', '错误', '上传失败，请重试！');
                }
            }
        });
    }

    initMap();
    initUploader();
    WF.initAreaSelector();
});