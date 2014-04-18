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
    var validator = $('#frm-category-info').Validform({
        tiptype: 3
    });

    $( "#frm-category-info" ).submit(function( event ) {
        if (!validator.check()) {
          return false;
        }

        var form = $( this );
        var url = form.attr( "action" );

        var posting = $.post( url, {
          'name' : $('#categoryname').val(),
          'sort' : $('#categorysort').val(),
          'parentid': $('#categoryparent').val(),
          'visibility':$('.u-btn-c3').attr('data-value'),
           'modelid':$('#categorymodel').val()
         } );


        posting.done(function( data ) {
            window.location = globalSetting.baseUrl + '/goods/category/search';
            return false;
        });

        return false;
    });
});