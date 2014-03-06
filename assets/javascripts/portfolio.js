$(function(){
  vex.defaultOptions.className = 'vex-theme-plain';

  $( ".info" ) .on('click', function(e) {
    e.preventDefault();

    var self = $(this),
        body = self.clone().html() + self.data('description');

    vex.dialog.open({
      message: self.data('title'),
      input: body,
      buttons: [
          $.extend({}, vex.dialog.buttons.YES, {text: 'Close'})
      ]
    })


  });

});
