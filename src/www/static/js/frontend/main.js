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

WF = {
    setting: {},
    init: function(setting) {
        this.setting = $.extend(this.setting, setting);
        $.pnotify.defaults.styling = 'jqueryui';

        if ($('#error-message').text() != '') {
            this.showMessage('error', '警告', $('#error-message').html());
        }
        if ($('#success-message').text() != '') {
            this.showMessage('success', '信息', $('#success-message').html());
        }

        this.initUI();
    },
    initUI: function() {
        $.Datatype.tel = /^((\d{3,4})|\d{3,4}-)?\d{7,8}(-\d+)*$/i;
        $.Datatype.float = /^\d+\.?\d*$/i;

        $('.sidebar .lists li').hover(
            function() {
                $('.sidebar .lists li').removeClass('on');
                $(this).addClass('on');
            },
            function() {
                $('.sidebar .lists li').removeClass('on');
            }
        );

        $('.u-btn-submit').click(function() {
            $(this).parent().parent().parent().submit();
        });

        $('#chk_all').click(function() {
            var checked_status = this.checked;
            $('input[name="chk_ids[]"]').each(function()
            {
                this.checked = checked_status;
                $(this).trigger('change');
            });
        });

        $('.loginbt').hover(
            function() {
                $(this).find('.header-tc-content').show();
            },
            function() {
                $(this).find('.header-tc-content').hide();
            }
        );

        initButtonSet($('body'));

        $.datepicker.regional['zh-CN'] = {
            closeText: '关闭',
            prevText: '&#x3C;上月',
            nextText: '下月&#x3E;',
            currentText: '今天',
            monthNames: ['一月','二月','三月','四月','五月','六月',
            '七月','八月','九月','十月','十一月','十二月'],
            monthNamesShort: ['一月','二月','三月','四月','五月','六月',
            '七月','八月','九月','十月','十一月','十二月'],
            dayNames: ['星期日','星期一','星期二','星期三','星期四','星期五','星期六'],
            dayNamesShort: ['周日','周一','周二','周三','周四','周五','周六'],
            dayNamesMin: ['日','一','二','三','四','五','六'],
            weekHeader: '周',
            dateFormat: 'yy-mm-dd',
            firstDay: 1,
            isRTL: false,
            showMonthAfterYear: true,
            yearSuffix: '年'};
        $.datepicker.setDefaults($.datepicker.regional['zh-CN']);

        $.timepicker.regional['zh-CN'] = {
            timeOnlyTitle: '选择时间',
            timeText: '时间',
            hourText: '小时',
            minuteText: '分钟',
            secondText: '秒钟',
            millisecText: '微秒',
            microsecText: '微秒',
            timezoneText: '时区',
            currentText: '现在时间',
            closeText: '关闭',
            timeFormat: 'HH:mm',
            amNames: ['AM', 'A'],
            pmNames: ['PM', 'P'],
            isRTL: false
        };
        $.timepicker.setDefaults($.timepicker.regional['zh-CN']);

        $('.datetime').datetimepicker({
            timeFormat: "HH:mm",
            dateFormat: "yy-mm-dd"
        });
    },
    initAreaSelector: function() {
        function fillAreaSel(parentId, target) {
            target.empty().append('<option value="">请选择</option>');
            $('#sel-district').empty().append('<option value="">请选择</option>');

            if (!parentId) {
                return;
            }

            var opts = {
                type: "GET",
                url: '/ajax/area/list',
                contentType: "application/json",
                data: "pid=" + parentId,
                success: function(data) {
                    if (data.length > 0) {
                        for (var i = 0; i < data.length; i++) {
                            target.append('<option value="' + data[i].AreaId + '">' + data[i].Name + '</option>');
                        }
                    }
                    target.val('').change();
                }
            };
            $.ajax(opts);
        }
        $('#sel-province').change(function() {
            fillAreaSel($(this).val(), $('#sel-city'));
        });
        $('#sel-city').change(function() {
            fillAreaSel($(this).val(), $('#sel-district'));
        });
    },
    initAppintmentForm: function(stylistId, target) {
        var btnTrigger = window;
        if (btnTrigger.inAjax) {
            return;
        }

        btnTrigger.inAjax = true;

        $.ajax({
            type: 'get',
            dataType: 'json',
            url: '/ajax/appointment/form',
            data: {
                'stylist_id': stylistId,
                'format': 'html'
            },
            complete: function(data) {
                btnTrigger.inAjax = false;
                target.html(data.responseText);
                target.find('.datetime').datetimepicker({
                    timeFormat: "HH:mm",
                    dateFormat: "yy-mm-dd"
                });
            }
        });
    },
    initOrderForm: function(goodsId, companyId, target) {
        var btnTrigger = window;
        if (btnTrigger.inAjax) {
            return;
        }

        btnTrigger.inAjax = true;

        $.ajax({
            type: 'get',
            dataType: 'json',
            url: '/ajax/order/form',
            data: {
                'goods_id': goodsId,
                'company_id': companyId,
                'format': 'html'
            },
            complete: function(data) {
                btnTrigger.inAjax = false;
                target.html(data.responseText);

                initButtonSet($('.popup-container'), refreshPrice);
                initCounter();
                initAddressSel();

                refreshPrice();
            }
        });
    },
    getImageSize: function(imgSrc, imgLoaded) {
        var newImg = new Image();
        $(newImg).load(function(){
            imgLoaded(newImg.width, newImg.height);
        });
        newImg.src = imgSrc;
    },
    showMessage: function(type, title, message) {
        $.pnotify_remove_all();
        $.pnotify({
            type: type,
            title: title,
            text: message,
            sticker: false,
            history: false
        });
    }
};

