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
          
          var first= $('#basicdatatable thead tr th:first');
          var row = $('<th class="cola">' + $(this).attr('data-name') + '</th>');
          first.after(row);
          var val = $(this).attr('data-value');
          //var vals = json_
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