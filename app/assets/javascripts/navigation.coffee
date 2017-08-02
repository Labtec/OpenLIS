setTimeout ->
  $('.flash_notice').fadeOut 2000
, 3000

$(document).on 'turbolinks:load', ->
  $('li.contact').mouseenter ->
    $(this).css 'background': 'seashell'
    $(this).children('.tools').show()
  $('li.contact').on 'click mouseleave', ->
    $(this).css 'background': 'white'
    $(this).children('.tools').hide()