function Base64() {

    // private property
    _keyStr = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";

    // public method for encoding
    this.encode = function (input) {
        var output = "";
        var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
        var i = 0;
        input = _utf8_encode(input);
        while (i < input.length) {
            chr1 = input.charCodeAt(i++);
            chr2 = input.charCodeAt(i++);
            chr3 = input.charCodeAt(i++);
            enc1 = chr1 >> 2;
            enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
            enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
            enc4 = chr3 & 63;
            if (isNaN(chr2)) {
                enc3 = enc4 = 64;
            } else if (isNaN(chr3)) {
                enc4 = 64;
            }
            output = output +
            _keyStr.charAt(enc1) + _keyStr.charAt(enc2) +
            _keyStr.charAt(enc3) + _keyStr.charAt(enc4);
        }
        return output;
    }

    // public method for decoding
    this.decode = function (input) {
        var output = "";
        var chr1, chr2, chr3;
        var enc1, enc2, enc3, enc4;
        var i = 0;
        input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
        while (i < input.length) {
            enc1 = _keyStr.indexOf(input.charAt(i++));
            enc2 = _keyStr.indexOf(input.charAt(i++));
            enc3 = _keyStr.indexOf(input.charAt(i++));
            enc4 = _keyStr.indexOf(input.charAt(i++));
            chr1 = (enc1 << 2) | (enc2 >> 4);
            chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
            chr3 = ((enc3 & 3) << 6) | enc4;
            output = output + String.fromCharCode(chr1);
            if (enc3 != 64) {
                output = output + String.fromCharCode(chr2);
            }
            if (enc4 != 64) {
                output = output + String.fromCharCode(chr3);
            }
        }
        output = _utf8_decode(output);
        return output;
    }

    // private method for UTF-8 encoding
    _utf8_encode = function (string) {
        string = string.replace(/\r\n/g,"\n");
        var utftext = "";
        for (var n = 0; n < string.length; n++) {
            var c = string.charCodeAt(n);
            if (c < 128) {
                utftext += String.fromCharCode(c);
            } else if((c > 127) && (c < 2048)) {
                utftext += String.fromCharCode((c >> 6) | 192);
                utftext += String.fromCharCode((c & 63) | 128);
            } else {
                utftext += String.fromCharCode((c >> 12) | 224);
                utftext += String.fromCharCode(((c >> 6) & 63) | 128);
                utftext += String.fromCharCode((c & 63) | 128);
            }

        }
        return utftext;
    }

    // private method for UTF-8 decoding
    _utf8_decode = function (utftext) {
        var string = "";
        var i = 0;
        var c = c1 = c2 = 0;
        while ( i < utftext.length ) {
            c = utftext.charCodeAt(i);
            if (c < 128) {
                string += String.fromCharCode(c);
                i++;
            } else if((c > 191) && (c < 224)) {
                c2 = utftext.charCodeAt(i+1);
                string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
                i += 2;
            } else {
                c2 = utftext.charCodeAt(i+1);
                c3 = utftext.charCodeAt(i+2);
                string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
                i += 3;
            }
        }
        return string;
    }
}

