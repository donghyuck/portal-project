(function() {
  if (!String.prototype.endsWith) {

    /*
     * Determines whether a string ends with the specified suffix.
     * 
     * @param  {String} suffix
     * @return Boolean
     */
    String.prototype.endsWith = function(suffix) {
      return this.indexOf(suffix, this.length - suffix.length) !== -1;
    };
  }

  if (!String.prototype.trim) {

    /*
     * Removes whitespace from both sides of a string.
     * 
     * @return {String}
     */
    String.prototype.trim = function() {
      return this.replace(/^\s+|\s+$/g, '');
    };
  }

  if (!Array.prototype.indexOf) {

    /*
     * The indexOf() method returns the first index at which a given element can be found in the array, or -1 if it is not present.
     * 
     * @param  {Variant} searchElement
     * @param  {Integer} fromIndex
     * @return {Integer}
     */
    Array.prototype.indexOf = function(searchElement, fromIndex) {
      var i, length, _i;
      if (this === void 0 || this === null) {
        throw new TypeError('"this" is null or not defined');
      }
      length = this.length >>> 0;
      fromIndex = +fromIndex || 0;
      if (Math.abs(fromIndex) === Infinity) {
        fromIndex = 0;
      }
      if (fromIndex < 0) {
        fromIndex += length;
        if (fromIndex < 0) {
          fromIndex = 0;
        }
      }
      for (i = _i = fromIndex; fromIndex <= length ? _i < length : _i > length; i = fromIndex <= length ? ++_i : --_i) {
        if (this[i] === searchElement) {
          return i;
        }
      }
      return -1;
    };
  }

  if (!Function.prototype.bind) {
    Function.prototype.bind = function(oThis) {
      var aArgs, fBound, fNOP, fToBind;
      if (typeof this !== "function") {
        throw new TypeError("Function.prototype.bind - what is trying to be bound is not callable");
      }
      aArgs = Array.prototype.slice.call(arguments, 1);
      fToBind = this;
      fNOP = function() {};
      fBound = function() {
        return fToBind.apply((this instanceof fNOP && oThis ? this : oThis), aArgs.concat(Array.prototype.slice.call(arguments)));
      };
      fNOP.prototype = this.prototype;
      fBound.prototype = new fNOP();
      return fBound;
    };
  }

  if (!Object.keys) {
    Object.keys = (function() {
      'use strict';
      var dontEnums, hasDontEnumBug, hasOwnProperty;
      hasOwnProperty = Object.prototype.hasOwnProperty;
      hasDontEnumBug = {
        toString: null
      }.propertyIsEnumerable('toString') ? false : true;
      dontEnums = ['toString', 'toLocaleString', 'valueOf', 'hasOwnProperty', 'isPrototypeOf', 'propertyIsEnumerable', 'constructor'];
      return function(obj) {
        var dontEnum, prop, result, _i, _j, _len, _len1;
        if (typeof obj !== 'object' && (typeof obj !== 'function' || obj === null)) {
          throw new TypeError('Object.keys called on non-object');
        }
        result = [];
        for (_i = 0, _len = obj.length; _i < _len; _i++) {
          prop = obj[_i];
          if (hasOwnProperty.call(obj, prop)) {
            result.push(prop);
          }
        }
        if (hasDontEnumBug) {
          for (_j = 0, _len1 = dontEnums.length; _j < _len1; _j++) {
            dontEnum = dontEnums[_j];
            if (hasOwnProperty.call(obj, dontEnum)) {
              result.push(dontEnum);
            }
          }
        }
        return result;
      };
    }).call(this);
  }


  /*
   * Detect screen size.
   * 
   * @param  {jQuery Object} $ssw_point
   * @param  {jQuery Object} $tsw_point
   * @return {String}
   */

  window.getScreenSize = function($ssw_point, $tsw_point) {
    if ($ssw_point.is(':visible')) {
      return 'small';
    } else if ($tsw_point.is(':visible')) {
      return 'tablet';
    } else {
      return 'desktop';
    }
  };

  window.elHasClass = function(el, selector) {
    return (" " + el.className + " ").indexOf(" " + selector + " ") > -1;
  };

  window.elRemoveClass = function(el, selector) {
    return el.className = (" " + el.className + " ").replace(" " + selector + " ", ' ').trim();
  };

}).call(this);
;
(function() {
  var PixelAdminApp, SETTINGS_DEFAULTS;

  SETTINGS_DEFAULTS = {
    is_mobile: false,
    resize_delay: 400,
    stored_values_prefix: 'pa_',
    main_menu: {
      accordion: true,
      animation_speed: 250,
      store_state: true,
      store_state_key: 'mmstate',
      disable_animation_on: [],
      dropdown_close_delay: 300,
      detect_active: true,
      detect_active_predicate: function(href, url) {
        return href === url;
      }
    },
    consts: {
      COLORS: ['#71c73e', '#77b7c5', '#d54848', '#6c42e5', '#e8e64e', '#dd56e6', '#ecad3f', '#618b9d', '#b68b68', '#36a766', '#3156be', '#00b3ff', '#646464', '#a946e8', '#9d9d9d']
    }
  };


  /*
   * @class PixelAdminApp
   */

  PixelAdminApp = function() {
    this.init = [];
    this.plugins = {};
    this.settings = {};
    this.localStorageSupported = typeof window.Storage !== "undefined" ? true : false;
    return this;
  };


  /*
   * Start application. Method takes an array of initializers and a settings object(that overrides default settings).
   * 
   * @param  {Array} suffix
   * @param  {Object} settings
   * @return this
   */

  PixelAdminApp.prototype.start = function(init, settings) {
    if (init == null) {
      init = [];
    }
    if (settings == null) {
      settings = {};
    }
    
    /*
    window.onload = (function(_this) {
      return function() {
        var initilizer, _i, _len, _ref;
        $('html').addClass('pxajs');
        if (init.length > 0) {
          $.merge(_this.init, init);
        }
        _this.settings = $.extend(true, {}, SETTINGS_DEFAULTS, settings || {});
        _this.settings.is_mobile = /iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase());
        if (_this.settings.is_mobile) {
          if (FastClick) {
            FastClick.attach(document.body);
          }
        }
        _ref = _this.init;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          initilizer = _ref[_i];
          $.proxy(initilizer, _this)();
        }
        $(window).trigger("pa.loaded");
        return $(window).resize();
      };
    })(this);
    
    */
    var _this = this;
				var initilizer, _i, _len, _ref;
        $('html').addClass('pxajs');
        if (init.length > 0) {
          $.merge(_this.init, init);
        }
        _this.settings = $.extend(true, {}, SETTINGS_DEFAULTS, settings || {});
        _this.settings.is_mobile = /iphone|ipad|ipod|android|blackberry|mini|windows\sce|palm/i.test(navigator.userAgent.toLowerCase());
        if (_this.settings.is_mobile) {
          if (FastClick) {
            FastClick.attach(document.body);
          }
        }
        _ref = _this.init;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          initilizer = _ref[_i];
          $.proxy(initilizer, _this)();
        }
        $(window).trigger("pa.loaded");
        $(window).resize();
      
    return this;
  };


  /*
   * Add initializer to the stack.
   * 
   * @param  {Function} callback
   */

  PixelAdminApp.prototype.addInitializer = function(callback) {
    return this.init.push(callback);
  };


  /*
   * Initialize plugin and add it to the plugins list.
   * 
   * @param  {String} plugin_name
   * @param  {Instance} plugin
   */

  PixelAdminApp.prototype.initPlugin = function(plugin_name, plugin) {
    this.plugins[plugin_name] = plugin;
    if (plugin.init) {
      return plugin.init();
    }
  };


  /*
   * Save value in the localStorage/Cookies.
   * 
   * @param  {String}  key
   * @param  {String}  value
   * @param  {Boolean} use_cookies
   */

  PixelAdminApp.prototype.storeValue = function(key, value, use_cookies) {
    var e;
    if (use_cookies == null) {
      use_cookies = false;
    }
    if (this.localStorageSupported && !use_cookies) {
      try {
        window.localStorage.setItem(this.settings.stored_values_prefix + key, value);
        return;
      } catch (_error) {
        e = _error;
        1;
      }
    }
    return document.cookie = this.settings.stored_values_prefix + key + '=' + escape(value);
  };


  /*
   * Save key/value pairs in the localStorage/Cookies.
   * 
   * @param  {Object} pairs
   * @param  {Boolean} use_cookies
   */

  PixelAdminApp.prototype.storeValues = function(pairs, use_cookies) {
    var e, key, value, _results;
    if (use_cookies == null) {
      use_cookies = false;
    }
    if (this.localStorageSupported && !use_cookies) {
      try {
        for (key in pairs) {
          value = pairs[key];
          window.localStorage.setItem(this.settings.stored_values_prefix + key, value);
        }
        return;
      } catch (_error) {
        e = _error;
        1;
      }
    }
    _results = [];
    for (key in pairs) {
      value = pairs[key];
      _results.push(document.cookie = this.settings.stored_values_prefix + key + '=' + escape(value));
    }
    return _results;
  };


  /*
   * Get value from the localStorage/Cookies.
   * 
   * @param  {String} key
   * @param  {Boolean} use_cookies
   */

  PixelAdminApp.prototype.getStoredValue = function(key, use_cookies, deflt) {
    var cookie, cookies, e, k, pos, r, v, _i, _len;
    if (use_cookies == null) {
      use_cookies = false;
    }
    if (deflt == null) {
      deflt = null;
    }
    if (this.localStorageSupported && !use_cookies) {
      try {
        r = window.localStorage.getItem(this.settings.stored_values_prefix + key);
        return (r ? r : deflt);
      } catch (_error) {
        e = _error;
        1;
      }
    }
    cookies = document.cookie.split(';');
    for (_i = 0, _len = cookies.length; _i < _len; _i++) {
      cookie = cookies[_i];
      pos = cookie.indexOf('=');
      k = cookie.substr(0, pos).replace(/^\s+|\s+$/g, '');
      v = cookie.substr(pos + 1).replace(/^\s+|\s+$/g, '');
      if (k === (this.settings.stored_values_prefix + key)) {
        return v;
      }
    }
    return deflt;
  };


  /*
   * Get values from the localStorage/Cookies.
   * 
   * @param  {Array} keys
   * @param  {Boolean} use_cookies
   */

  PixelAdminApp.prototype.getStoredValues = function(keys, use_cookies, deflt) {
    var cookie, cookies, e, k, key, pos, r, result, v, _i, _j, _k, _len, _len1, _len2;
    if (use_cookies == null) {
      use_cookies = false;
    }
    if (deflt == null) {
      deflt = null;
    }
    result = {};
    for (_i = 0, _len = keys.length; _i < _len; _i++) {
      key = keys[_i];
      result[key] = deflt;
    }
    if (this.localStorageSupported && !use_cookies) {
      try {
        for (_j = 0, _len1 = keys.length; _j < _len1; _j++) {
          key = keys[_j];
          r = window.localStorage.getItem(this.settings.stored_values_prefix + key);
          if (r) {
            result[key] = r;
          }
        }
        return result;
      } catch (_error) {
        e = _error;
        1;
      }
    }
    cookies = document.cookie.split(';');
    for (_k = 0, _len2 = cookies.length; _k < _len2; _k++) {
      cookie = cookies[_k];
      pos = cookie.indexOf('=');
      k = cookie.substr(0, pos).replace(/^\s+|\s+$/g, '');
      v = cookie.substr(pos + 1).replace(/^\s+|\s+$/g, '');
      if (k === (this.settings.stored_values_prefix + key)) {
        result[key] = v;
      }
    }
    return result;
  };

  PixelAdminApp.Constructor = PixelAdminApp;

  window.PixelAdmin = new PixelAdminApp;

}).call(this);
;
(function() {
  var delayedResizeHandler;

  delayedResizeHandler = function(callback) {
    var resizeTimer;
    resizeTimer = null;
    return function() {
      if (resizeTimer) {
        clearTimeout(resizeTimer);
      }
      return resizeTimer = setTimeout(function() {
        resizeTimer = null;
        return callback.call(this);
      }, PixelAdmin.settings.resize_delay);
    };
  };

  PixelAdmin.addInitializer(function() {
    var $ssw_point, $tsw_point, $window, _last_screen;
    _last_screen = null;
    $window = $(window);
    $ssw_point = $('<div id="small-screen-width-point" style="position:absolute;top:-10000px;width:10px;height:10px;background:#fff;"></div>');
    $tsw_point = $('<div id="tablet-screen-width-point" style="position:absolute;top:-10000px;width:10px;height:10px;background:#fff;"></div>');
    $('body').append($ssw_point).append($tsw_point);
    return $window.on('resize', delayedResizeHandler(function() {
      $window.trigger("pa.resize");
      if ($ssw_point.is(':visible')) {
        if (_last_screen !== 'small') {
          $window.trigger("pa.screen.small");
        }
        return _last_screen = 'small';
      } else if ($tsw_point.is(':visible')) {
        if (_last_screen !== 'tablet') {
          $window.trigger("pa.screen.tablet");
        }
        return _last_screen = 'tablet';
      } else {
        if (_last_screen !== 'desktop') {
          $window.trigger("pa.screen.desktop");
        }
        return _last_screen = 'desktop';
      }
    }));
  });

}).call(this);
;









