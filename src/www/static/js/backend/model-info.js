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
            $('#spectable').find('.btnDelete').click(function(){
              $(this).parents('tr:first').remove();
              return false;
            });
            $('#spectable').find('.btnUp').click(function(){
              var row = $(this).parents('tr:first');
              row.insertBefore(row.prev());
              return false;
            });
            $('#spectable').find('.btnDown').click(function(){
              var row = $(this).parents('tr:first');
              row.insertAfter(row.next());
              return false;
            });

          }
          $('#specList').dialog("close");
        });
     });

  }
};

$(function() {
    var validator = $('#frm-model-info').Validform({
        tiptype: 3
    });

    $('#btnAddAttribute').click(function(){

      var row = '   <tr class="attributerow"> ' +
                '               <td><input name="attributename" type="text" value="" datatype="s" class="u-ipt u-auto-width"/></td> ' +
                '               <td>'+
                '                     <select name="attributetype"  class="u-sel u-auto-width" > '+
                '                        <option value="1" >单选框</option> ' +
                '                        <option value="2" >复选框</option> ' +
                '                       <option value="3" >下拉框</option>  ' +
                '                     </select> '+
                '                </td> '+
                '                <td><input name="attributevalue" type="text" value=""  class="u-ipt u-auto-width"/></td>'+
                '                <td class="col-center"> <input name="attributesearch" type="checkbox"/></td> ' +
                '                <td class="col-center"><a href="#" class="btnDelete"><i class="iconfont">&#xf013f;</i></a></td>' +
                '            </tr>';

        $('#attributetable tbody').append( $(row));
        $('.content').height($('.content').height() + 50);
        $('#attributetable').find('.btnDelete').click(function() {
            $(this).parents('tr:first').remove();
            return false;
        });
    });

    $('#spectable').find('.btnDelete').click(function(){
        $(this).parents('tr:first').remove();
        return false;
    });

    $('#attributetable').find('.btnDelete').click(function() {
        $(this).parents('tr:first').remove();
        return false;
    });

    $('#spectable').find('.btnUp').click(function(){
      var row = $(this).parents('tr:first');
      row.insertBefore(row.prev());
      return false;
    });
    $('#spectable').find('.btnDown').click(function(){
      var row = $(this).parents('tr:first');
      row.insertAfter(row.next());
      return false;
    });

    $('#btnAddSpec').click(function(){
      $('#specList').dialog({"modal": true, "width":800, "height":640});
      WF.Model.updateSpecList(1);
    });

    $( "#frm-model-info" ).submit(function( event ) {
        if (!validator.check()) {
          return false;
        }

          var form = $( this );

          var name = $('#modelname').val();

          var specids  = $('tr.specid').map(function(i,n) {
                return $(n).attr('data-id');
          }).get().join(",");

          var attributes =  $('tr.attributerow').map(function(i,n) {
                return {
                    'name':$(n).find('input[name="attributename"]').val(),
                    'type':$(n).find('select[name="attributetype"]').val(),
                    'value':$(n).find('input[name="attributevalue"]').val(),
                    'search': $(n).find('input[name="attributesearch"]:checked').length
                 };
          }).get();




          url = form.attr( "action" );

          var posting = $.post( url, {
                'name': name,
                'specids':specids,
                'attributes': attributes
            } );


          posting.done(function( data ) {

              if( data.success)
              {
                window.location = globalSetting.baseUrl + '/goods/model/search';
                return false;
              } else {
                WF.showMessage('error', '注意', data.message);
              }

          });

          return false;
      });

    $('#btnCancel').click(function(){
        window.location = globalSetting.baseUrl + '/goods/model/search';
        return false;
    });
});