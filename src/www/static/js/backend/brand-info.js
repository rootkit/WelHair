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
    $('#frm-brand-info').Validform({
        tiptype: 3
    });   

    $('#avatar-uploader').uploadify({
        fileObjName: 'uploadfile',
        width: 78,
        height: 32,
        multi: false,
        checkExisting: false,
        preventCaching: false,
        fileExt: '*.jpg;*.jpeg;*.png',
        fileDesc: 'Image file (.jpg, .jpeg, .png)',
        buttonText: '选择文件',
        swf: WF.setting.staticAssetBaseUrl + '/swf/uploadify.swf',
        uploader: WF.setting.apiBaseUrl + '/upload/image/original',
        onUploadError: function(file, errorCode, errorMsg, errorString) {
            console.log(errorString);
        },
        onUploadSuccess: function(file, data, response) {
            var result = $.parseJSON(data);
            if (result.success !== false) {
                $('#avatar-image').attr('src', result.OriginalUrl);
                $('#avatar-url').val(result.Thumb480Url);
            } else {
                WF.showMessage('error', '错误', '上传失败，请重试！');
            }
        }
    });
});