setTimeout(function(){
  $(".flash_notice").fadeOut(2000);
}, 3000);

$(".pending a").on("click", function() {
  $("#pending_paging").show();
  $.getScript(this.href);
  return false;
});

$(".paginate a").on("click", function() {
  $("#paging").show();
  $.getScript(this.href);
  return false;
});

$(document).on("page:change", function() {
  $("li.contact").mouseenter(function() {
    $(this).css({
      "background" : "seashell"
    });
    $(this).children(".tools").show();
  });

  $("li.contact").on("click mouseleave", function() {
    $(this).css({
      "background" : "white"
    });
    $(this).children(".tools").hide();
  });
});

/* Safari bug
 * http://stackoverflow.com/questions/5297122/preventing-cache-on-back-button-in-safari-5
 */
$(window).bind("pageshow", function(event) {
  if (event.originalEvent.persisted) {
    window.location.reload()
  }
});
