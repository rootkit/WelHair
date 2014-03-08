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
        function changeSizebarHeight() {
            var screenHeight = $(window).height();

            $('.content').css('height', 'auto');
            var documentHeight = $(document).height();

            var contentHeight = (documentHeight > screenHeight ? documentHeight : screenHeight) - 122;
            $('.content').css('height', contentHeight);
        }

        $(window).resize(function() {
            changeSizebarHeight();
        });

        changeSizebarHeight();

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

        $('.u-btns').find('span').click(function() {
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
                url: WF.setting.baseUrl + '/ajax/area/list',
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