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
     var validator = $('#frmBrandCategoryInfo').Validform({
        tiptype: 3
     });

    $( "#frmBrandCategoryInfo" ).submit(function( event ) {
        if (!validator.check()) {
          return false;
        }

        var form = $( this );
        var name = $('#brandcategoryname').val();
        var id = $('#brandcategoryid').val();
        url = form.attr( "action" );

        var posting = $.post( url, { 'name': name, 'bc_id': id} );

        posting.done(function( data ) {

            window.location = globalSetting.baseUrl + '/goods/brand/categorysearch';
            return false;
        });

        return false;

    });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/brand/categorysearch';
        return false;
    });

});