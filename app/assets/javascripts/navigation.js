setTimeout(function(){
  $(".flash_notice").fadeOut(2000);
}, 3000);

$(document).on('mouseover', 'li.contact', function () {
  $(this).css({
    'background' : 'seashell'
  });
  $(this).children(".tools").show();
});

$(document).on('mouseout', 'li.contact', function () {
  $(this).css({
    'background' : 'white'
  });
  $(this).children(".tools").hide();
});

$(document).on('click', '.pending_pagination a', function () {
  $("#pending_paging").show();
  $.getScript(this.href);
  return false;
});

$(document).on('click', '.pagination a', function () {
  $("#paging").show();
  $.getScript(this.href);
  return false;
});
