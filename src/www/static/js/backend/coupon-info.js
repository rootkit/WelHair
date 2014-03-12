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

WF.Coupon = {
	updateCompanyList :function(page)
	{
		 var url =globalSetting.baseUrl + '/company/index/select?page=' + page + '&func= WF.Coupon.updateCompanyList';
		 $.get( url, function(data) {
			$('#companyList').empty();
			$('#companyList').html(data);

			$('#companyList input[type=radio]').click(function(){
				$('#companyname').val($(this).attr('data-name'));
				$('#companyid').val($(this).attr('data-id'));
				$('#companyList').dialog("close");
			});
		 });

	}
};
$(function() {
    $('#frm-coupon-info').Validform({
        tiptype: 3
    });


    $('#coupon-uploader').uploadify({
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
                $('#coupon-image').attr('src', result.OriginalUrl);
                $('#brand-image-url').val(result.OriginalUrl);
            } else {
                WF.showMessage('error', '错误', '上传失败，请重试！');
            }
        }
    });

    $('#btnSelectCompany').click(function(){
    	$('#companyList').dialog({"modal": true, "width":800, "height":640});
    	WF.Coupon.updateCompanyList(1);
    });
});