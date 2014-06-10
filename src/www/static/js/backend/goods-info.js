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
     if ($('#goodsmodel').val() != 0) {
        url += "&modelid=" + $('#goodsmodel').val();
     }

    function descartes(list,specData)
    {
      //parent上一级索引;count指针计数
      var point  = {};

      var result = [];
      var pIndex = null;
      var tempCount = 0;
      var temp   = [];

      //根据参数列生成指针对象
      for(var index in list)
      {
        if(typeof list[index] == 'object')
        {
          point[index] = {'parent':pIndex,'count':0}
          pIndex = index;
        }
      }

      //单维度数据结构直接返回
      if(pIndex == null)
      {
        return list;
      }

      //动态生成笛卡尔积
      while(true)
      {
        for(var index in list)
        {
          tempCount = point[index]['count'];
          temp.push({"Id":specData[index].Id,"Type":specData[index].Type,"Name":specData[index].Name,"Value":list[index][tempCount]});
        }

        //压入结果数组
        result.push(temp);
        temp = [];

        //检查指针最大值问题
        while(true)
        {
          if(point[index]['count']+1 >= list[index].length)
          {
            point[index]['count'] = 0;
            pIndex = point[index]['parent'];
            if(pIndex == null)
            {
              return result;
            }

            //赋值parent进行再次检查
            index = pIndex;
          }
          else
          {
            point[index]['count']++;
            break;
          }
        }
      }
    }

     $.get(url, function(data) {
        $('#specList').empty();
        $('#specList').html(data);

        $('#specList input[type=radio]').click(function() {
          var val = $(this).attr('data-value');
          if (val != null && val.replace(/\s+/g, '').length > 0) {
            $('#basicdatatable tbody').empty();

            var hasSpecs = $('#basicdatatable').hasClass('hasspecs');
            if (!hasSpecs) {
              $('#basicdatatable').addClass('hasspecs');
            }

            var specArrayVal = $('#basicdatatable').attr('specarray');
            if (specArrayVal !== undefined && specArrayVal !== false) {
              specArrayVal = JSON.parse(specArrayVal);
            } else {
              specArrayVal = [];
            }

            var added = false;
            for (var i = 0; i < specArrayVal.length; i++) {
                if (specArrayVal[i]['Id'] == $(this).attr('data-id')) {
                  added = true;
                }
            }

            if(!added) {
                specArrayVal.push({'Name': $(this).attr('data-name'), 'Id': $(this).attr('data-id'), 'Value': JSON.parse(val), "Type":"1"});
            }

            $('#basicdatatable').attr('specarray', JSON.stringify(specArrayVal));


            var specValueData = {};
            var specData = {};
            $.each(specArrayVal, function() {
              var sc = this;
              if (!specValueData[sc.Id]) {
                specData[sc.Id] = {'Id':sc.Id,'Name':sc.Name,'Type':sc.Type};
                specValueData[sc.Id] = [];
              }
              $.each (sc.Value, function() {
                specValueData[sc.Id].push(this);
              });
            });

            var specMaxData = descartes(specValueData,specData);

            var headerline = '<th class="cola">商品货号</th>';
            for (var j = 0; j < specArrayVal.length; j++) {
              headerline += ('<th class="cola">' + specArrayVal[j].Name +'</th>');
            }
            headerline +=
            '<th class="cola">库存</th>'+
            '<th class="cola">市场价格</th>'+
            '<th class="cola">销售价格</th>'+
            '<th class="cola">成本价格</th>'+
            '<th class="cola">重量</th>';
            $('#basicdatatable thead tr').empty().append($(headerline));

            var matrix = specMaxData.length;

            for (var l = 0; l < matrix; l++) {
              var addedrow = '<tr>' +
                '<td><input name="goodsno" type="text" value="' + $('#goodsno').val() + '-' + (l + 1) + '"  class="u-ipt"/><input type=hidden name="spec" value=\'' + JSON.stringify(specMaxData[l]) +'\'></td>';

              var specH = specArrayVal;
              for (var m = 0; m < specH.length; m++) {
                addedrow += '<td>' + specMaxData[l][m].Value + '</td>';
              }

              addedrow += '<td><input name="storenums" type="text" value="100"  class="u-ipt"/></td>' +
              '<td><input name="marketprice" type="text" value="0.00"  class="u-ipt"/></td>' +
              '<td><input name="sellprice" type="text" value="0.00"  class="u-ipt"/></td>' +
              '<td><input name="costprice" type="text" value="0.00"  class="u-ipt"/></td>' +
              '<td><input name="weight" type="text" value="0.00"  class="u-ipt"/></td>' +
              '</tr>';

              $('#basicdatatable tbody').append(addedrow);
            }
          }

          $(window).resize();
          $('#specList').dialog("close");
        });
     });

  }
};


