(function($) {
  $.fn.superupload = function(options) {
    function start(form, fileInput, iframe, statusLabel) {
      form.after(iframe).attr('target', iframe.attr('name'));
      fileInput.after(statusLabel);

      form.submit();

      form.attr('target', null);
      fileInput.attr('disabled', 'disabled')

      setTimer(statusLabel);
    };

    function stop(statusLabel) {
      $.ajax({
        'url': options.uploads_path + '/' + options.progress_id,
        'cache': false,
        'success': function(data) {
            var links = [];

            for (filename in data['files']) {
              links.push($('<a />').attr('href', data['files'][filename]).
                                    text('Uploaded to here.'));
            };

            $(links).each(function() { this.appendTo(statusLabel) });
          }
        });
    };

    function update(statusLabel) {
      $.ajax({
        'url': options.status_path,
        'data': { 'X-Progress-ID': options.progress_id },
        'cache': false,
        'success': function(data) {
            progress = Math.round((data.received / data.size) * 100);
            statusLabel.text('Status: ' + progress + '%. ');

            if (data.status == 'done') {
              stop(statusLabel);
            } else {
              setTimer(statusLabel);
            };
          }
      });
    };

    function setTimer(statusLabel) {
      setTimeout(function() { update(statusLabel); }, options.interval);
    };

    function setup(form) {
      var form        = $(form),
          fileInput   = form.find('input[type=file]'),
          statusLabel = $('<div />'),
          iframe      = $('<iframe name="upload-target" />').attr({
              src:  '#'
            }).css({
              border: 0,
              width:  0,
              height: 0
            });

      fileInput.change(function() {
        start(form, fileInput, iframe, statusLabel);
      });
    };

    var options = $.extend({
            uploads_path: '/uploads',
            status_path:  '/status',
            progress_id:  '',
            interval:     1000
          }, options);

    return this.each(function () {
      setup(this);
    });
  };
})(jQuery);
