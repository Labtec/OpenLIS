$(function() {
  $(".lab_tests").sortable({
    axis: 'y',
    handle: '.handle',
    update: function() {
      $.ajax({
        type: 'post',
        data: $(".lab_tests").sortable('serialize'),
        dataType: 'script',
        complete: function(request){
          $(".lab_tests").effect('highlight');
        },
        url: '/admin/lab_tests/sort'
      });
    }
  }).disableSelection();
});