$(function() {
    window.addedspecs = 0;
    window.addattributes = 0;

    var serverPath = WF.setting.staticAssetBaseUrl;
    var editor = UM.getEditor('goods-editor', {
        imageUrl: WF.setting.apiBaseUrl + '/upload/image/original',
        imagePath: '',
        imageFieldName: 'uploadfile',
        lang: /^zh/.test(navigator.language || navigator.browserLanguage || navigator.userLanguage) ? 'zh-cn' : 'en',
        langPath: WF.setting.staticAssetBaseUrl + "/lang/",
        focus: true
    });
    editor.ready(function(editor) {
        $(window).resize();
    });

    var validator = $('#frm-goods-info').Validform({
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
                                          valstr += '<label class="attr"><input class="attribute" type="radio" value="' +va[i] + '">' +va[i] + '</label>&nbsp;&nbsp;';
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
                                          valstr += '<label class="attr"><input class="attribute" type="checkbox" value="' +va[i] + '" >' +va[i] + '</label>&nbsp;&nbsp;';
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


    /*
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
*/


    $( "#frm-goods-info" ).submit(function( event ) {
        if (!validator.check()) {
          return false;
        }
          var form = $( this );

          var name = $('#goodsname').val();


          var goodsdata= {
                'name': name,
                'goodsno': $('#goodsno').val(),
                'modelid': $('#goodsmodel').val(),
                'brandid': $('#goodsbrand').val(),
                'unit': $('#unit').val(),
                'point': $('#point').val(),
                'content': editor.getContent(),
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

          var imgs = $('input[name="goods_picture_url[]"]').map(function(i,n){
            return $(n).val();
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
            var specArrJson = $.parseJSON(specarray);

            goodsdata['weight']= $('input[name="weight"]:first').val();
            goodsdata['storenums']= $('input[name="sellprice"]:first').val();
            goodsdata['marketprice']= $('input[name="marketprice"]:first').val();
            goodsdata['costprice']= $('input[name="costprice"]:first').val();
            goodsdata['sellprice']= $('input[name="sellprice"]:first').val();
            goodsdata['specarray'] = specarray;
            goodsdata['products'] = products;

            $.each (specArrJson, function() {
              var sc = this;
              $.each (sc.Value, function() {
                  attributes.push({
                    'SpecId': sc.Id,
                    'SpecValue': this,
                    'AttributeId':null,
                    'AttributeValue': null
                  });
                });
            });
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

         if( imgs.length >  0 )
         {
            goodsdata['img'] = JSON.stringify(imgs); //$('#goods-url').val();
          }

         //console.log(goodsdata);


          url = form.attr( "action" );
          var posting = $.post( url, goodsdata );


          posting.done(function( data ) {

              if( data.success)
              {

                window.location = globalSetting.baseUrl + '/goods/index/search';
                return false;
              }

          });

          return false;

      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/index/search';
        return false;
    });

    function initUploader() {
        var liUploader = $('#goods-image-uploader').parent().parent();
        function updateLiUploaderStatus() {
            if ($('input[name="goods_picture_url[]"]').length >= 3) {
                liUploader.hide();
            } else {
                liUploader.show();
            }
        }
        function bindRemove() {
            $('.formimglst .remove-thumb').click(function() {
                $(this).parent().fadeOut('normal', function() {
                    $(this).remove();
                    updateLiUploaderStatus();
                });

                return false;
            });
        }
        bindRemove();

        var popup = $(' \
            <div class="crop-container"> \
                <div class="crop-content"> \
                    <img class="crop-img-o" src=""/> \
                    <input type="hidden" name="x1" value="" /> \
                    <input type="hidden" name="y1" value="" /> \
                    <input type="hidden" name="x2" value="" /> \
                    <input type="hidden" name="y2" value="" /> \
                </div> \
                <div class="crop-preview"> \
                    <p>拖拽或缩放曲线框，<br/>生成方形图片。</p> \
                    <div class="crop-preview-110"> \
                        <img class="crop-img-preview-110" src="" /> \
                    </div> \
                    <p>110*110像素</p> \
                    <div class="crop-preview-64"> \
                        <img class="crop-img-preview-64" src="" /> \
                    </div> \
                    <p>64*64像素</p> \
                    <div class="crop-preview-30"> \
                        <img class="crop-img-preview-30" src="" /> \
                    </div> \
                    <p>30*30像素</p> \
                </div> \
            </div> \
        ');


        $('#goods-image-uploader').uploadify({
            fileObjName: 'uploadfile',
            width: 102,
            height: 102,
            multi: false,
            checkExisting: false,
            preventCaching: false,
            fileExt: '*.jpg;*.jpeg;*.png',
            fileDesc: 'Image file (.jpg, .jpeg, .png)',
            buttonText: '<i class="iconfont">&#xf0175;</i>',
            swf: WF.setting.staticAssetBaseUrl + '/swf/uploadify.swf',
            uploader: WF.setting.apiBaseUrl + '/upload/image',
            onUploadError: function(file, errorCode, errorMsg, errorString) {
                console.log(errorString);
            },
            onUploadSuccess: function(file, data, response) {
                var result = $.parseJSON(data);
                if (result.success !== false) {
                    var imgTemplate = $(' \
                        <li> \
                            <span class="u-img2"> \
                                <a href="javascript:;"> \
                                    <img class="company-picture" /> \
                                </a> \
                            </span> \
                            <input type="hidden" value="" name="goods_picture_url[]" /> \
                            <a class="company-picture-update update-thumb" href="#">调整缩略图</a> \
                            <a class="remove-thumb" href="#">移除</a> \
                        </li> \
                    ');

                    imgTemplate.find('img').attr('src', result.Thumb110Url)
                                           .attr('data-110', result.Thumb110Url)
                                           .attr('data-ori', result.OriginalUrl);
                    imgTemplate.find('input[type=hidden]').val(result.Thumb480Url);

                    imgTemplate.insertBefore(liUploader).hide().fadeIn();

                    bindRemove();

                    imgTemplate.find('.update-thumb').click(function() {
                        var crop = null;
                        var img = $(this).parent().find('.company-picture');
                        var imgUrl = img.attr('data-ori');
                        if (!imgUrl) {
                            WF.showMessage('error', '注意', '请先上传一张图片');
                            return false;
                        }

                        $(popup).dialog({
                            resizable: false,
                            title: '编辑缩略图',
                            width: 600,
                            height:500,
                            modal: true,
                            draggable: false,
                            buttons: {
                                '保存': function() {
                                    var opts = {
                                        type: 'POST',
                                        url: WF.setting.apiBaseUrl + '/upload/image/crop',
                                        dataType: 'json',
                                        data: {
                                            x1: $('input[name="x1"]').val(),
                                            y1: $('input[name="y1"]').val(),
                                            x2: $('input[name="x2"]').val(),
                                            y2: $('input[name="y2"]').val(),
                                            img: img.attr('data-ori')
                                        },
                                        success: function(data, textStatus, jqXHR) {
                                            img.attr('src', img.attr('data-110') + '?timestamp=' + new Date().getTime());
                                            popup.dialog('close');
                                        }
                                    };
                                    $.ajax(opts);
                                },
                                '取消': function() {
                                    $(this).dialog('close');
                                }
                            },
                            open: function() {
                                var imgO = popup.find('.crop-img-o');
                                imgO.attr('src', imgUrl);

                                var imgPreview110 = popup.find('.crop-img-preview-110');
                                imgPreview110.attr('src', imgUrl).removeAttr('style');

                                var imgPreview64 = popup.find('.crop-img-preview-64');
                                imgPreview64.attr('src', imgUrl).removeAttr('style');

                                var imgPreview30 = popup.find('.crop-img-preview-30');
                                imgPreview30.attr('src', imgUrl).removeAttr('style');

                                WF.getImageSize(imgUrl, function(width, height) {
                                    if (width >= height) {
                                        imgO.css('width', imgO.parent().width())
                                            .css('height', 'auto')
                                            .css('margin-top', (imgO.parent().height() - imgO.height()) / 2)
                                            .show();
                                    } else {
                                        imgO.css('height', imgO.parent().height())
                                        .css('width', 'auto')
                                        .css('margin-left', (imgO.parent().width() - imgO.width()) / 2)
                                        .show();
                                    }

                                    crop = imgO.imgAreaSelect({
                                        instance: true,
                                        handles: true,
                                        aspectRatio: '1:1',
                                        onSelectEnd: function(img, selection) {
                                            var rate = width / imgO.width();

                                            $('input[name="x1"]').val(selection.x1 * rate);
                                            $('input[name="y1"]').val(selection.y1 * rate);
                                            $('input[name="x2"]').val(selection.x2 * rate);
                                            $('input[name="y2"]').val(selection.y2 * rate);
                                        },
                                        onSelectChange: function(img, selection) {
                                            var imgOWith = imgO.width();
                                            var imgOHeight = imgO.height();

                                            var scaleX = 110 / (selection.width || 1);
                                            var scaleY = 110 / (selection.height || 1);
                                            imgPreview110.css({
                                                width: Math.round(scaleX * imgOWith) + 'px',
                                                height: Math.round(scaleY * imgOHeight) + 'px',
                                                marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
                                                marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
                                            });

                                            scaleX = 64 / (selection.width || 1);
                                            scaleY = 64 / (selection.height || 1);
                                            imgPreview64.css({
                                                width: Math.round(scaleX * imgOWith) + 'px',
                                                height: Math.round(scaleY * imgOHeight) + 'px',
                                                marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
                                                marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
                                            });

                                            scaleX = 30 / (selection.width || 1);
                                            scaleY = 30 / (selection.height || 1);
                                            imgPreview30.css({
                                                width: Math.round(scaleX * imgOWith) + 'px',
                                                height: Math.round(scaleY * imgOHeight) + 'px',
                                                marginLeft: '-' + Math.round(scaleX * selection.x1) + 'px',
                                                marginTop: '-' + Math.round(scaleY * selection.y1) + 'px'
                                            });
                                        }
                                    });
                                });
                            },
                            close: function() {
                                if (crop) {
                                    crop.remove(true);
                                }
                                popup.dialog('destroy').remove();
                            }
                        });

                        return false;
                    });

                    updateLiUploaderStatus();
                } else {
                    WF.showMessage('error', '错误', '上传失败，请重试！');
                }
            }
        });
    }
    initUploader();
});