function initMap() {
  var map = new BMap.Map('company-map');
  var point = new BMap.Point(document.getElementById('longitude').value, document.getElementById('latitude').value);
  map.centerAndZoom(point, 15);

  var marker = new BMap.Marker(point, {
      enableMassClear: false,
      raiseOnDrag: false
  });

  map.addOverlay(marker);
}

function initComment(hairId, salonId, stylistId, goodsId) {
    function initUploader() {
        var liUploader = $('#comment-image-uploader').parent().parent();
        function updateLiUploaderStatus() {
            if ($('input[name="comment_picture_url[]"]').length >= 4) {
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

        $('#comment-image-uploader').uploadify({
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
                                    <img class="comment-picture" /> \
                                </a> \
                            </span> \
                            <input type="hidden" value="" name="comment_picture_url[]" /> \
                            <a style="display: inline-block; width: 55px;" href="javascript:;">&nbsp;</a> \
                            <a class="remove-thumb" href="#">移除</a> \
                        </li> \
                    ');

                    imgTemplate.find('img').attr('src', result.Thumb110Url)
                                           .attr('data-110', result.Thumb110Url)
                                           .attr('data-ori', result.OriginalUrl);
                    imgTemplate.find('input[type=hidden]').val(result.Thumb480Url);

                    imgTemplate.insertBefore(liUploader).hide().fadeIn();

                    bindRemove();

                    updateLiUploaderStatus();
                } else {
                    WF.showMessage('error', '错误', '上传失败，请重试！');
                }
            }
        });
    }

    function showDialog(hairId, salonId, stylistId, goodsId) {
        var btnTrigger = window;
        if (btnTrigger.inAjax) {
            return;
        }

        btnTrigger.inAjax = true;

        $.ajax({
            type: 'get',
            dataType: 'json',
            url: '/ajax/comment/form',
            data: {
                'goods_id': goodsId,
                'hair_id': hairId,
                'salon_id': salonId,
                'styist_id': stylistId,
                'format': 'html'
            },
            complete: function(data) {
                btnTrigger.inAjax = false;
                var popup = $(data.responseText);

                popup.dialog({
                    title: '评论',
                    width: 640,
                    height: 540,
                    modal: true,
                    resizable: 'disable',
                    buttons: [
                    {
                        text: '确定',
                        click: function () {
                            if (window.inAjax) {
                                return;
                            }

                            popup.find('.noti').text('提交中 ...');
                            window.inAjax = 1;

                            var pictureUrl = [];

                            $("input[name='comment_picture_url[]']").each(function() {
                                pictureUrl.push($(this).val());
                            });

                            $.ajax({
                                type: "post",
                                url: '/ajax/comment/create',
                                data: {
                                    'goods_id': goodsId,
                                    'hair_id': hairId,
                                    'salon_id': salonId,
                                    'styist_id': stylistId,
                                    'rate': popup.find('input[name=comment_rate]').val(),
                                    'body': popup.find('textarea[name=comment_body]').val(),
                                    'picture_url': JSON.stringify(pictureUrl)
                                },
                                success: function (data) {
                                    window.inAjax = 0;

                                    if (data.success) {
                                        popup.dialog('close');
                                        WF.showMessage('success', '信息', '添加评论成功！');

                                        if (goodsId > 0) {

                                        } else {
                                            refreshComment(1);
                                        }
                                    } else {
                                        popup.find('.noti').text(data.message);
                                    }
                                },
                                complete: function (XMLHttpRequest, textStatus) {
                                    window.inAjax = 0;
                                },
                                error: function () {
                                    window.inAjax = 0;
                                }
                            });
                        }
                    }],
                    open: function () {
                        initButtonSet($('#frm-comment-info'));
                        initUploader();
                    },
                    close: function() {
                        popup.dialog('destroy').remove();
                    }
                });
            }
        });
    }

    $('.order-comment').click(function() {
        var goodsId = $(this).attr('data-goods-id');
        showDialog(0, 0, 0, goodsId);
    });
    $('.hair-comment').click(function() {
        var hairId = $(this).attr('data-hair-id');
        showDialog(hairId, 0, 0, 0);
    });
    $('.salon-comment').click(function() {
        var salonId = $(this).attr('data-salon-id');
        showDialog(0, salonId, 0, 0);
    });

    refreshComment(1);
}

