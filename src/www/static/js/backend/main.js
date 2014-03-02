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