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