var debounce = function (fn) {
  var timeout;

  return function () {
    var args = Array.prototype.slice.call(arguments),
         ctx = this;

    clearTimeout(timeout);

    timeout = setTimeout(function () {
      fn.apply(ctx, args);
    }, 100);
  }
};

var index = lunr(function () {
  this.field('title', {boost: 10});
  this.field('body');
  this.ref('id');
});

$(function(){
  vex.defaultOptions.className = 'vex-theme-plain';

  debounce(function(){ $('#search').focus(); });

  $( ".info" ).on('click', function(e) {
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

  $('#search')
    .on('keydown', debounce(function(e) {
      var self = $(this),
          apps = $('.application');

      apps.removeClass('inactive').addClass('active');

      if (e.keyCode == 27) self.val('');

      var q = self.val();

      if (q.length < 2) return;

      apps.removeClass('active').addClass('inactive');

      index.search(q).map(function (r) {
        $('#' + r.ref).removeClass('inactive').addClass('active');
      });
    })
  );

});
