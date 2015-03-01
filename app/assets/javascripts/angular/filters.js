app.filter('linkyNewlines', function() {
  return function(input) {
    // NB: 'linky' outputs new lines (\n) as html escaped tabs
    return input.replace(/&#10;/g, '<br/>');
  }
});

app.filter('properSchoolName', function() {
  var capitalize = function(str) {
    return str.charAt(0).toUpperCase() + str.slice(1);
  }
  return function(school) {
    if (school === 'upenn') {
      return "Penn";
    } else {
      return capitalize(school);
    }
  }
});
