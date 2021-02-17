$(document).on 'turbolinks:load', ->
  $('.lab_tests').sortable
    axis: 'y'
    handle: '.handle'
    update: ->
      $.ajax
        type: 'patch'
        data: $(this).sortable('serialize')
        headers: { 'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content') }
        dataType: 'script'
        complete: (request) ->
          $('.lab_tests').effect 'highlight'
        url: $(this).data('update-url')
