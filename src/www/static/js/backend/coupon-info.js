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
    $('#frm-coupon-info').Validform({
        tiptype: 3
    });
    $('#btnSelectCompany').click(function(){
    	$('#companyList').dialog({"modal": true, "width":800, "height":640}).open();
    });
});