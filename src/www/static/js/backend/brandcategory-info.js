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
    $('.u-btn-submit').click( function(){

        if($('#brandcategoryname').val() == '')
        {
            WF.showMessage('error', 'required', '请输入分类名称');
            return;
        }
    });
   
});