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
    $('#frm-model-info').Validform({
        tiptype: 3
    });

    $('#btnAddAttribute').click(function(){

      var row = '   <tr> ' +
                '               <td><input name="couponcode" type="text" value="" datatype="s" class="u-ipt"/></td> ' +
                '               <td>'+
                '                     <select id="coupon-type"  class="u-sel" > '+
                '                        <option value="" >单选框</option> ' +
                '                        <option value="" >复选框</option> ' +
                '                       <option value="" >下拉框</option>  ' +                        
                '                     </select> '+
                '                </td> '+
                '                <td><input name="passcode" type="text" value=""  class="u-ipt"/></td>'+
                                '                <td> <input type="checkbox"/></td> ' +
                '                <td></td>' +
                '            </tr>';

        $('#attributetable tbody').append( $(row));
        $('.content').height($('.content').height() + 50);

    });


    $( "#frm-model-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('#modelname').val();

          //var brandcategories  = $('input[name="category[]"]:checked').map(function(i,n) {
          //      return $(n).val();
          //}).get();
         
          

          url = form.attr( "action" );

          var posting = $.post( url, { 
                'name': name
            } );


          posting.done(function( data ) {

              window.location = globalSetting.baseUrl + '/goods/model/search';
              return;

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/model/search';
        return;
    });
});