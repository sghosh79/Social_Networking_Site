// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require turbolinks
//= require private_pub
//= require chat_system
//= require nprogress
//= require nprogress-turbolinks
//= require jquery.remotipart
//= require_tree .

NProgress.configure({
  showSpinner: true,
  ease: 'ease',
  speed: 100
});

$(document).on('ready page:load', function () {
  $("#friend_requests").on('click', function(){
    $(".loader").show();
    $(".notification-box .message-preview").remove()
  })

  $('.auto-grow').autogrow();
})