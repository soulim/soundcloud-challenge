(function($) {
  $.fn.superupload = function(options) {
    function start(form, fileInput, iframe, statusLabel) {
      form.after(iframe).attr('target', iframe.attr('name'));
      fileInput.after(statusLabel);
      
      form.submit();
      
      form.attr('target', null);
      fileInput.attr('disabled', 'disabled')
    
      timer = setInterval(function() { update(statusLabel) }, options.interval);
    };
    
    function stop() {
      // ... request file path
      clearInterval(timer);
    };

    function update(statusLabel) {
      $.get(options.status_path, { 'X-Progress-ID': options.progress_id },
        function(data) {
          progress = Math.round((data.received / data.size) * 100);
          statusLabel.text('Status: ' + progress + '%.');

          if (data.status == 'done') { stop(); }
        });
    };
        
    function setup(form) {
      var form        = $(form),
          fileInput   = form.find('input[type=file]'),
          statusLabel = $('<div />'),
          iframe      = $('<iframe />').attr({
              src:  '#',
              name: 'upload-target'
            }).css({
              border: 0,
              width:  0,
              height: 0
            });
      
      fileInput.change(function() {
        start(form, fileInput, iframe, statusLabel)
      });
    };

    var timer   = null,
        options = $.extend({
            status_path: '/status',
            progress_id: '',
            interval: 1000
          }, options);

    return  this.each(function () {
      setup(this);
    });
  };
})(jQuery);