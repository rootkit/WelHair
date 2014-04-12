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

    window.addedHeight = 0;
    $('#frm-delivery-info').Validform({
        tiptype: 3
    });

    $('#freighttype').change(function(){

      $('#freightname').val($(this).find('option:selected').text());
    });

    $('.btnDelete').bind('click', function(){
        $(this).parent().remove();
    });

    $('.btnAddProvince').bind('click', function(){
       var province = $(this).parent().find('select[name="province"]');
       if( $(this).parent().find('input[name="areagroupid[]"]').val().replace(/\s+/g, '').length > 0)
       {  
          var selectedArray = $(this).parent().find('input[name="areagroupid[]"]').val();
          var areaArray = selectedArray.split(',');
          if( $.inArray( province.val(), areaArray) != -1)
          {
             $('<div><p>已经存在！</p></div>').dialog({'title':'提示','modal':true});
          }
          else
          {
            $(this).parent().find('input[name="areagroupid[]"]').val(selectedArray + ',' + province.val() );
            $(this).parent().find('input[name="areaName"]').val($(this).parent().find('input[name="areaName"]').val() +','+ province.find('option:selected').text());
          }
       }
       else
       {
          $(this).parent().find('input[name="areagroupid[]"]').val(province.val());
          $(this).parent().find('input[name="areaName"]').val(province.find('option:selected').text());
       }
    });

    $('#btnAddArea').click(function(){
       var area =  $('#area_template').clone();
       area.removeAttr('id');
       area.show();
       $('#areaList').append(area);
       $('.content').height($('.content').height() + 50);

       $('.btnDelete').bind('click', function(){
          $(this).parent().remove();
       });

       $('.btnAddProvince').bind('click', function(){
           var province = $(this).parent().find('select[name="province"]');
           if( $(this).parent().find('input[name="areagroupid[]"]').val().replace(/\s+/g, '').length > 0)
           {  
              var selectedArray = $(this).parent().find('input[name="areagroupid[]"]').val();
              var areaArray = selectedArray.split(',');
              if( $.inArray( province.val(), areaArray) != -1)
              {
                 $('<div><p>已经存在！</p></div>').dialog({'title':'提示','modal':true});
              }
              else
              {
                $(this).parent().find('input[name="areagroupid[]"]').val(selectedArray + ',' + province.val() );
                $(this).parent().find('input[name="areaName"]').val($(this).parent().find('input[name="areaName"]').val() +','+ province.find('option:selected').text());
              }
           }
           else
           {
              $(this).parent().find('input[name="areagroupid[]"]').val(province.val());
              $(this).parent().find('input[name="areaName"]').val(province.find('option:selected').text());
           }
       });

    });

    $('input[name="price_type"]').click(function(){
        if($(this).val() == '0')
        {
          $('#areaBox').hide();
        }
        else
        {
          if( window.addedHeight ==0)
          {
            $('.content').height($('.content').height() + 170);
            window.addedHeight = 1;
          }
          
          $('#areaBox').show();
        }
    });

    $( "#frm-delivery-info" ).submit(function( event ) {


          event.preventDefault();

          var form = $( this );

          var name = $('#deliveryname').val();

        
          var firstprice = $('#first_price').val().replace(/\s+/g, '').length > 0 ? $('#first_price').val().replace(/\s+/g, ''): 0;
          var secondprice = $('#second_price').val().replace(/\s+/g, '').length > 0 ? $('#second_price').val().replace(/\s+/g, ''): 0;
          var isSavePrice =  $('#is_save_price').is(':checked') ? 1: 0;
          var saveRate = 0;
          var lowPrice = 0;
          if( isSavePrice > 0 )
          {
             saveRate = $('#save_rate').val();
             lowPrice = $('#low_price').val();
          }

          var areagroupid=null;
          var areafirstprice=null;
          var areasecondprice=null;

          var areagroupids=  $('#areaList').find('input[name="areagroupid[]"]').map(function(i,n){
                  return $(n).val()? $(n).val(): '';
              }).get();
          areagroupid = JSON.stringify(areagroupids);

          var areafirstprices=  $('#areaList').find('input[name="areafirstprice[]"]').map(function(i,n){
                  return $(n).val()? $(n).val(): '';
              }).get();
          areafirstprice = JSON.stringify(areafirstprices);

          var areasecondprices=  $('#areaList').find('input[name="areasecondprice[]"]').map(function(i,n){
                  return $(n).val()? $(n).val(): '';
              }).get();
          areasecondprice = JSON.stringify(areasecondprices);

          url = form.attr( "action" );

          var posting = $.post( url, {
                'name': name,
                'freightid':$('#freight').val(),
                'type': $('input[name="deliverytype"]:checked:first').val(),
                'firstweight': $('#first_weight').val(),
                'secondweight': $('#second_weight').val(),
                'firstprice':firstprice,
                'secondprice':secondprice,
                'issaveprice':isSavePrice,
                'saverate':saveRate,
                'lowprice':lowPrice,
                'description': $('#description').val(),
                'areagroupid':areagroupid,
                'areafirstprice':areafirstprice,
                'areasecondprice':areasecondprice,
                'status': $('input[name="status"]:checked:first').val(),
                'pricetype': $('input[name="price_type"]:checked:first').val(),
                'sort': $('#sort').val()
            } );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/system/delivery/search';
                return;
              }

          });

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/system/delivery/search';
        return;
    });
});