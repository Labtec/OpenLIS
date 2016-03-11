setTimeout ->
  $('.flash_notice').fadeOut 2000
, 3000

$('.pending a').on 'click', ->
  $('#pending_paging').show()
  $.getScript @href

$('.paginate a').on 'click', ->
  $('#paging').show()
  $.getScript @href

$(document).on 'page:change', ->
  $('li.contact').mouseenter ->
    $(this).css 'background': 'seashell'
    $(this).children('.tools').show()
  $('li.contact').on 'click mouseleave', ->
    $(this).css 'background': 'white'
    $(this).children('.tools').hide()

# Safari bug
# http://stackoverflow.com/questions/5297122/preventing-cache-on-back-button-in-safari-5
$(window).bind 'pageshow', (event) ->
  if event.originalEvent.persisted
    window.location.reload()
