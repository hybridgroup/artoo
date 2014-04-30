$(document).ready(function(){

    var allPanels = $('.accordion-docs > dd').hide();
    
  $('.accordion-docs > dt > a').click(function() {
    allPanels.slideUp();
    $(this).parent().next().slideDown();
    return false;
  });

  $(".active-panel").slideDown();

});