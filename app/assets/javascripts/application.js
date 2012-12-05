// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require bootstrap-datepicker
//= require_tree .
//= require_self

$.extend({
  getUrlVars: function(){
    var vars = [], hash;
    var hashes = window.location.href.slice(window.location.href.indexOf('?') + 1).split('&');
    for(var i = 0; i < hashes.length; i++)
    {
      hash = hashes[i].split('=');
      vars.push(hash[0]);
      vars[hash[0]] = hash[1];
    }
    return vars;
  },
  getUrlVar: function(name){
    return $.getUrlVars()[name];
  }
});

$(function() {
  $('a:not([data-remote]):not([data-behavior]):not([data-skip-pjax])').pjax('#content', { timeout: 3000 });
  $('#feed_select select').on('change', function() {
    var url = $(this).find('option:selected').val();
    if(url.length > 0) { top.location = url; }
  });
})

$.fn.poll = function(fn, timeout) {
  this.each(function() {
    var $this = $(this),
        data = $this.data();

    if (data.polling) {
      clearTimeout(data.polling);
    }
    if (fn !== false) {
      var callback = function() { $this.poll(fn, timeout) };
      data.polling = setTimeout(function() { fn(callback); }, timeout || 5000);
    }
  });
}