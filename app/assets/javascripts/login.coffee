#= require jquery3
#= require jquery-ui/effects/effect-shake

$ ->
  $('div#login form :input:visible:first').focus()
  $('.errors').ready ->
    $('.errors').effect 'shake', distance: 15
