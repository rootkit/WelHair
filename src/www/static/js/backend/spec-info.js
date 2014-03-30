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

    $('#btnAddSpec').click(function(){

      var row = '   <tr> ' +
                '     <td><input name="specval" type="text" value="" datatype="s" class="u-ipt"/></td> ' +
                '     <td><a href="#" class="btnUp"><i class="iconfont">&#xf0113;</i></a>&nbsp;&nbsp;<a href="#" class="btnDown"><i class="iconfont">&#xf0111;</i></a>&nbsp;&nbsp;<a href="#" class="btnDelete"><i class="iconfont">&#xf013f;</i></a></td>' +
                '   </tr>';

        $('#spectable tbody').append( $(row));
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