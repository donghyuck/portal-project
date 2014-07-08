/**
 *  Codrops Morphing Button
 */
(function($, undefined) {
	var codrops = window.codrops = window.codrops || {};
	codrops.ui = codrops.ui || {};
	var kendo = window.kendo, 
	Widget = kendo.ui.Widget,
	
	OPENING = "opening",
	OPEN = "open",
	OPENED = "opened",
	CLOSE = "close",
	CLOSING = "closing",
	CLOSED = "closed",
	REFRESH = "refresh",
	CLICK = "click";
	
	codrops.ui.MorphingButton = Widget.extend({
		init : function(element, options) {
			var that = this;
			Widget.fn.init.call(that, element, options);
			options = that.options;			
			element = that.element;
			that.refresh();
		},
		options : {
			name : "MorphingButton"
		},		
		events:[
		CLICK, OPENING, OPENED, OPEN, CLOSING, CLOSE, CLOSED
		],
		refresh: function(){
			var that = this;
			var renderTo = $(that.element);
			renderTo.on(CLICK, function(e){
				that._toggle();
			} );
			if( renderTo.find("button.btn-close").length > 0 )
				renderTo.find("button.btn-close").click(function(e){
					that._toggle();					
				});	
		},
		_toggle: function(){
			var that = this;
			var renderTo = $(that.element);
						
			if( that.isAnimating ) return false;
			
			if( that.expanded ) {
				that.trigger(CLOSING, {target: that});
			}else{
				renderTo.addClass("active");
				that.trigger(OPENING, {target: that});				
			}
			
			that.isAnimating = true;
			// set the left and top values of the contentEl (same like the button)
			var button = renderTo.children("button")
			var content = renderTo.find(".morph-content");
						
			var onEndTransitionFn = function( ev ) {
								
				if( ev.target !== this ) return false;
				if( kendo.support.transitions ) {
					if( that.expanded && ev.propertyName !== 'opacity' || !self.expanded && ev.propertyName !== 'width' && ev.propertyName !== 'height' && ev.propertyName !== 'left' && ev.propertyName !== 'top' ) {
						return false;
					}
				}				
				that.isAnimating = false;				
				// callback
				if( that.expanded ) {
					// remove class active (after closing)
					renderTo.removeClass("active");
					that.trigger(CLOSED, {target: that});	
				}
				else {
					that.trigger(OPENED, {target: that});	
				}
				that.expanded = !that.expanded;
			};
						
			if(kendo.support.transitions){
				content.one(kendo.support.transitions.event, onEndTransitionFn );				
			}else{
				onEndTransitionFn();				
			}
			var offset = button.offset();
			content.addClass("no-transition");
			content.css({	"left":"auto", "top":"auto"});
			setTimeout( function() { 
				content.css({	"left": offset.left + "px", "top": offset.top + "px"});		
				if( that.expanded ) {
					content.removeClass("no-transition");
					renderTo.removeClass("open");
				}else{
					setTimeout(function(){
						content.removeClass("no-transition");
						renderTo.addClass("open");
					});					
				}
			});			
		}
	});
	
	
})(jQuery);	