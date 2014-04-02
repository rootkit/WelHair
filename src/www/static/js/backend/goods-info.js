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
    $('#frm-goods-info').Validform({
        tiptype: 3
    });


    $( "#frm-goods-info" ).submit(function( event ) {


          event.preventDefault();
          var form = $( this );

          var name = $('#goodsname').val();

          //var specids  = $('tr.specid').map(function(i,n) {
          //      return $(n).attr('data-id');
          //}).get().join(",");

          /*var attributes =  $('tr.attributerow').map(function(i,n) {
                return { 
                    'name':$(n).find('input[name="attributename"]').val(),
                    'type':$(n).find('select[name="attributetype"]').val(),
                    'value':$(n).find('input[name="attributevalue"]').val(),
                    'search' : $(n).find('input[name="attributesearch"]:checked').length
                 };
          }).get();
          */
         
         
          

          url = form.attr( "action" );

          var posting = $.post( url, { 
                'name': name
            } );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/goods/index/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/index/search';
        return;
    });
});