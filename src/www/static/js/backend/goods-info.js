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

              console.log( val);
              val = JSON.parse(val );
              var i= 0;
              for( var idx in val)
              {

                var addedrow = '<tr>' +
                '<td><input name="goodsno" type="text" value="' + $('#goodsno').val() + '-' + (++i) + '"  class="u-ipt"/></td>' +
                '<td>' + val[idx] + '</td>' +
                '<td><input name="storenums" type="text" value="100"  class="u-ipt"/></td>' +
                '<td><input name="marketprice" type="text" value=""  class="u-ipt"/></td>' +
                '<td><input name="sellprice" type="text" value=""  class="u-ipt"/></td>' +
                '<td><input name="costprice" type="text" value=""  class="u-ipt"/></td>' +
                '<td><input name="weight" type="text" value=""  class="u-ipt"/></td>' +
                '</tr>';
                $('#basicdatatable tbody').append(addedrow);
              }
          }

          $('#specList').dialog("close");
        });
     });

  }
};


$(function() {
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
                      $('#attributestable').empty();
                      if( data != null && data.length > 0)
                      {
                        $('#attributepanel').show();
                        var index ;
                         for(  index in data)
                         {
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
                                      for( i in va )
                                      {
                                          valstr += '<label class="attr"><input type="radio" value="' +va[i] + '" name="attr_id_"' + data[index].AttributeId + '>' +va[i] + '</label>';
                                      }
                                      break;
                                  }
                                  case '2':
                                  {
                                      var va = val.split(',');
                                      var i;
                                      for( i in va )
                                      {
                                          valstr += '<label class="attr"><input type="checkbox" value="' +va[i] + '" name="attr_id_"' + data[index].AttributeId + '>' +va[i] + '</label>';
                                      }
                                      break;
                                  }
                                  case '3':
                                  {
                                      var va = val.split(',');
                                      var i;
                                      valstr="<select>";
                                      for( i in va )
                                      {
                                         
                                          valstr += '<option value="' +va[i] + '" name="attr_id_"' + data[index].AttributeId + '>' +va[i] + '</option>';
                                      }
                                      valstr +="</select>";
                                      break;
                                  }
                                }

                            }

                            var row = "<tr><th>" + data[index].Name +"</th><td>" + valstr +"</td></tr>"; 
                            $('#attributestable').append( $(row));
                         }
                      }
                      else
                      {
                        $('#attributepanel').hide();
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
                'name': name,
                'goodsno': $('#goodsno').val(),
                'modelid': $('#goodsmodel').val(),
                'brandid': $('#goodsbrand').val(),
                'storenums': $('#storenums').val(),
                'unit': $('#unit').val(),
                'point': $('#point').val(),
                'exprience': $('#exprience').val(),
                'sort': $('#sort').val(),
                'weight': $('#weight').val(),
                'storenums': $('#sellprice').val(),
                'marketprice': $('#marketprice').val(),
                'costprice': $('#costprice').val()
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