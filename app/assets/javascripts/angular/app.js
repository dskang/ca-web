var app = angular.module('pom', ['ngSanitize', 'ngAnimate']);

var loadMixpanel = function(window) {
  (function(f,b){if(!b.__SV){var a,e,i,g;window.mixpanel=b;b._i=[];b.init=function(a,e,d){function f(b,h){var a=h.split(".");2==a.length&&(b=b[a[0]],h=a[1]);b[h]=function(){b.push([h].concat(Array.prototype.slice.call(arguments,0)))}}var c=b;"undefined"!==typeof d?c=b[d]=[]:d="mixpanel";c.people=c.people||[];c.toString=function(b){var a="mixpanel";"mixpanel"!==d&&(a+="."+d);b||(a+=" (stub)");return a};c.people.toString=function(){return c.toString(1)+".people (stub)"};i="disable track track_pageview track_links track_forms register register_once alias unregister identify name_tag set_config people.set people.set_once people.increment people.append people.track_charge people.clear_charges people.delete_user".split(" ");
for(g=0;g<i.length;g++)f(c,i[g]);b._i.push([a,e,d])};b.__SV=1.2;a=f.createElement("script");a.type="text/javascript";a.async=!0;a.src="//cdn.mxpnl.com/libs/mixpanel-2-latest.min.js";e=f.getElementsByTagName("script")[0];e.parentNode.insertBefore(a,e)}})(document,window.mixpanel||[]);
  mixpanel.init("e6c5a741808493e34173b3938579271e");
};

var loadGoogleAnalytics = function(window) {
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-23357698-3', 'auto');
  ga('send', 'pageview');
};

var loadFacebook = function(window) {
  (function(d, s, id){
    var js, fjs = d.getElementsByTagName(s)[0];
    if (d.getElementById(id)) {return;}
    js = d.createElement(s); js.id = id;
    js.src = "//connect.facebook.net/en_US/sdk.js";
    fjs.parentNode.insertBefore(js, fjs);
  }(window.document, 'script', 'facebook-jssdk'));
};

app.run(function($window, env) {
  loadGoogleAnalytics($window);
  loadMixpanel($window);

  var fbAppId;
  if (env === 'production') {
    fbAppId = '446772905471110';
  } else if (env === 'staging') {
    fbAppId = '446776882137379';
    mixpanel.register({ "$ignore": true });
  } else if (env === 'development') {
    fbAppId = '446774172137650';
    mixpanel.register({ "$ignore": true });
  }

  $window.fbAsyncInit = function() {
    FB.init({
      appId: fbAppId,
      xfbml: true,
      version: 'v2.2'
    });
  };

  loadFacebook($window);
});
