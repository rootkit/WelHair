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

        $('.u-btns.enable').find('span').click(function() {
            var cur = $(this);
            var group = cur.parent();

            if (group.attr('data-type') == 'radio') {
                group.find('span').each(function() {
                    var el = $(this);
                    if (el.get(0) == cur.get(0)) {
                        el.removeClass('u-btn-c4').addClass('u-btn-c3');
                    } else {
                        el.removeClass('u-btn-c3').addClass('u-btn-c4');
                    }
                });

                group.find('input[type=hidden]').val(cur.attr('data-value'));
            }

            if (group.attr('data-type') == 'checkbox') {
                if (cur.hasClass('u-btn-c3')) {
                    cur.removeClass('u-btn-c3').addClass('u-btn-c4');
                } else {
                    cur.removeClass('u-btn-c4').addClass('u-btn-c3');
                }

                var values = [];
                group.find('span.u-btn-c3').each(function() {
                    var el = $(this);
                    values.push(el.attr('data-value'));
                });

                group.find('input[type=hidden]').val(values.join(','));
            }
        });

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

$(document).ready(function() {
    WF.init(globalSetting);
});