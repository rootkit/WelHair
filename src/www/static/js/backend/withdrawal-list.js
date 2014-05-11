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
    
      $( ".btnApprove" ).click(function( event ) {
           event.preventDefault();
           var id = $(this).attr('data-id');
           var btn =$(this);
           $.ajax({
                    type: 'post',
                    dataType: 'json',
                    url:  globalSetting.baseUrl + '/user/index/withdrawalapprove',
                    data: {
                        'withdrawal_id':id
                     },
                    success: function(data){
                        if( data.success)
                        {
                             btn.parents('tr:first').find('td.statusrow').html('已批准');
                             btn.parents('tr:first').find('td.actionrow').html('');
                        }
                        else
                        {
                            WF.showMessage('error', '错误', data.message);
                        }
                    },
                    error:function()
                    {
                         WF.showMessage('error', '错误', '请求错误！');
                    }
        });
    });

    $( ".btnReject" ).click(function( event ) {
           event.preventDefault();
           var id = $(this).attr('data-id');
           var btn =$(this);
           $.ajax({
                    type: 'post',
                    dataType: 'json',
                    url:  globalSetting.baseUrl + '/user/index/withdrawalreject',
                    data: {
                        'withdrawal_id':id
                     },
                    success: function(data){
                        if( data.success)
                        {
                             btn.parents('tr:first').find('td.statusrow').html('已拒绝');
                             btn.parents('tr:first').find('td.actionrow').html('');
                        
                        }
                        else
                        {
                            WF.showMessage('error', '错误', data.message);
                        }
                    },
                    error:function()
                    {
                        WF.showMessage('error', '错误', '请求错误！');
                    }
        });
    });
});