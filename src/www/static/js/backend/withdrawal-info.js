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

    $('.u-btn').click(function(){
       
        var status = $(this).parents('span:first').find('.u-btn-c3').attr('data-value');
        switch( status)
        {
            case '0':
            {
                break;
            }
            case '1':
            {
                $('#approvepopin').dialog(
                        {"modal": true,
                         "width":500,
                         "height":240,
                         "title":"批准",
                          buttons:
                                [
                                    {
                                        text: "批准",
                                        class:"u-btn",
                                        click: function()
                                        {
                                            var popin = $(this);
                                            $.ajax({
                                                        type: 'post',
                                                        dataType: 'json',
                                                        url:  globalSetting.baseUrl + '/user/index/withdrawalapprove',
                                                        data: {
                                                            'withdrawal_id':$('#withdrawal_id').val()
                                                         },
                                                        success: function(data){
                                                            if( data.success)
                                                            {
                                                                popin.dialog('close');
                                                                window.location.reload();
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
                                        }
                                     },
                                     {
                                            text : "取消",
                                            class: "u-btn",
                                            click: function() {
                                                $(this).dialog('close');
                                                $('.u-btn:first').click();
                                            }
                                     }
                                ]

                    });
                break;
            }
            case '2':
            {
                $('#rejectpopin').dialog(
                        {"modal": true,
                         "width":500,
                         "height":240,
                         "title":"拒绝",
                          buttons:
                                [
                                    {
                                        text: "拒绝",
                                        class:"u-btn",
                                        click: function()
                                        {
                                            var popin = $(this);
                                            $.ajax({
                                                        type: 'post',
                                                        dataType: 'json',
                                                        url:  globalSetting.baseUrl + '/user/index/withdrawalreject',
                                                        data: {
                                                            'withdrawal_id':$('#withdrawal_id').val(),
                                                            'reason': $('#txtrejectreason').val()
                                                         },
                                                        success: function(data){
                                                            if( data.success)
                                                            {
                                                                popin.dialog('close');
                                                                window.location.reload();
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
                                        }
                                     },
                                     {
                                            text : "取消",
                                            class: "u-btn",
                                            click: function() {
                                                $(this).dialog('close');
                                                $('.u-btn:first').click();
                                            }
                                     }
                                ]

                    });
                break;
            }
        }
    });
    


});