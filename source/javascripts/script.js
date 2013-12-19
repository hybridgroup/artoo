function heart() {
  var $heart = $(".heart");
  if($heart.is(":visible")) {
    $heart.animate({
      fontSize: $heart.css('fontSize') == '20px' ? '30px' : '20px'
    }, 500, heart);
  }
}
$(document).ready(function() {
  $('header .subtitle').hover(function() {
    $('.easter', this).show();
    $('.main', this).hide();
    heart();
  }, function () {
    $('.easter', this).hide();
    $('.main', this).show();
  });
});