app.controller('TitleCtrl', function($scope, $window, $interval, messages) {
  var originalTitle = $window.document.title;
  var getParenTitle = function(unread) {
    return '(' + unread + ') ' + originalTitle;
  };
  var getUnreadTitle = function(unread) {
    var title = unread + ' new message';
    if (unread > 1) title += 's';
    return title;
  };

  var currentTitle = getParenTitle;
  var toggleTitle = function() {
    if (currentTitle === getParenTitle) {
      currentTitle = getUnreadTitle;
    } else {
      currentTitle = getParenTitle;
    }
  };

  var toggle;
  $scope.getTitle = function() {
    var unread = messages.stats.unread;
    if (unread > 0) {
      if (!angular.isDefined(toggle)) {
        toggle = $interval(toggleTitle, 1000);
      }
      return currentTitle(unread);
    } else {
      if (angular.isDefined(toggle)) {
        $interval.cancel(toggle);
        toggle = undefined;
        currentTitle = getParenTitle;
      };
      return originalTitle;
    }
  };
});

app.controller('ChatCtrl', function($scope, $window, socket, messages, dropdown, timer, DROPDOWN_THRESHOLD, partner) {
  $scope.partner = partner;
  $scope.messages = messages.get();
  $scope.state = null;
  $scope.dropdown = dropdown;
  $scope.playSound = true;

  var question;

  $scope.$watch('state', function(value) {
    if (value === 'waiting') {
      // FIXME: send this information before the browser closes!
      $window.onbeforeunload = function() {
        timer.stop('waiting');
        mixpanel.track('quit without match', {
          waitTime: timer.getDuration('waiting')
        });
      };
    } else if (value === 'chatting') {
      $window.onbeforeunload = function() {
        return 'Leaving this page will end your conversation.';
      };
      $window.onunload = function() {
        // FIXME: send this information before the browser closes!
        timer.stop('chatting');
        mixpanel.track('chat ended', {
          quit: true,
          duration: timer.getDuration('chatting'),
          question: question,
          messagesSent: messages.stats.sent,
          messagesReceived: messages.stats.received
        });
      };
    } else {
      $window.onbeforeunload = null;
      $window.onunload = null;
    }
  });

  socket.on('error', function(error) {
    messages.add({
      type: 'system',
      important: true,
      template: error
    });
    $scope.state = 'error';
    mixpanel.track(error);
  });

  var getSchool = function(email) {
    var emailRegex = /[\w+\-.]+@(?:.+\.)*(.+)\.edu/i;
    var match = emailRegex.exec(email);
    if (match) {
      return match[1];
    } else {
      return null;
    }
  };

  socket.on('entrance', function(data) {
    var school = getSchool(data.email);
    if (school) {
      mixpanel.identify(data.email);
      mixpanel.people.set({
        "$email": data.email,
        school: school
      });
      mixpanel.people.increment('chats_joined');
      mixpanel.register({
        school: school
      });
      mixpanel.track('chat joined');
    }
  });

  socket.on('waiting', function() {
    messages.add({
      type: 'system',
      template: 'waiting'
    });
    $scope.state = 'waiting';

    timer.start('waiting');
  });

  socket.on('matched', function(data) {
    var question = data.question;
    partner.school = data.partnerSchool;
    messages.add({
      type: 'system',
      template: 'matched',
      question: question
    });
    $scope.state = 'chatting';
    timer.start('chatting');

    timer.stop('waiting');
    mixpanel.track('chat matched', {
      waitTime: timer.getDuration('waiting'),
      question: question,
      partnerSchool: partner.school
    });
    mixpanel.people.increment('chats_matched');
  });

  socket.on('chat message', function(data) {
    var name = data.self ? "You" : partner.name;
    messages.add({
      type: 'chat',
      isPartner: !data.self,
      time: (new Date()).toLocaleTimeString(),
      name: name,
      text: data.message
    });

    if (!dropdown.previouslyShown() &&
        messages.stats.sent >= DROPDOWN_THRESHOLD &&
        messages.stats.received >= DROPDOWN_THRESHOLD) {
      dropdown.show();
    }
  });

  socket.on('reveal', function(data) {
    partner.name = data.name;
    partner.email = data.email;
    partner.link = data.link;
    messages.add({
      type: 'system',
      template: 'partnerRevealed'
    });
    mixpanel.track('partner revealed', {
      messagesSent: messages.stats.sent,
      messagesReceived: messages.stats.received
    });
    mixpanel.people.increment('partners_revealed');
  });

  socket.on('finished', function(data) {
    messages.add({
      type: 'system',
      important: true,
      template: 'finished'
    });
    $scope.state = 'finished';

    timer.stop('chatting');
    mixpanel.track('chat ended', {
      quit: false,
      duration: timer.getDuration('chatting'),
      question: question,
      messagesSent: messages.stats.sent,
      messagesReceived: messages.stats.received
    });
  });

  socket.on('disconnect', function() {
    if ($scope.state !== 'finished') {
      $scope.state = 'reconnecting';
      messages.add({
        type: 'system',
        important: true,
        template: 'reconnecting'
      });
      mixpanel.track('reconnecting');
    }
  });

  socket.on('connect', function() {
    if ($scope.state === 'reconnecting') {
      socket.emit('resume session');
      $scope.state = 'chatting';
      messages.add({
        type: 'system',
        template: 'reconnected'
      });
    } else {
      socket.emit('new session');
    }
  });

  $scope.sendMessage = function(e) {
    if (e.keyCode == 13 && !e.shiftKey) {
      e.preventDefault();
      if ($scope.message.length > 0) {
        socket.emit('chat message', {
          message: $scope.message
        });
        $scope.message = '';
        prevMessageLength = 0;
        socket.emit('not typing');
        mixpanel.people.increment('chat_messages');
      }
    }
  };

  // Realtime typing
  var prevMessageLength = 0;
  $scope.updateTyping = function() {
    if (prevMessageLength === 0 && $scope.message.length > 0) {
      socket.emit('typing');
    } else if ($scope.message.length === 0) {
      socket.emit('not typing');
    }
    prevMessageLength = $scope.message.length;
  };

  socket.on('typing', function() {
    $scope.partnerTyping = true;
  });

  socket.on('not typing', function() {
    $scope.partnerTyping = false;
  });
});
