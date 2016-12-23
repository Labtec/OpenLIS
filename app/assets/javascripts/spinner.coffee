@startSpinner = ->
  $('html').css 'cursor', 'progress'

@stopSpinner = ->
  $('html').css 'cursor', 'auto'

$(document).on 'page:fetch', startSpinner
$(document).on 'page:receive', stopSpinner
