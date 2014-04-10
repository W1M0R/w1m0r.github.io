function svgAnimate(svg, fnDuration) {

  function toArray(arr) {
    return Array.prototype.slice.call(arr);
  }
  
  svg.parentNode.style.visibility = '';
 
  var paths = toArray(svg.querySelectorAll('path'));

  var durations = paths.map(fnDuration);

  var begin = 0; 
  paths.forEach(function(path, i) {
    var length = path.getTotalLength();
    path.style.transition = path.style.WebkitTransition = 'none';
    path.style.strokeDasharray = length + ' ' + length;
    path.style.strokeDashoffset = length;
    path.offsetWidth;
    path.getBoundingClientRect();
    path.style.transition = path.style.WebkitTransition = 'stroke-dashoffset ' + durations[i] + 's ' + begin + 's ease-in-out';
    path.style.strokeDashoffset = '0';
    begin += durations[i] + 0.1;
  });
}