function refreshComment(page) {
    var msgList = $('#comment-list');
    $.ajax({
        type: 'get',
        dataType: 'json',
        url: '/ajax/comment/list',
        data: {
            'goods_id': msgList.attr('data-goods-id'),
            'hair_id': msgList.attr('data-hair-id'),
            'salon_id': msgList.attr('data-salon-id'),
            'styist_id': msgList.attr('data-stylist-id'),
            'page': page,
            'format': 'html'
        },
        complete: function(data) {
            msgList.html(data.responseText);
        },
        error: function () {
            window.inAjax = 0;
        }
    });
}

function initAppointAction() {
    $('.appointment-complete').click(function() {
        var appointmentId = $(this).attr('data-appointment-id');

        var popup = $('<div class="popup-container"><div class="noti info">&nbsp;</div><p style="text-align: center; margin-top: 20px;">确定已经完成该预约了么？</p></div>');
        popup.dialog({
            title: '完成预约',
            width: 400,
            height: 260,
            modal: true,
            resizable: 'disable',
            show: {
                effect: "fade",
                duration: 1000
            },
            hide: {
                effect: "fade",
                duration: 200
            },
            buttons: [
            {
                text: '确定',
                click: function () {
                    if (window.inAjax) {
                        return;
                    }

                    popup.find('.noti').text('提交中 ...');
                    window.inAjax = 1;

                    $.ajax({
                        type: "post",
                        url: '/ajax/appointment/complete',
                        data: {
                            appointment_id: appointmentId
                        },
                        success: function (data) {
                            window.inAjax = 0;

                            if (data.success) {
                                popup.dialog('close');
                                WF.showMessage('success', '信息', '完成预约成功！');

                                window.location.reload();
                            } else {
                                popup.find('.noti').text(data.message);
                            }
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            window.inAjax = 0;
                        },
                        error: function () {
                            window.inAjax = 0;
                        }
                    });
                }
            }],
            open: function () {
            },
            close: function() {
                popup.dialog('destroy').remove();
            }
        });
    });

    $('.appointment-cancel').click(function() {
        var appointmentId = $(this).attr('data-appointment-id');

        var popup = $('<div class="popup-container"><div class="noti info">&nbsp;</div><p style="text-align: center; margin-top: 20px;">确定要取消该预约了么？</p></div>');
        popup.dialog({
            title: '取消预约',
            width: 400,
            height: 260,
            modal: true,
            resizable: 'disable',
            show: {
                effect: "fade",
                duration: 1000
            },
            hide: {
                effect: "fade",
                duration: 200
            },
            buttons: [
            {
                text: '确定',
                click: function () {
                    if (window.inAjax) {
                        return;
                    }

                    popup.find('.noti').text('提交中 ...');
                    window.inAjax = 1;

                    $.ajax({
                        type: "post",
                        url: '/ajax/appointment/cancel',
                        data: {
                            appointment_id: appointmentId
                        },
                        success: function (data) {
                            window.inAjax = 0;

                            if (data.success) {
                                popup.dialog('close');
                                WF.showMessage('success', '信息', '取消预约成功！');

                                window.location.reload();
                            } else {
                                popup.find('.noti').text(data.message);
                            }
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            window.inAjax = 0;
                        },
                        error: function () {
                            window.inAjax = 0;
                        }
                    });
                }
            }],
            open: function () {
            },
            close: function() {
                popup.dialog('destroy').remove();
            }
        });
    });

    $('.appointment-note').click(function() {
        var appointmentId = $(this).attr('data-appointment-id');

    });
}