/*
 * Class that provides the top navbar functionality.
 *
 * @class MainNavbar
 */

(function() {
  PixelAdmin.MainNavbar = function() {
    this._scroller = false;
    this._wheight = null;
    this.scroll_pos = 0;
    return this;
  };


  /*
   * Initialize plugin.
   */

  PixelAdmin.MainNavbar.prototype.init = function() {
    var is_mobile;
    this.$navbar = $('#main-navbar');
    this.$header = this.$navbar.find('.navbar-header');
    this.$toggle = this.$navbar.find('.navbar-toggle:first');
    this.$collapse = $('#main-navbar-collapse');
    this.$collapse_div = this.$collapse.find('> div');
    is_mobile = false;
    $(window).on('pa.screen.small pa.screen.tablet', (function(_this) {
      return function() {
        if (_this.$navbar.css('position') === 'fixed') {
          _this._setupScroller();
        }
        return is_mobile = true;
      };
    })(this)).on('pa.screen.desktop', (function(_this) {
      return function() {
        _this._removeScroller();
        return is_mobile = false;
      };
    })(this));
    return this.$navbar.on('click', '.nav-icon-btn.dropdown > .dropdown-toggle', function(e) {
      if (is_mobile) {
        e.preventDefault();
        e.stopPropagation();
        document.location.href = $(this).attr('href');
        return false;
      }
    });
  };


  /*
   * Attach scroller to navbar collapse.
   */

  PixelAdmin.MainNavbar.prototype._setupScroller = function() {
    if (this._scroller) {
      return;
    }
    this._scroller = true;
    this.$collapse_div.pixelSlimScroll({});
    this.$navbar.on('shown.bs.collapse.mn_collapse', $.proxy(((function(_this) {
      return function() {
        _this._updateCollapseHeight();
        return _this._watchWindowHeight();
      };
    })(this)), this)).on('hidden.bs.collapse.mn_collapse', $.proxy(((function(_this) {
      return function() {
        _this._wheight = null;
        return _this.$collapse_div.pixelSlimScroll({
          scrollTo: '0px'
        });
      };
    })(this)), this)).on('shown.bs.dropdown.mn_collapse', $.proxy(this._updateCollapseHeight, this)).on('hidden.bs.dropdown.mn_collapse', $.proxy(this._updateCollapseHeight, this));
    return this._updateCollapseHeight();
  };


  /*
   * Detach scroller from navbar collapse.
   */

  PixelAdmin.MainNavbar.prototype._removeScroller = function() {
    if (!this._scroller) {
      return;
    }
    this._wheight = null;
    this._scroller = false;
    this.$collapse_div.pixelSlimScroll({
      destroy: 'destroy'
    });
    this.$navbar.off('shown.bs.collapse.mn_collapse');
    this.$navbar.off('hidden.bs.collapse.mn_collapse');
    this.$navbar.off('shown.bs.dropdown.mn_collapse');
    this.$navbar.off('hidden.bs.dropdown.mn_collapse');
    return this.$collapse.attr('style', '');
  };


  /*
   * Update navbar collapse height.
   */

  PixelAdmin.MainNavbar.prototype._updateCollapseHeight = function() {
    var h_height, scrollTop, w_height;
    if (!this._scroller) {
      return;
    }
    w_height = $(window).innerHeight();
    h_height = this.$header.outerHeight();
    scrollTop = this.$collapse_div.scrollTop();
    if ((h_height + this.$collapse_div.css({
      'max-height': 'none'
    }).outerHeight()) > w_height) {
      this.$collapse_div.css({
        'max-height': w_height - h_height
      });
    } else {
      this.$collapse_div.css({
        'max-height': 'none'
      });
    }
    return this.$collapse_div.pixelSlimScroll({
      scrollTo: scrollTop + 'px'
    });
  };


  /*
   * Detecting a change of the window height.
   */

  PixelAdmin.MainNavbar.prototype._watchWindowHeight = function() {
    var checkWindowInnerHeight;
    this._wheight = $(window).innerHeight();
    checkWindowInnerHeight = (function(_this) {
      return function() {
        if (_this._wheight === null) {
          return;
        }
        if (_this._wheight !== $(window).innerHeight()) {
          _this._updateCollapseHeight();
        }
        _this._wheight = $(window).innerHeight();
        return setTimeout(checkWindowInnerHeight, 100);
      };
    })(this);
    return window.setTimeout(checkWindowInnerHeight, 100);
  };

  PixelAdmin.MainNavbar.Constructor = PixelAdmin.MainNavbar;

  PixelAdmin.addInitializer(function() {
    return PixelAdmin.initPlugin('main_navbar', new PixelAdmin.MainNavbar);
  });

}).call(this);
;

