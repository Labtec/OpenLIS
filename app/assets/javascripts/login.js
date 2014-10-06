//= require jquery
//= require jquery-ui/effect-shake

$(function() {
  $("div#login form :input:visible:first").focus();

  $(".errors").ready( function () {
    $(".errors").effect("shake", { distance: 15 });
  });
});