function initOrderPay() {
    $('.order-pay').click(function() {
        var orderId = $(this).attr('data-order-id');

        var popup = $('<div class="popup-container"><div class="noti info">&nbsp;</div><p style="text-align: center; margin-top: 20px;">确定要支付订单么？</p></div>');
        popup.dialog({
            title: '订单支付',
            width: 400,
            height: 260,
            modal: true,
            resizable: 'disable',
            show: {
                effect: "fade",
                duration: 1000
            },
            hide: {
                effect: "fade",
                duration: 200
            },
            buttons: [
            {
                text: '确定',
                click: function () {
                    if (window.inAjax) {
                        return;
                    }

                    popup.find('.noti').text('提交中 ...');
                    window.inAjax = 1;

                    $.ajax({
                        type: "post",
                        url: '/ajax/order/pay',
                        data: {
                            order_id: orderId
                        },
                        success: function (data) {
                            window.inAjax = 0;

                            if (data.success) {
                                popup.dialog('close');
                                WF.showMessage('success', '信息', '支付订单成功！');

                                window.location.reload();
                            } else {
                                popup.find('.noti').text(data.message);
                            }
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            window.inAjax = 0;
                        },
                        error: function () {
                            window.inAjax = 0;
                        }
                    });
                }
            }],
            open: function () {
            },
            close: function() {
                popup.dialog('destroy').remove();
            }
        });
    });
}

function initOrder() {
    $('#goods_order').click(function() {
        var goodsId = $(this).attr('data-goods-id');
        var companyId = $(this).attr('data-company-id');

        var popup = $('<div class="popup-container"></div>');
        popup.dialog({
            title: '下单',
            width: 600,
            height: 470,
            modal: true,
            resizable: 'disable',
            show: {
                effect: "fade",
                duration: 1000
            },
            hide: {
                effect: "fade",
                duration: 200
            },
            buttons: [
            {
                text: '确定下单',
                click: function () {
                    if (parseFloat($('input[name=single_price]').val()) <= 0) {
                        popup.find('.noti').text('请选择正确的商品规格');
                        return;
                    }
                    if (parseInt($('input[name=address_id]').val()) <= 0) {
                        popup.find('.noti').text('请选择收货地址');
                        return;
                    }

                    if (window.inAjax) {
                        return;
                    }

                    popup.find('.noti').text('加载中 ...');
                    window.inAjax = 1;

                    $.ajax({
                        type: "post",
                        url: '/ajax/order',
                        data: {
                            goods_id: goodsId,
                            company_id: companyId,
                            address_id: parseInt($('input[name=address_id]').val()),
                            product_id: parseInt($('input[name=product_id]').val()),
                            goods_count: parseInt($('input[name=goods_count]').val())
                        },
                        success: function (data) {
                            window.inAjax = 0;

                            if (data.success) {
                                popup.dialog('close');
                                WF.showMessage('success', '信息', '购买商品成功');
                            } else {
                                if (data.code && data.code == 2301) {
                                    $('.ui-dialog-buttonset button').attr('disabled', true);
                                    WF.showMessage('error', '信息', '请充值后到我的订单里重新支付');
                                }
                                popup.find('.noti').text(data.message);
                            }
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            window.inAjax = 0;
                        },
                        error: function () {
                            window.inAjax = 0;
                        }
                    });
                }
            }],
            open: function () {
                WF.initOrderForm(goodsId, companyId, popup);
                $('.ui-dialog-buttonpane').prepend('<div class="price-panel">订单总价<span class="price"></span>元</div>');
            },
            close: function() {
                popup.dialog('destroy').remove();
            }
        });

        return false;
    });
}

function initButtonSet(parent, callback) {
    parent.find('.u-btns.enable').find('span').click(function() {
        var cur = $(this);
        var group = cur.parent();

        if (group.attr('data-type') == 'radio') {
            group.find('span').each(function() {
                var el = $(this);
                if (el.get(0) == cur.get(0)) {
                    el.removeClass('u-btn-c4').addClass('u-btn-c5');
                } else {
                    el.removeClass('u-btn-c5').addClass('u-btn-c4');
                }
            });

            group.find('input[type=hidden]').val(cur.attr('data-value'));
        }

        if (group.attr('data-type') == 'checkbox') {
            if (cur.hasClass('u-btn-c5')) {
                cur.removeClass('u-btn-c5').addClass('u-btn-c4');
            } else {
                cur.removeClass('u-btn-c4').addClass('u-btn-c5');
            }

            var values = [];
            group.find('span.u-btn-c5').each(function() {
                var el = $(this);
                values.push(el.attr('data-value'));
            });

            group.find('input[type=hidden]').val(values.join(','));
        }

        if (callback) {
            callback();
        }
    });
}

