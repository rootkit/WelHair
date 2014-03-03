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

        if ($('#errorMessage').text() != '') {
            this.showMessage('error', '警告', $('#errorMessage').html());
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