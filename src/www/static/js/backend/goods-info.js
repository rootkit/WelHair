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
     if( $('#goodsmodel').val() != 0)
     {
        url += "&modelid=" + $('#goodsmodel').val();
     }
     $.get( url, function(data) {
        $('#specList').empty();
        $('#specList').html(data);

        $('#specList input[type=radio]').click(function(){
          
          //var first= $('#basicdatatable thead tr th:first');
          //var row = $('<th class="cola">' + $(this).attr('data-name') + '</th>');
          //first.after(row);
          $('#basicdatatable thead tr').empty();


          var headerline = '' +
          '<th class="cola">商品货号</th>' +
          '<th class="cola">'+$(this).attr('data-name') +'</th>' +
          '<th class="cola">库存</th>'+
          '<th class="cola">市场价格</th>'+
          '<th class="cola">销售价格</th>'+
          '<th class="cola">成本价格</th>'+
          '<th class="cola">重量</th>';
          $('#basicdatatable thead tr').append( $(headerline));

          var val = $(this).attr('data-value');
          
          $('#basicdatatable tbody').empty();

          if( val != null && val.replace(/\s+/g, '').length > 0 )
          {

              $('#basicdatatable').addClass('hasspecs');
              $('#basicdatatable').attr('specarray',JSON.stringify({'Name': $(this).attr('data-name'), 'Id': $(this).attr('data-id'), 'Value': val, "Type":"1"}));
              val = JSON.parse(val );
              var i= 0;
              for( var idx in val)
              {
                var spec = {'Name': $(this).attr('data-name'), 'Id': $(this).attr('data-id'), 'Value': val[idx]};
                var addedrow = '<tr spec-id="'+$(this).attr('data-id')+'" spec-value="'+ val[idx]  +'">' +
                '<td><input name="goodsno" type="text" value="' + $('#goodsno').val() + '-' + (++i) + '"  class="u-ipt"/></td>' +
                '<td>' + val[idx] + '<input type=hidden name="spec" value=\'' + JSON.stringify(spec) +'\'></td>' +
                '<td><input name="storenums" type="text" value="100"  class="u-ipt"/></td>' +
                '<td><input name="marketprice" type="text" value="0.00"  class="u-ipt"/></td>' +
                '<td><input name="sellprice" type="text" value="0.00"  class="u-ipt"/></td>' +
                '<td><input name="costprice" type="text" value="0.00"  class="u-ipt"/></td>' +
                '<td><input name="weight" type="text" value="0.00"  class="u-ipt"/></td>' +
                '</tr>';
                $('#basicdatatable tbody').append(addedrow);
                if( i> window.addedspecs )
                {
                    $('.content').height($('.content').height() + 50);
                }
              }
              if( i> window.addedspecs )
              {
                window.addedspecs = 1;
              }
          }

          $('#specList').dialog("close");
        });
     });

  }
};