function initAppointment() {
    $('#stylist_appointment').click(function() {
        var stylistId = $(this).attr('data-stylist-id');

        var popup = $('<div class="popup-container"></div>');
        popup.dialog({
            title: '预约',
            width: 600,
            height: 470,
            modal: true,
            resizable: 'disable',
            show: {
                effect: "fade",
                duration: 1000
            },
            hide: {
                effect: "fade",
                duration: 200
            },
            buttons: [
            {
                text: '预约',
                click: function () {
                    if (!(popup.find('input[name=service_id]').val()) > 0 || $.trim(popup.find('input[name=appointment_date]').val()) == '') {
                        popup.find('.noti').text('请选择所有信息');
                        return;
                    }

                    if (window.inAjax) {
                        return;
                    }

                    popup.find('.noti').text('加载中 ...');
                    window.inAjax = 1;

                    $.ajax({
                        type: "post",
                        url: '/ajax/appointment',
                        data: {
                            stylist_id: stylistId,
                            service_id: popup.find('input[name=service_id]').val(),
                            date: popup.find('input[name=appointment_date]').val()
                        },
                        success: function (data) {
                            window.inAjax = 0;

                            if (data.success) {
                                popup.dialog('close');
                                WF.showMessage('success', '信息', '添加预约成功');
                            } else {
                                popup.find('.noti').text(data.message);
                            }
                        },
                        complete: function (XMLHttpRequest, textStatus) {
                            window.inAjax = 0;
                        },
                        error: function () {
                            window.inAjax = 0;
                        }
                    });
                }
            }],
            open: function () {
                WF.initAppintmentForm(stylistId, popup);
            },
            close: function() {
                popup.dialog('destroy').remove();
            }
        });

        return false;
    });
}

function initSlider() {
    var browse = window.navigator.appName.toLowerCase();
    var MyMar;
    var speed = 1; //速度，越大越慢
    var spec = 1; //每次滚动的间距, 越大滚动越快
    var minOpa = 50; //滤镜最小值
    var maxOpa = 100; //滤镜最大值
    var spa = 2; //缩略图区域补充数值
    var w = 0;
    spec = (browse.indexOf("microsoft") > -1) ? spec: ((browse.indexOf("opera") > -1) ? spec * 10 : spec * 20);
    function getById(e) {
        return document.getElementById(e);
    }
    function goleft() {
        getById('photos').scrollLeft -= spec;
    }
    function goright() {
        getById('photos').scrollLeft += spec;
    }
    function setOpacity(e, n) {
        if (browse.indexOf("microsoft") > -1) e.style.filter = 'alpha(opacity=' + n + ')';
        else e.style.opacity = n / 100;
    }
    getById('goleft').style.cursor = 'pointer';
    getById('goright').style.cursor = 'pointer';
    getById('mainphoto').onmouseover = function() {
        setOpacity(this, maxOpa);
    }
    getById('mainphoto').onmouseout = function() {
        setOpacity(this, minOpa);
    }
    getById('goleft').onmouseover = function() {
        this.src = globalSetting.staticAssetBaseUrl + '/img/frontend/goleft2.gif';
        MyMar = setInterval(goleft, speed);
    }
    getById('goleft').onmouseout = function() {
        this.src = globalSetting.staticAssetBaseUrl + '/img/frontend/goleft.gif';
        clearInterval(MyMar);
    }
    getById('goright').onmouseover = function() {
        this.src = globalSetting.staticAssetBaseUrl + '/img/frontend/goright2.gif';
        MyMar = setInterval(goright, speed);
    }
    getById('goright').onmouseout = function() {
        this.src = globalSetting.staticAssetBaseUrl + '/img/frontend/goright.gif';
        clearInterval(MyMar);
    }

    $(document).ready(function() {
        setOpacity(getById('mainphoto'), minOpa);
        var rHtml = '';
        var p = getById('showArea').getElementsByTagName('img');
        for (var i = 0; i < p.length; i++) {
            w += parseInt(p[i].getAttribute('width')) + spa;
            setOpacity(p[i], minOpa);
            p[i].onmouseover = function() {
                setOpacity(this, maxOpa);
                getById('mainphoto').src = this.getAttribute('rel');
                getById('mainphoto').setAttribute('name', this.getAttribute('name'));
                setOpacity(getById('mainphoto'), maxOpa);
            }
            p[i].onmouseout = function() {
                setOpacity(this, minOpa);
                setOpacity(getById('mainphoto'), minOpa);
            }
            rHtml += '<img src="' + p[i].getAttribute('rel') + '" width="0" height="0" alt="" />';
        }
        getById('showArea').style.width = parseInt(w) + 'px';
        var rLoad = document.createElement("div");
        getById('photos').appendChild(rLoad);
        rLoad.style.width = "1px";
        rLoad.style.height = "1px";
        rLoad.style.overflow = "hidden";
        rLoad.innerHTML = rHtml;
    });
}

