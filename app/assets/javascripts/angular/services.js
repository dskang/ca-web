app.constant('DROPDOWN_THRESHOLD', 15);

app.value('fbAuth', {
  status: null
});

app.factory('env', function($location) {
  var hosts = {
    production: 'campusanonymous.com',
    staging: 'herokuapp.com',
    development: 'ca.local'
  };
  for (var env in hosts) {
    if (hosts.hasOwnProperty(env)) {
      var host = hosts[env];
      if ($location.host().indexOf(host) !== -1) {
        return env;
      }
    }
  }
})

app.factory('socketUrl', function($location, env) {
  var socketUrl;
  var domain = $location.host().split('.').slice(-2).join('.');
  if (env === 'production') {
    socketUrl = 'https://socket.' + domain;
  } else if (env === 'staging') {
    socketUrl = $location.host().replace('web', 'socket');
  } else {
    socketUrl = 'http://socket.' + domain + ':5000';
  }
  return socketUrl;
});

app.factory('socket', function($rootScope, socketUrl) {
  var socket = io(socketUrl, {
    reconnection: false,
    transports: ['websocket']
  });
  return {
    on: function (eventName, callback) {
      socket.on(eventName, function () {
        var args = arguments;
        $rootScope.$apply(function () {
          callback.apply(socket, args);
        });
      });
    },
    emit: function (eventName, data, callback) {
      socket.emit(eventName, data, function () {
        var args = arguments;
        $rootScope.$apply(function () {
          if (callback) {
            callback.apply(socket, args);
          }
        });
      })
    }
  };
});

app.factory('messages', function($rootScope, $window) {
  var messages = [];
  var stats = {
    unread: 0,
    sent: 0,
    received: 0
  };

  $window.onfocus = function() {
    $rootScope.$apply(function() {
      stats.unread = 0;
    });
  };

  return {
    add: function(message) {
      messages.push(message);

      if (message.type === 'chat') {
        if (message.name === 'You') {
          stats.sent++;
        } else {
          stats.received++;
        }

        if (!$window.document.hasFocus()) {
          stats.unread++;
        }
      }
    },
    get: function() {
      return messages;
    },
    stats: stats
  };
});

app.factory('dropdown', function($rootScope, socket, messages, fbAuth) {
  var showDropdown = false;
  var dropdownShown = false;
  var selfRevealed = false;

  var handleFbError = function() {
    $rootScope.$apply(function() {
      messages.add({
        type: 'system',
        important: true,
        template: 'fbError'
      });
      showDropdown = true;
      selfRevealed = false;
    });
  };

  // Send the identity to the server
  var sendIdentity = function() {
    FB.api('/me', function(response) {
      if (!response || response.error) {
        handleFbError();
      } else {
        socket.emit('identity', {
          name: response.name,
          link: response.link
        });
        $rootScope.$apply(function() {
          messages.add({
            type: 'system',
            template: 'selfRevealed'
          });
        });
        mixpanel.register({
          gender: response.gender
        });
        mixpanel.track('self revealed');
        mixpanel.people.set({
          "$first_name": response.first_name,
          "$last_name": response.last_name,
          "$name": response.name,
          fb_id: response.id,
          gender: response.gender
        });
        mixpanel.people.increment('self_revealed');
      }
    });
  };

  var revealIdentity = function() {
    selfRevealed = true;

    if (fbAuth.status === 'connected') {
      sendIdentity();
    } else {
      mixpanel.track('facebook prompt');
      FB.login(function(response) {
        if (response.authResponse) {
          sendIdentity();
        } else {
          $rootScope.$apply(function() {
            showDropdown = true;
            selfRevealed = false;
          });
          mixpanel.track('facebook cancelled');
        }
      });
    }
  };

  return {
    show: function() {
      if (!dropdownShown) {
        mixpanel.track('dropdown displayed');
      }
      showDropdown = true;
      dropdownShown = true;
    },
    hide: function() {
      showDropdown = false;
    },
    previouslyShown: function() {
      return dropdownShown;
    },
    shouldShowFull: function() {
      return showDropdown;
    },
    shouldShowMinimized: function() {
      return !showDropdown && dropdownShown && !selfRevealed;
    },
    accept: function() {
      showDropdown = false;
      revealIdentity();
      mixpanel.track('dropdown accepted', {
        messagesSent: messages.stats.sent,
        messagesReceived: messages.stats.received
      });
    }
  };
});

app.factory('timer', function() {
  var timers = {};
  return {
    getTimer: function(label) {
      return timers[label];
    },
    start: function(label) {
      if (timers[label]) {
        console.error("Cannot start timer '" + label + "'");
      } else {
        timers[label] = {
          start: Date.now(),
          end: null
        };
      }
    },
    stop: function(label) {
      if (!timers[label] || timers[label].end) {
        console.error("Cannot stop timer: '" + label + "'");
      } else {
        timers[label].end = Date.now();
      }
    },
    getDuration: function(label) {
      var timer = timers[label];
      if (!timer || !timer.start || !timer.end) {
        console.error("Cannot get duration of timer: '" + label + "'");
      } else {
        return Math.floor((timer.end - timer.start) / 1000);
      }
    }
  };
});
