$(document).ready(function () {
  // Update machine info
  $('#btn_machine_config').click(function () {
    var $mcm = $('#machine_config_msg');
    $mcm.empty();

    var request = update_machine_config($('#station_name').val(), $('#network_name').val(), $('#ip_address').val(), $('#port').val());

    request.done(function (data) {
      $mcm.html(data);
      reload_station_list().done(function (data) {
        var $station_list = $('.result .table > tbody');
        $station_list.empty();
        $station_list.html(data);
      });
    });
    
    request.fail(function (jqXHR) {
      $mcm.html(jqXHR.responseText);
    });
  });

  function update_machine_config(station_name, network_name, ip_address, port) {
    var myData = {
      'station_name': station_name,
      'network_name': network_name,
      'ip_address': ip_address,
      'port': port
    };
    
    return $.ajax({
      type: 'POST',
      url: '/stations/update_machine_config',
      data: myData,
      dataType: 'html'
    });
  }

  function reload_station_list() {
    return $.ajax({
      type: 'GET',
      url: '/stations/station_list',
      dataType: 'html'
    });
  }
});