function initTab() {
    $('.tabList li').click(function() {
        $('.tabList li').removeClass('active');
        $(this).addClass('active');

        $('.msgList, .add-comment').hide();
        $('#' + $(this).attr('rel')).fadeIn();

        if ($(this).attr('rel') == 'comment-list') {
            $('.add-comment').fadeIn();
        }
    });
}

function initLike() {
    $('#hair_like').click(function() {
        var btn = $(this);

        var liked = btn.find('img').attr('src').indexOf('_red') > 0;
        if (liked) {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart.png');
            btn.find('p').text(parseInt(btn.find('p').text()) - 1);
        } else {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart_red.png');
            btn.find('p').text(parseInt(btn.find('p').text()) + 1);
        }

        var opts = {
            type: "GET",
            url: '/ajax/hair/like',
            contentType: "application/json",
            data: "hair_id=" + btn.attr('data-hair-id') + '&' + "is_like=" + (liked ? 0 : 1),
            success: function(data) {

            }
        };
        $.ajax(opts);

        return false;
    });

    $('#stylist_like').click(function() {
        var btn = $(this);

        var liked = btn.find('img').attr('src').indexOf('_red') > 0;
        if (liked) {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart.png');
        } else {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart_red.png');
        }

        var opts = {
            type: "GET",
            url: '/ajax/stylist/like',
            contentType: "application/json",
            data: "stylist_id=" + btn.attr('data-stylist-id') + '&' + "is_like=" + (liked ? 0 : 1),
            success: function(data) {

            }
        };
        $.ajax(opts);

        return false;
    });

    $('#goods_like').click(function() {
        var btn = $(this);

        var liked = btn.find('img').attr('src').indexOf('_red') > 0;
        if (liked) {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart.png');
        } else {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart_red.png');
        }

        var opts = {
            type: "GET",
            url: '/ajax/goods/like',
            contentType: "application/json",
            data: "goods_id=" + btn.attr('data-goods-id') + '&' + "is_like=" + (liked ? 0 : 1),
            success: function(data) {

            }
        };
        $.ajax(opts);

        return false;
    });

    $('#salon_like').click(function() {
        var btn = $(this);

        var liked = btn.find('img').attr('src').indexOf('_red') > 0;
        if (liked) {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart.png');
        } else {
            btn.find('img').attr('src', globalSetting.staticAssetBaseUrl + '/img/frontend/heart_red.png');
        }

        var opts = {
            type: "GET",
            url: '/ajax/salon/like',
            contentType: "application/json",
            data: "salon_id=" + btn.attr('data-salon-id') + '&' + "is_like=" + (liked ? 0 : 1),
            success: function(data) {

            }
        };
        $.ajax(opts);

        return false;
    });
}

