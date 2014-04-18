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
    var validator = $('#frm-brand-info').Validform({
        tiptype: 3
    });

    $('#brand-uploader').uploadify({
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
                $('#brand-image').attr('src', result.OriginalUrl);
                $('#brand-url').val(result.OriginalUrl);
            } else {
                WF.showMessage('error', '错误', '上传失败，请重试！');
            }
        }
    });

    $( "#frm-brand-info" ).submit(function( event ) {
        if (!validator.check()) {
          return false;
        }

          var form = $( this );

          var name = $('input[name=brandname]').val();
          var sort = $('input[name=sort]').val();
          var brandurl = $('#url').val();
          var logo = $('#brand-image').attr('src');
          var brandcategories  = $('input[name="category[]"]:checked').map(function(i,n) {
                return $(n).val();
            }).get();

          var description = $('textarea#description').val();


          url = form.attr( "action" );

          var posting = $.post( url, {
                'brand_id': $('#brandid').val(),
                'name': name,
                'sort': sort,
                'brandurl' : brandurl,
                'logo' : logo,
                'category' : brandcategories,
                'description' :description
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/goods/brand/search';
              return false;

          });

          return false;

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/brand/search';
        return false;
    });
});