/*
 * Class that provides the main menu functionality.
 *
 * @class MainMenu
 */

(function() {
  PixelAdmin.MainMenu = function() {
    this._screen = null;
    this._last_screen = null;
    this._animate = false;
    this._close_timer = null;
    this._dropdown_li = null;
    this._dropdown = null;
    return this;
  };


  /*
   * Initialize plugin.
   */

  PixelAdmin.MainMenu.prototype.init = function() {
    var self, state;
    this.$menu = $('#main-menu');
    if (!this.$menu.length) {
      return;
    }
    this.$body = $('body');
    this.menu = this.$menu[0];
    this.$ssw_point = $('#small-screen-width-point');
    this.$tsw_point = $('#tablet-screen-width-point');
    self = this;
    if (PixelAdmin.settings.main_menu.store_state) {
      state = this._getMenuState();
      document.body.className += ' disable-mm-animation';
      if (state !== null) {
        this.$body[state === 'collapsed' ? 'addClass' : 'removeClass']('mmc');
      }
      setTimeout((function(_this) {
        return function() {
          return elRemoveClass(document.body, 'disable-mm-animation');
        };
      })(this), 20);
    }
    this.setupAnimation();
    $(window).on('resize.pa.mm', $.proxy(this.onResize, this));
    this.onResize();
    this.$menu.find('.navigation > .mm-dropdown').addClass('mm-dropdown-root');
    if (PixelAdmin.settings.main_menu.detect_active) {
      this.detectActiveItem();
    }
    if ($.support.transition) {
      this.$menu.on('transitionend webkitTransitionEnd oTransitionEnd MSTransitionEnd', $.proxy(this._onAnimationEnd, this));
    }
    $('#main-menu-toggle').on('click', $.proxy(this.toggle, this));
    $('#main-menu-inner').slimScroll({
      height: '100%'
    }).on('slimscrolling', (function(_this) {
      return function() {
        return _this.closeCurrentDropdown(true);
      };
    })(this));
    this.$menu.on('click', '.mm-dropdown > a', function() {
      var li;
      li = this.parentNode;
      if (elHasClass(li, 'mm-dropdown-root') && self._collapsed()) {
        if (elHasClass(li, 'mmc-dropdown-open')) {
          if (elHasClass(li, 'freeze')) {
            self.closeCurrentDropdown(true);
          } else {
            self.freezeDropdown(li);
          }
        } else {
          self.openDropdown(li, true);
        }
      } else {
        self.toggleSubmenu(li);
      }
      return false;
    });
    this.$menu.find('.navigation').on('mouseenter.pa.mm-dropdown', '.mm-dropdown-root', function() {
      self.clearCloseTimer();
      if (self._dropdown_li === this) {
        return;
      }
      if (self._collapsed() && (!self._dropdown_li || !elHasClass(self._dropdown_li, 'freeze'))) {
        return self.openDropdown(this);
      }
    }).on('mouseleave.pa.mm-dropdown', '.mm-dropdown-root', function() {
      return self._close_timer = setTimeout(function() {
        return self.closeCurrentDropdown();
      }, PixelAdmin.settings.main_menu.dropdown_close_delay);
    });
    return this;
  };

  PixelAdmin.MainMenu.prototype._collapsed = function() {
    return (this._screen === 'desktop' && elHasClass(document.body, 'mmc')) || (this._screen !== 'desktop' && !elHasClass(document.body, 'mme'));
  };

  PixelAdmin.MainMenu.prototype.onResize = function() {
    this._screen = getScreenSize(this.$ssw_point, this.$tsw_point);
    this._animate = PixelAdmin.settings.main_menu.disable_animation_on.indexOf(screen) === -1;
    if (this._dropdown_li) {
      this.closeCurrentDropdown(true);
    }
    if ((this._screen === 'small' && this._last_screen !== this._screen) || (this._screen === 'tablet' && this._last_screen === 'small')) {
      document.body.className += ' disable-mm-animation';
      setTimeout((function(_this) {
        return function() {
          return elRemoveClass(document.body, 'disable-mm-animation');
        };
      })(this), 20);
    }
    return this._last_screen = this._screen;
  };

  PixelAdmin.MainMenu.prototype.clearCloseTimer = function() {
    if (this._close_timer) {
      clearTimeout(this._close_timer);
      return this._close_timer = null;
    }
  };

  PixelAdmin.MainMenu.prototype._onAnimationEnd = function(e) {
    if (this._screen !== 'desktop' || e.target.id !== 'main-menu') {
      return;
    }
    return $(window).trigger('resize');
  };

  PixelAdmin.MainMenu.prototype.toggle = function() {
    var cls, collapse;
    cls = this._screen === 'small' || this._screen === 'tablet' ? 'mme' : 'mmc';
    if (elHasClass(document.body, cls)) {
      elRemoveClass(document.body, cls);
    } else {
      document.body.className += ' ' + cls;
    }
    if (cls === 'mmc') {
      if (PixelAdmin.settings.main_menu.store_state) {
        this._storeMenuState(elHasClass(document.body, 'mmc'));
      }
      if (!$.support.transition) {
        return $(window).trigger('resize');
      }
    } else {
      collapse = document.getElementById('');
      $('#main-navbar-collapse').stop().removeClass('in collapsing').addClass('collapse')[0].style.height = '0px';
      return $('#main-navbar .navbar-toggle').addClass('collapsed');
    }
  };

  PixelAdmin.MainMenu.prototype.toggleSubmenu = function(li) {
    this[elHasClass(li, 'open') ? 'collapseSubmenu' : 'expandSubmenu'](li);
    return false;
  };

  PixelAdmin.MainMenu.prototype.collapseSubmenu = function(li) {
    var $li, $ul;
    $li = $(li);
    $ul = $li.find('> ul');
    if (this._animate) {
      $ul.animate({
        height: 0
      }, PixelAdmin.settings.main_menu.animation_speed, (function(_this) {
        return function() {
          elRemoveClass(li, 'open');
          $ul.attr('style', '');
          return $li.find('.mm-dropdown.open').removeClass('open').find('> ul').attr('style', '');
        };
      })(this));
    } else {
      elRemoveClass(li, 'open');
    }
    return false;
  };

  PixelAdmin.MainMenu.prototype.expandSubmenu = function(li) {
    var $li, $ul, h, ul;
    $li = $(li);
    if (PixelAdmin.settings.main_menu.accordion) {
      this.collapseAllSubmenus(li);
    }
    if (this._animate) {
      $ul = $li.find('> ul');
      ul = $ul[0];
      ul.className += ' get-height';
      h = $ul.height();
      elRemoveClass(ul, 'get-height');
      ul.style.display = 'block';
      ul.style.height = '0px';
      li.className += ' open';
      return $ul.animate({
        height: h
      }, PixelAdmin.settings.main_menu.animation_speed, (function(_this) {
        return function() {
          return $ul.attr('style', '');
        };
      })(this));
    } else {
      return li.className += ' open';
    }
  };

  PixelAdmin.MainMenu.prototype.collapseAllSubmenus = function(li) {
    var self;
    self = this;
    return $(li).parent().find('> .mm-dropdown.open').each(function() {
      return self.collapseSubmenu(this);
    });
  };

  PixelAdmin.MainMenu.prototype.openDropdown = function(li, freeze) {
    var $li, $title, $ul, $wrapper, max_height, min_height, title_h, top, ul, w_height, wrapper;
    if (freeze == null) {
      freeze = false;
    }
    if (this._dropdown_li) {
      this.closeCurrentDropdown(freeze);
    }
    $li = $(li);
    $ul = $li.find('> ul');
    ul = $ul[0];
    this._dropdown_li = li;
    this._dropdown = ul;
    $title = $ul.find('> .mmc-title');
    if (!$title.length) {
      $title = $('<div class="mmc-title"></div>').text($li.find('> a > .mm-text').text());
      ul.insertBefore($title[0], ul.firstChild);
    }
    li.className += ' mmc-dropdown-open';
    ul.className += ' mmc-dropdown-open-ul';
    top = $li.position().top;
    if (elHasClass(document.body, 'main-menu-fixed')) {
      $wrapper = $ul.find('.mmc-wrapper');
      if (!$wrapper.length) {
        wrapper = document.createElement('div');
        wrapper.className = 'mmc-wrapper';
        wrapper.style.overflow = 'hidden';
        wrapper.style.position = 'relative';
        $wrapper = $(wrapper);
        $wrapper.append($ul.find('> li'));
        ul.appendChild(wrapper);
      }
      w_height = $(window).innerHeight();
      title_h = $title.outerHeight();
      min_height = title_h + $ul.find('.mmc-wrapper > li').first().outerHeight() * 3;
      if ((top + min_height) > w_height) {
        max_height = top - $('#main-navbar').outerHeight();
        ul.className += ' top';
        ul.style.bottom = (w_height - top - title_h) + 'px';
      } else {
        max_height = w_height - top - title_h;
        ul.style.top = top + 'px';
      }
      if (elHasClass(ul, 'top')) {
        ul.appendChild($title[0]);
      } else {
        ul.insertBefore($title[0], ul.firstChild);
      }
      li.className += ' slimscroll-attached';
      $wrapper[0].style.maxHeight = (max_height - 10) + 'px';
      $wrapper.pixelSlimScroll({});
    } else {
      ul.style.top = top + 'px';
    }
    if (freeze) {
      this.freezeDropdown(li);
    }
    if (!freeze) {
      $ul.on('mouseenter', (function(_this) {
        return function() {
          return _this.clearCloseTimer();
        };
      })(this)).on('mouseleave', (function(_this) {
        return function() {
          return _this._close_timer = setTimeout(function() {
            return _this.closeCurrentDropdown();
          }, PixelAdmin.settings.main_menu.dropdown_close_delay);
        };
      })(this));
      this;
    }
    return this.menu.appendChild(ul);
  };

  PixelAdmin.MainMenu.prototype.closeCurrentDropdown = function(force) {
    var $dropdown, $wrapper;
    if (force == null) {
      force = false;
    }
    if (!this._dropdown_li || (elHasClass(this._dropdown_li, 'freeze') && !force)) {
      return;
    }
    this.clearCloseTimer();
    $dropdown = $(this._dropdown);
    if (elHasClass(this._dropdown_li, 'slimscroll-attached')) {
      elRemoveClass(this._dropdown_li, 'slimscroll-attached');
      $wrapper = $dropdown.find('.mmc-wrapper');
      $wrapper.pixelSlimScroll({
        destroy: 'destroy'
      }).find('> *').appendTo($dropdown);
      $wrapper.remove();
    }
    this._dropdown_li.appendChild(this._dropdown);
    elRemoveClass(this._dropdown, 'mmc-dropdown-open-ul');
    elRemoveClass(this._dropdown, 'top');
    elRemoveClass(this._dropdown_li, 'mmc-dropdown-open');
    elRemoveClass(this._dropdown_li, 'freeze');
    $(this._dropdown_li).attr('style', '');
    $dropdown.attr('style', '').off('mouseenter').off('mouseleave');
    this._dropdown = null;
    return this._dropdown_li = null;
  };

  PixelAdmin.MainMenu.prototype.freezeDropdown = function(li) {
    return li.className += ' freeze';
  };

  PixelAdmin.MainMenu.prototype.setupAnimation = function() {
    var $mm, $mm_nav, d_body, dsbl_animation_on;
    d_body = document.body;
    dsbl_animation_on = PixelAdmin.settings.main_menu.disable_animation_on;
    d_body.className += ' dont-animate-mm-content';
    $mm = $('#main-menu');
    $mm_nav = $mm.find('.navigation');
    $mm_nav.find('> .mm-dropdown > ul').addClass('mmc-dropdown-delay animated');
    $mm_nav.find('> li > a > .mm-text').addClass('mmc-dropdown-delay animated fadeIn');
    $mm.find('.menu-content').addClass('animated fadeIn');
    if (elHasClass(d_body, 'main-menu-right') || (elHasClass(d_body, 'right-to-left') && !elHasClass(d_body, 'main-menu-right'))) {
      $mm_nav.find('> .mm-dropdown > ul').addClass('fadeInRight');
    } else {
      $mm_nav.find('> .mm-dropdown > ul').addClass('fadeInLeft');
    }
    d_body.className += dsbl_animation_on.indexOf('small') === -1 ? ' animate-mm-sm' : ' dont-animate-mm-content-sm';
    d_body.className += dsbl_animation_on.indexOf('tablet') === -1 ? ' animate-mm-md' : ' dont-animate-mm-content-md';
    d_body.className += dsbl_animation_on.indexOf('desktop') === -1 ? ' animate-mm-lg' : ' dont-animate-mm-content-lg';
    return window.setTimeout(function() {
      return elRemoveClass(d_body, 'dont-animate-mm-content');
    }, 500);
  };

  PixelAdmin.MainMenu.prototype.detectActiveItem = function() {
    var a, bubble, links, nav, predicate, url, _i, _len, _results;
    url = (document.location + '').replace(/\#.*?$/, '');
    predicate = PixelAdmin.settings.main_menu.detect_active_predicate;
    nav = $('#main-menu .navigation');
    nav.find('li').removeClass('open active');
    links = nav[0].getElementsByTagName('a');
    bubble = (function(_this) {
      return function(li) {
        li.className += ' active';
        if (!elHasClass(li.parentNode, 'navigation')) {
          li = li.parentNode.parentNode;
          li.className += ' open';
          return bubble(li);
        }
      };
    })(this);
    _results = [];
    for (_i = 0, _len = links.length; _i < _len; _i++) {
      a = links[_i];
      if (a.href.indexOf('#') === -1 && predicate(a.href, url)) {
        bubble(a.parentNode);
        break;
      } else {
        _results.push(void 0);
      }
    }
    return _results;
  };


  /*
   * Load menu state.
   */

  PixelAdmin.MainMenu.prototype._getMenuState = function() {
    return PixelAdmin.getStoredValue(PixelAdmin.settings.main_menu.store_state_key, null);
  };


  /*
   * Store menu state.
   */

  PixelAdmin.MainMenu.prototype._storeMenuState = function(is_collapsed) {
    if (!PixelAdmin.settings.main_menu.store_state) {
      return;
    }
    return PixelAdmin.storeValue(PixelAdmin.settings.main_menu.store_state_key, is_collapsed ? 'collapsed' : 'expanded');
  };

  PixelAdmin.MainMenu.Constructor = PixelAdmin.MainMenu;

  PixelAdmin.addInitializer(function() {
    return PixelAdmin.initPlugin('main_menu', new PixelAdmin.MainMenu);
  });

}).call(this);
;