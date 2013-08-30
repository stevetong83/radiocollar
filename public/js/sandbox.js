// Generated by CoffeeScript 1.6.3
(function() {
  var CreatePlacesView, _ref, _ref1, _ref2, _ref3, _ref4, _ref5, _ref6, _ref7,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.server_url = '/api/v1';

  console.log('dont forget to change the @server_url to production.');

  Backbone.Model.idAttribute = "_id";

  window.Session = (function(_super) {
    __extends(Session, _super);

    function Session() {
      _ref = Session.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    Session.prototype.url = server_url + '/sessions';

    return Session;

  })(Backbone.Model);

  window.SessionView = (function(_super) {
    __extends(SessionView, _super);

    function SessionView() {
      this.proceed = __bind(this.proceed, this);
      _ref1 = SessionView.__super__.constructor.apply(this, arguments);
      return _ref1;
    }

    SessionView.prototype.el = $('#content');

    SessionView.prototype.initialize = function() {
      this.template = "<form id='sessionCreate'>\n<div><input type=\"text\" id=\"email\" placeholder=\"User ID\" tabindex=\"2\" name=\"userID\" maxlength=\"255\"></div>\n<div><input type=\"password\" placeholder=\"Password\" tabindex=\"3\" class=\"password hide\" id=\"password\" name=\"password\" maxlength=\"32\"></div>\n<div><a href=\"#\" id=\"go\" class=\"btn-wide\">Login now.</a></div></form>";
      this.model = new Session();
      return this.render();
    };

    SessionView.prototype.events = {
      "click #go": "authenticate"
    };

    SessionView.prototype.render = function() {
      return $(this.el).html(this.template);
    };

    SessionView.prototype.proceed = function() {
      localStorage.auth_token = this.model.get('authentication_token');
      return App.navigate('/main', {
        trigger: true
      });
    };

    SessionView.prototype.attempts = 0;

    SessionView.prototype.ohNo = function() {
      return $('#go').text("" + (++this.attempts) + " failed login attempts. Try again.");
    };

    SessionView.prototype.authenticate = function() {
      var _this = this;
      return this.model.save({
        email: $('#email').val(),
        password: $('#password').val()
      }, {
        success: (function() {
          return _this.proceed();
        }),
        error: (function() {
          return _this.ohNo();
        })
      });
    };

    return SessionView;

  })(Backbone.View);

  window.Place = (function(_super) {
    __extends(Place, _super);

    function Place() {
      _ref2 = Place.__super__.constructor.apply(this, arguments);
      return _ref2;
    }

    Place.prototype.idAttribute = "_id";

    Place.prototype.initialize = function() {
      this.set('lat', compass.lat);
      return this.set('long', compass.long);
    };

    Place.prototype.validate = function() {
      if (compass.error != null) {
        return alert(compass.error);
      }
      if (!((this.has('lat') != null) || (this.has('long') != null))) {
        return alert("Unable to fix GPS location.");
      }
      if (this.get('name') == null) {
        return alert("A name is required.");
      }
    };

    Place.prototype.urlRoot = server_url + '/places';

    return Place;

  })(Backbone.Model);

  window.Places = (function(_super) {
    __extends(Places, _super);

    function Places() {
      _ref3 = Places.__super__.constructor.apply(this, arguments);
      return _ref3;
    }

    Places.prototype.url = server_url + '/places';

    Places.prototype.model = Place;

    return Places;

  })(Backbone.Collection);

  window.PlaceView = (function(_super) {
    __extends(PlaceView, _super);

    function PlaceView() {
      this.erase = __bind(this.erase, this);
      this.render = __bind(this.render, this);
      _ref4 = PlaceView.__super__.constructor.apply(this, arguments);
      return _ref4;
    }

    PlaceView.prototype.tagName = 'li';

    PlaceView.prototype.initialize = function() {
      if (this.model) {
        this.model.view = this;
      }
      this.template = function() {
        return templayed('<a href="{{location_url}}">{{name}}</a><span class="destroy">[X]</span>')(this.model.attributes);
      };
      return this.render();
    };

    PlaceView.prototype.render = function() {
      this.$el.html(this.template());
      return this;
    };

    PlaceView.prototype.events = {
      "click .destroy": "erase"
    };

    PlaceView.prototype.erase = function() {
      return this.model.destroy({
        data: {
          authentication_token: localStorage.auth_token
        },
        processData: true
      });
    };

    return PlaceView;

  })(Backbone.View);

  window.PlacesView = (function(_super) {
    __extends(PlacesView, _super);

    function PlacesView() {
      this.render = __bind(this.render, this);
      _ref5 = PlacesView.__super__.constructor.apply(this, arguments);
      return _ref5;
    }

    PlacesView.prototype.tagName = 'ul';

    PlacesView.prototype.initialize = function() {
      var _this = this;
      this.collection = new Places();
      this.collection.on('add remove reset sort', (function() {
        return _this.render();
      }));
      return this.collection.fetch({
        data: {
          authentication_token: localStorage.auth_token
        },
        success: (function() {
          return _this.render();
        })
      });
    };

    PlacesView.prototype.events = {};

    PlacesView.prototype.render = function() {
      var place, view, _i, _len, _ref6;
      this.$el.empty();
      $('#content').empty();
      _ref6 = this.collection.models;
      for (_i = 0, _len = _ref6.length; _i < _len; _i++) {
        place = _ref6[_i];
        view = new PlaceView({
          model: place
        });
        view.$el.appendTo(this.$el);
      }
      return this.$el.appendTo('#content');
    };

    return PlacesView;

  })(Backbone.View);

  CreatePlacesView = (function(_super) {
    __extends(CreatePlacesView, _super);

    function CreatePlacesView() {
      this.createOnEnter = __bind(this.createOnEnter, this);
      _ref6 = CreatePlacesView.__super__.constructor.apply(this, arguments);
      return _ref6;
    }

    CreatePlacesView.prototype.initialize = function() {
      this.$el.html('<a href="/#logout">[Logout]</a><input id="new-place" placeholder="Name you waypoint">');
      return this.$el.appendTo('nav');
    };

    CreatePlacesView.prototype.events = {
      "keypress #new-place": "createOnEnter"
    };

    CreatePlacesView.prototype.createOnEnter = function(event) {
      if (event.keyCode === 13) {
        this.makePlace();
        return $('#new-place').val('');
      }
    };

    CreatePlacesView.prototype.makePlace = function() {
      var model;
      model = new Place();
      model.set({
        name: $('#new-place').val(),
        lat: compass.lat,
        long: compass.long
      });
      model.save({
        authentication_token: localStorage.auth_token
      });
      return this.collection.add(model);
    };

    return CreatePlacesView;

  })(Backbone.View);

  window.RadioCollarRouter = (function(_super) {
    __extends(RadioCollarRouter, _super);

    function RadioCollarRouter() {
      _ref7 = RadioCollarRouter.__super__.constructor.apply(this, arguments);
      return _ref7;
    }

    RadioCollarRouter.prototype.routes = {
      "": "home",
      "main": "main",
      "logout": "logout"
    };

    RadioCollarRouter.prototype.home = function() {
      if (localStorage.auth_token != null) {
        return App.navigate('/main', {
          trigger: true
        });
      } else {
        return window.sessionView = new SessionView;
      }
    };

    RadioCollarRouter.prototype.main = function() {
      if (localStorage.auth_token == null) {
        return App.navigate('/', {
          trigger: true
        });
      }
      $('#content').empty();
      window.placesView = new PlacesView;
      return new CreatePlacesView({
        collection: placesView.collection
      });
    };

    RadioCollarRouter.prototype.logout = function() {
      delete localStorage.auth_token;
      return App.navigate('/', {
        trigger: true
      });
    };

    return RadioCollarRouter;

  })(Backbone.Router);

  $(function() {
    window.App = new RadioCollarRouter();
    return Backbone.history.start();
  });

}).call(this);

/*
//@ sourceMappingURL=sandbox.map
*/
