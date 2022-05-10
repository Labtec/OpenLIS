$(document).on('turbo:load turbo:render', function() {
  return $('.lab_tests').sortable({
    axis: 'y',
    handle: '.handle',
    update: function() {
      return $.ajax({
        type: 'patch',
        data: $(this).sortable('serialize'),
        headers: {
          'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
        },
        dataType: 'script',
        complete: function(request) {
          return $('.lab_tests').effect('highlight');
        },
        url: $(this).data('update-url')
      });
    }
  });
});
