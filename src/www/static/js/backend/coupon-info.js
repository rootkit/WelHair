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
    $('#btnSelectCompany').click(function(){
    	$('#companyList').dialog({"modal": true, "width":800, "height":640});
    	WF.Coupon.updateCompanyList(1);
    });
});