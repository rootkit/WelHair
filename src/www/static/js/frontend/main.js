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

                initButtonSet($('.popup-container'));
                $('.price-panel .price').html(parseFloat($('input[name=signle_price]').val()) + 10);
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
                    // if (!(popup.find('input[name=service_id]').val()) > 0 || $.trim(popup.find('input[name=appointment_date]').val()) == '') {
                    //     popup.find('.noti').text('请选择所有信息');
                    //     return;
                    // }

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
                            company_id: companyId
                        },
                        success: function (data) {
                            window.inAjax = 0;

                            if (data.success) {
                                popup.dialog('close');
                                WF.showMessage('success', '信息', '购买商品成功');
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

function initButtonSet(parent) {
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

        $('.msgList').hide();
        $('#' + $(this).attr('rel')).fadeIn();
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
            data: "work_id=" + btn.attr('data-hair-id') + '&' + "is_like=" + (liked ? 0 : 1),
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

function initShare() {
    with(document) 0[(getElementsByTagName('head')[0] || body).appendChild(createElement('script')).src = 'http://bdimg.share.baidu.com/static/api/js/share.js?v=89860593.js?cdnversion=' + ~ ( - new Date() / 36e5)];
}

$(document).ready(function() {
    WF.init(globalSetting);
});