function initRemoveFav() {
    $('.remove-fav').click(function() {
        var btn = $(this);
        btn.parent().parent().parent().fadeOut();

        var hairId = btn.attr('data-hair-id');
        if (hairId > 0) {
            var opts = {
                type: "GET",
                url: '/ajax/hair/like',
                contentType: "application/json",
                data: "hair_id=" + hairId + "&is_like=0",
                success: function(data) {
                    if (!data.success) {
                        btn.parent().parent().parent().fadeIn();
                    }
                }
            };
            $.ajax(opts);
        }
        var salonId = btn.attr('data-salon-id');
        if (salonId > 0) {
            var opts = {
                type: "GET",
                url: '/ajax/salon/like',
                contentType: "application/json",
                data: "salon_id=" + salonId + "&is_like=0",
                success: function(data) {
                    if (!data.success) {
                        btn.parent().parent().parent().fadeIn();
                    }
                }
            };
            $.ajax(opts);
        }
        var stylistId = btn.attr('data-stylist-id');
        if (stylistId > 0) {
            var opts = {
                type: "GET",
                url: '/ajax/stylist/like',
                contentType: "application/json",
                data: "stylist_id=" + stylistId + "&is_like=0",
                success: function(data) {
                    if (!data.success) {
                        btn.parent().parent().parent().fadeIn();
                    }
                }
            };
            $.ajax(opts);
        }
        var goodsId = btn.attr('data-goods-id');
        if (goodsId > 0) {
            var opts = {
                type: "GET",
                url: '/ajax/goods/like',
                contentType: "application/json",
                data: "goods_id=" + goodsId + '&' + "&is_like=0",
                success: function(data) {
                    if (!data.success) {
                        btn.parent().parent().parent().fadeIn();
                    }
                }
            };
            $.ajax(opts);
        }
    });
}

function initCounter() {
    $('.tb-increase').click(function() {
        var txtCount = $(this).parent().find('.tb-text');

        if (parseInt(txtCount.val()) < 100) {
            txtCount.val(parseInt(txtCount.val()) + 1);
        }

        refreshPrice();

        return false;
    });
    $('.tb-reduce').click(function() {
        var txtCount = $(this).parent().find('.tb-text');

        if (parseInt(txtCount.val()) > 1) {
            txtCount.val(parseInt(txtCount.val()) - 1);
        }

        refreshPrice();

        return false;
    });
}

function refreshPrice() {
    $('.noti').text('请选择所有信息')

    var products = $.parseJSON((new Base64()).decode($('input[name=products]').val()));
    $.each(products, function() {
        var prod = this;
        var specArr = prod.Spec;

        var match = true;
        $.each (specArr, function() {
            var spec = this;
            var specSel = $('span[data-spec-id=' + spec.Id + ']');
            if (specSel.find('.u-btn-c5').length <= 0 || specSel.find('.u-btn-c5').text() != spec.Value) {
                return match = false;
            }
        });

        if (match) {
            $('input[name=single_price]').val(prod.Price);
            $('input[name=product_id]').val(prod.ProductId);
        }
    });

    var singlePrice = parseFloat($('input[name=single_price]').val());
    if (singlePrice <= 0) {
        $('.price-panel .price, .goods-price').html('--');
    } else {
        var goodsCount = parseInt($('input[name=goods_count]').val());
        $('.goods-price').html(singlePrice * goodsCount);
        $('.price-panel .price').html(singlePrice * goodsCount + 10);
    }
}

function initAddressSel() {
    $('.address-sel li a').click(function() {
        $('.address-sel li a').removeClass('selected');
        $(this).addClass('selected');

        $('input[name=address_id]').val($(this).attr('data-address-id'));

        if ($(this).attr('href') == '#') {
            return false;
        }
    });
}

function initShare() {
    with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~ ( - new Date() / 36e5)];
}

function setHome(obj,vrl) {
        try{
            obj.style.behavior='url(#default#homepage)';obj.setHomePage(vrl);
        }
        catch(e){
            if(window.netscape) {
                try {
                        netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
                }
                catch (e) {
                        alert("此操作被浏览器拒绝！\n请在浏览器地址栏输入“about:config”并回车\n然后将 [signed.applets.codebase_principal_support]的值设置为'true',双击即可。");
                }
                var prefs = Components.classes['@mozilla.org/preferences-service;1'].getService(Components.interfaces.nsIPrefBranch);
                prefs.setCharPref('browser.startup.homepage',vrl);
             }
        }
}

function addFavorite(sURL, sTitle) {
    try {
        window.external.addFavorite(sURL, sTitle);
    } catch (e) {
        try {
            window.sidebar.addPanel(sTitle, sURL, "");
        } catch (e) {
            alert("加入收藏失败，请使用Ctrl+D进行添加");
        }
    }
}

$(document).ready(function() {
    WF.init(globalSetting);
});