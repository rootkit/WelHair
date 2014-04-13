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

WF.Goods = {
  updateGoodsList :function(page)
  {
     var url =globalSetting.baseUrl + '/goods/index/select?page=' + page + '&func= WF.Goods.updateGoodsList';
     $.get( url, function(data) {
        $('#goodsList').empty();
        $('#goodsList').html(data);

        $('#goodsList input[type=radio]').click(function(){

          if( $('#goodstable tbody').find( 'tr[data-id="' + $(this).attr('data-id') + '"]').get(0) == null )
          {

             var row = '   <tr class="goodsid" data-id="' +  $(this).attr('data-id')  + '"> ' +
                    '               <td>' + $(this).attr('data-name') + ' ' + $(this).attr('data-spec') +'</td> ' +
                    '               <td>' + $(this).attr('data-sellprice') + '</td> ' +
                    '               <td><input type="text" name="goodscount"/></td> ' +
                    '               <td><a href="#" class="btnDelete"><i class="iconfont">&#xf013f;</i></a></td>' +
                    '     </tr>';

            $('#goodstable tbody').append( $(row));
            $('.content').height($('.content').height() + 50);
            $('#goodstable').find('.btnDelete').click(function(){$(this).parents('tr:first').remove();});
          }
          $('#goodsList').dialog("close");
        });
     });

  }
};


$(function() {
    $('#frm-order-info').Validform({
        tiptype: 3
    });
    $( "#tabs" ).tabs();


    $('#btnAddGoods').click(function(){
      $('#goodsList').dialog({"modal": true, "width":800, "height":640});
      WF.Goods.updateGoodsList(1);
    });



    $( "#frm-order-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var orderno = $('#orderno').val();

         
          

          url = form.attr( "action" );

          var posting = $.post( url, { 
                'orderno': orderno
            } );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/order/index/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/order/index/search';
        return;
    });
});