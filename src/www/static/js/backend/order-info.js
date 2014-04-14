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
                    '               <td><input type="text" name="goodscount" value="1"/>' + 
                    '       <input type="hidden" name="goodsid" value="' + $(this).attr('data-goodsid')  + '"/>' +
                    '       <input type="hidden" name="productsid" value="' + $(this).attr('data-productsid')  + '"/>' +
                    '       <input type="hidden" name="goodsname" value="' + $(this).attr('data-name')  + '"/>' +
                    '       <input type="hidden" name="goodsspec" value="' + $(this).attr('data-spec')  + '"/>' +
                    '       <input type="hidden" name="weight" value="' + $(this).attr('data-weight')  + '"/>' +
                    '       <input type="hidden" name="sellprice" value="' + $(this).attr('data-sellprice')  + '"/>' +
                    '       <input type="hidden" name="goodsimg" value="' + $(this).attr('data-img')  + '"/>' +
                    '               </td> ' +
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

    $('#goodstable').find('.btnDelete').click(function(){$(this).parents('tr:first').remove();});

    $( "#frm-order-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var orderno = $('#orderno').val();

         
          

          url = form.attr( "action" );

          var orderdata = { 
                'orderno': orderno,
                'distribution' : $('#distribution').val(),
                'paytype':$('#paytype').val(),
                'acceptname':$('#acceptname').val()
            };

          var goods = $('tr.goodsid').map(function(i,n){

              var  goodsArray = {
                          'Name':$(n).find('input[name="goodsname"]:first').val(), 
                          'Value':$(n).find('input[name="goodsspec"]:first').val()
              };
              return {
                  'GoodsId'   :$(n).find('input[name="goodsid"]:first').val(),
                  'ProductsId':$(n).find('input[name="productsid"]:first').val(),
                  'Img':$(n).find('input[name="goodsimg"]:first').val(),
                  'GoodsPrice':$(n).find('input[name="sellprice"]:first').val(),
                  'RealPrice':$(n).find('input[name="sellprice"]:first').val(),
                  'GoodsNums':$(n).find('input[name="goodscount"]:first').val(),
                  'GoodsWeight':$(n).find('input[name="weight"]:first').val(),
                  'GoodsArray': JSON.stringify( goodsArray)
              };
          }).get();

          orderdata['goods'] = goods;

          if( $('#sel-province').val() != '')
          {
            orderdata['province'] = $('#sel-province').val();
          }

          if( $('#sel-city').val() != '')
          {
            orderdata['city'] = $('#sel-city').val();
          }

          if( $('#sel-district').val() != '')
          {
            orderdata['area'] = $('#sel-district').val();
          }


          var posting = $.post( url, orderdata );


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

    WF.initAreaSelector();
});