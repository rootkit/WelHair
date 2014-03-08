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
    function bindClose() {
        $('.autocomplete-search-result .close').click(function() {
            var iptContainer = $(this).parent().parent();
            iptContainer.find('.autocomplete-search-result').hide();
            iptContainer.find('input[type=text]').val('').show();
            iptContainer.find('input[type=hidden]').val(0);

            if (iptContainer.find('.autocomplete-search-result').attr('id') == 'staff-search-result') {
              $('#service-list tbody tr').remove();
            }
        });
    }

    function bindAutoComplete($type) {
        $('#' + $type + '-search').autocomplete({
          minLength: 1,
          source: function (request, response) {
            $.ajax({
              url: WF.setting.baseUrl + '/ajax/' + $type + '/search',
              data: {
                search: $('#' + $type + '-search').val(),
                include_client: 0
              },
              success: function(data) {
                response($.map(data, function(item) {
                  return item;
                }));
              }
            });
          },
          focus: function(event, ui) {
            return false;
          },
          select: function(event, ui) {
            $('#' + $type + '-search').hide();
            $('#' + $type + '-search-value').val(ui.item.value);

            var resultBlock = $('#' + $type + '-search-result');
            resultBlock.find('.autocomplete-item-icon').attr('src', ui.item.icon);
            resultBlock.find('.autocomplete-item-label').html(ui.item.title);
            resultBlock.find('.autocomplete-item-detail').html($type == 'staff' ? ui.item.company.Name : ui.item.detail);
            resultBlock.show();

            if ($type == 'staff') {
              $tbody = $('#service-list tbody');
              $tbody.find('tr').remove();

              $(ui.item.services).each(function(idx, el) {
                  $tbody.append(' \
                      <tr> \
                          <td class="col-center"> \
                              <input type="radio" name="service_id" value="' + el.ServiceId + '" /> \
                          </td> \
                          <td>' + el.Title + '</td> \
                          <td class="col-center">' + el.OldPrice + '</td> \
                          <td class="col-center">' + el.Price + '</td> \
                      </tr>');
              });
            }

            return false;
          }
        })
        .data('ui-autocomplete')._renderItem = function(ul, item) {
          return $('<li class="clearfix">')
            .append('<a class="autocomplete-item"> \
                        <img class="autocomplete-item-icon" src="' + item.icon + '" /> \
                        <strong class="autocomplete-item-label">' + item.title + '</strong> \
                        <span class="autocomplete-item-detail">' + ($type == 'staff' ? item.company.Name : item.detail) + '</span> \
                    </a>')
            .appendTo(ul);
        };
    }

    bindAutoComplete('user');
    bindAutoComplete('staff');
    bindClose();
});