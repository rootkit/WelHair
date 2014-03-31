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

WF.Model = {
  updateSpecList :function(page)
  {
     var url =globalSetting.baseUrl + '/goods/spec/select?page=' + page + '&func= WF.Model.updateSpecList';
     $.get( url, function(data) {
        $('#specList').empty();
        $('#specList').html(data);

        $('#specList input[type=radio]').click(function(){

          if( $('#spectable tbody').find( 'tr[data-id="' + $(this).attr('data-id') + '"]').get(0) == null )
          {
          
             var row = '   <tr class="specid" data-id="' +  $(this).attr('data-id')  + '"> ' +
                    '               <td>' + $(this).attr('data-name') +'</td> ' +

                    '                <td><a href="#" class="btnUp"><i class="iconfont">&#xf0113;</i></a>&nbsp;&nbsp;<a href="#" class="btnDown"><i class="iconfont">&#xf0111;</i></a>&nbsp;&nbsp;<a href="#" class="btnDelete"><i class="iconfont">&#xf013f;</i></a></td>' +
                    '            </tr>';

            $('#spectable tbody').append( $(row));
            $('.content').height($('.content').height() + 50);
            $('#spectable').find('.btnDelete').click(function(){$(this).parents('tr:first').remove();});
            $('#spectable').find('.btnUp').click(function(){
              var row = $(this).parents('tr:first');
              row.insertBefore(row.prev());

            });
            $('#spectable').find('.btnDown').click(function(){
              var row = $(this).parents('tr:first');
              row.insertAfter(row.next());

            });

          }
          $('#specList').dialog("close");
        });
     });

  }
};

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
                '                <td><a href="#" class="btnDelete"><i class="iconfont">&#xf013f;</i></a></td>' +
                '            </tr>';

        $('#attributetable tbody').append( $(row));
        $('.content').height($('.content').height() + 50);
        $('#attributetable').find('.btnDelete').click(function(){$(this).parents('tr:first').remove();});

    });

    

    $('#btnAddSpec').click(function(){
      $('#specList').dialog({"modal": true, "width":800, "height":640});
      WF.Model.updateSpecList(1);
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

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/goods/model/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/model/search';
        return;
    });
});