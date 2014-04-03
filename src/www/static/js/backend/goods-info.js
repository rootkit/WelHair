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

          return;
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
    $('#frm-goods-info').Validform({
        tiptype: 3
    });

    $('#btnAddSpec').click(function(){
      $('#specList').dialog({"modal": true, "width":800, "height":640});
      WF.Model.updateSpecList(1);
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
                'name': name
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