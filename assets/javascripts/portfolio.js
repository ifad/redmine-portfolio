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
  this.field('plain_description');
  this.ref('id');
});

$(function(){
  vex.defaultOptions.className = 'vex-theme-plain';

  debounce(function(){ $('#search').focus(); });

  $('#container')
    .on('click', '[data-modal="info"]', function(e) {
      e.preventDefault();

      var project  = projects[$(this).data('idx')],
            image  = $('<div/>').append($('<img/>', {src: project.image_src, title: project.title})).html(),
             body  = image + project.description;

      $('#container').removeClass('not-blur').addClass('blur');

      vex.dialog.open({
        message: project.title,
        input: body,
        buttons: [
            $.extend({}, vex.dialog.buttons.NO, {text: 'Close'}),
            $.extend({}, vex.dialog.buttons.YES, {text: 'Open app', click: function(){ window.open(project.url, '_blank')}})
        ],
        callback: function(data){
          $('#container').removeClass('blur').addClass('not-blur');
        }
      })

    })
    .on('click', '#mobile-info-toggler', function(e){
      e.preventDefault();

      var     self = $(this),
               img = self.find('img'),
               src = img.attr('src'),
            active = self.data('active'),
          inactive = self.data('inactive');

      if(src.indexOf(active) >= 0) {
        img.attr('src', src.replace(active, inactive));

        $('#projects .image > a[data-modal="info"]').fadeOut(400, function(){
          $('#projects .image > a.homepage').fadeIn();
        });
      } else {
        img.attr('src', src.replace(inactive, active));

        $('#projects .image > a.homepage').fadeOut(200, function(){
          $('#projects .image > a[data-modal="info"]').fadeIn();
        });
      }

    })
    .on('keydown', '#search', debounce(function(e) {
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