$(function() {
    window.addedspecs = 0;
    window.addattributes = 0;
    $('#frm-goods-info').Validform({
        tiptype: 3
    });

    $('#btnAddSpec').click(function(){
      $('#specList').dialog({"modal": true, "width":800, "height":640});
      WF.Model.updateSpecList(1);
    });

    $('#goodsmodel').change(function(){

       var modelid= $(this).val();
       $.ajax({
                    type: 'get',
                    dataType: 'json',
                    url:  globalSetting.baseUrl + '/goods/model/listattributes',
                    data: {'modelid':modelid },
                    success: function(data){
                      //console.log( data);
                      $('#attributestable tbody').empty();
                      if( data != null && data.length > 0)
                      {
                        $('#attributepanel').show();
                        $('#attributepanel').addClass('hasattribute');
                         var index ;
                         var i = 0;
                         for(  index in data)
                         {
                            i++;
                            if( i > window.addattributes )
                            {
                                $('.content').height($('.content').height() + 50);
                            }
                            var val = data[index].Value;
                            var valstr='';
                            if( val != null && val.replace(/\s+/g, '').length > 0)
                            {

                                switch( data[index].Type )
                                {
                                  case '1':
                                  {
                                      var va = val.split(',');
                                      var i;
                                      valstr = "<td attr-type='1' attr-id='" + data[index].AttributeId + "'>";
                                      for( i in va )
                                      {
                                          valstr += '<label class="attr"><input class="attribute" type="radio" value="' +va[i] + '">' +va[i] + '</label>';
                                      }
                                      valstr += "</td>";
                                      break;
                                  }
                                  case '2':
                                  {
                                      var va = val.split(',');
                                      var i;
                                      valstr="<td attr-type='2' attr-id='" + data[index].AttributeId + "'>";
                                      for( i in va )
                                      {
                                          valstr += '<label class="attr"><input class="attribute" type="checkbox" value="' +va[i] + '" >' +va[i] + '</label>';
                                      }
                                      valstr +="</td>";
                                      break;
                                  }
                                  case '3':
                                  {
                                      var va = val.split(',');
                                      var i;
                                      valstr="<td attr-type='3' attr-id='" + data[index].AttributeId + "'><select class='attribute'>";
                                      for( i in va )
                                      {
                                         
                                          valstr += '<option value="' +va[i] + '" >' +va[i] + '</option>';
                                      }
                                      valstr +="</select></td>";
                                      break;
                                  }
                                }

                            }

                            var row = "<tr><th>" + data[index].Name +"</th>" + valstr +"</tr>"; 
                            $('#attributestable').append( $(row));
                         }
                      }
                      else
                      {
                        $('#attributepanel').hide();
                      }
                      if( i > window.addattributes)
                      { 
                        window.addattributes = i;
                      }
                        
                    },
                    error:function()
                    {
                        
                    }
        });

    });

    $('#goods-uploader').uploadify({
        fileObjName: 'uploadfile',
        width: 78,
        height: 32,
        multi: false,
        checkExisting: false,
        preventCaching: false,
        fileExt: '*.jpg;*.jpeg;*.png',
        fileDesc: 'Image file (.jpg, .jpeg, .png)',
        buttonText: '选择文件',
        swf: WF.setting.staticAssetBaseUrl + '/swf/uploadify.swf',
        uploader: WF.setting.apiBaseUrl + '/upload/image/original',
        onUploadError: function(file, errorCode, errorMsg, errorString) {
            console.log(errorString);
        },
        onUploadSuccess: function(file, data, response) {
            var result = $.parseJSON(data);
            if (result.success !== false) {
                $('#goods-image').attr('src', result.OriginalUrl);
                $('#goods-url').val(result.OriginalUrl);
            } else {
                WF.showMessage('error', '错误', '上传失败，请重试！');
            }
        }
    });


    $( "#frm-goods-info" ).submit(function( event ) {


          event.preventDefault();
          var form = $( this );

          var name = $('#goodsname').val();


          var goodsdata= { 
                'name': name,
                'goodsno': $('#goodsno').val(),
                'modelid': $('#goodsmodel').val(),
                'brandid': $('#goodsbrand').val(),
                'unit': $('#unit').val(),
                'point': $('#point').val(),
                'experience': $('#experience').val(),
                'sort': $('#sort').val(),
                'keywords': $( '#goodskeywords').val()
               
            };

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

          var companies = $('input[name="company[]"]:checked').map(function(i,n){
            return {'CompanyId':$(n).val()};
          }).get();

          goodsdata['companies'] = companies;

          var categories = $('input[name="category[]"]:checked').map(function(i,n){
            return {'CategoryId':$(n).val()};
          }).get();

          goodsdata['categories'] = categories;

          var isup = $('.u-btn-c3').attr('data-value');
          goodsdata['isup'] = isup;
          var attributes = [];
          if( $('#basicdatatable').hasClass('hasspecs'))
          {
            var products=  $('#basicdatatable tbody tr').map(function(i,n){
                  return {
                    'ProductsNo': $(n).find('input[name="goodsno"]').val(),
                    'SpecArray': $(n).find('input[name="spec"]').val(),
                    'StoreNums': $(n).find('input[name="sellprice"]').val(),
                    'Weight':$(n).find('input[name="weight"]').val(),
                    'MarketPrice': $(n).find('input[name="marketprice"]').val(),
                    'SellPrice':$(n).find('input[name="sellprice"]').val(),
                    'CostPrice':$(n).find('input[name="costprice"]').val()
                  };
              }).get();
            var specarray = $('#basicdatatable').attr('specarray');

             goodsdata['weight']= $('input[name="weight"]:first').val();
             goodsdata['storenums']= $('input[name="sellprice"]:first').val();
             goodsdata['marketprice']= $('input[name="marketprice"]:first').val();
             goodsdata['costprice']= $('input[name="costprice"]:first').val();
             goodsdata['sellprice']= $('input[name="sellprice"]:first').val();
             goodsdata['specarray'] = specarray;
             goodsdata['products'] = products;
             attributes =  $('#basicdatatable tbody tr').map(function(i,n){
                  return {
                    'SpecId': $(n).attr('spec-id'),
                    'SpecValue': $(n).attr('spec-value'),
                    'AttributeId':null,
                    'AttributeValue': null
                  };
              }).get();

          }
          else
          {
               goodsdata['weight']= $('input[name="weight"]:first').val();
               goodsdata['storenums']= $('input[name="sellprice"]:first').val();
               goodsdata['marketprice']= $('input[name="marketprice"]:first').val();
               goodsdata['costprice']= $('input[name="costprice"]:first').val();
               goodsdata['sellprice']= $('input[name="sellprice"]:first').val();
          }

          var recommendgoods = $('input[name="goods_commend[]"]:checked').map(function(i,n){
            return {"RecommendId":$(n).val()};
          }).get();

         goodsdata['recommendgoods'] = recommendgoods;

        if( $('#attributepanel').hasClass('hasattribute'))
        {
            var extAttributes = $('#attributestable tbody tr').map(function(i,n){

              var attrtype=$(n).find('td:first').attr('attr-type');
              var attrid= $(n).find('td:first').attr('attr-id');
              var attrvalue='';

              switch( attrtype)
              {
                  case "1":
                  {
                    attrvalue = $(n).find( '.attribute:checked').val();
                    break;
                  }
                  case "2":
                  {
                    attrvalue = $(n).find( '.attribute:checked').map(function(idx,node){
                      return $(node).val();
                    }).get().join(',');
                    break;
                  }
                  case "3":
                  {
                    attrvalue = $(n).find( '.attribute').val();
                    break;
                  }
              }

              return {
                    'SpecId': null,
                    'SpecValue': null,
                    'AttributeId':( attrid == undefined ? null: attrid),
                    'AttributeValue': (attrvalue == undefined? null: attrvalue)
                  };

            }).get();
        }

         goodsdata['attributes'] = attributes.concat(extAttributes);

         goodsdata['img'] =$('#goods-url').val();
      
         //console.log(goodsdata);
         

          url = form.attr( "action" );
          var posting = $.post( url, goodsdata );


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