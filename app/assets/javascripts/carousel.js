// Homepage text carousel

$(document).ready(function(){
  var schools = $('.carousel');
  schools.eq(0).addClass('carousel-entrance');
  var counter = 0;

  setInterval(function() {
    schools.eq(counter).removeClass('carousel-entrance');

    counter++;
    if (counter == schools.length) counter = 0;

    schools.eq(counter).addClass('carousel-entrance');
  }, 2000);
});
