ace.define("ace/ext/statusbar",["require","exports","module","ace/lib/dom","ace/lib/lang"],function(e,t,n){var r=e("ace/lib/dom"),i=e("ace/lib/lang"),s=function(e,t){this.element=r.createElement("div"),this.element.className="ace_status-indicator",this.element.style.cssText="display: inline-block;",t.appendChild(this.element);var n=i.delayedCall(function(){this.updateStatus(e)}.bind(this));e.on("changeStatus",function(){n.schedule(100)}),e.on("changeSelection",function(){n.schedule(100)})};(function(){this.updateStatus=function(e){function n(e,n){e&&t.push(e,n||"|")}var t=[];e.$vimModeHandler?n(e.$vimModeHandler.getStatusText()):e.commands.recording&&n("REC");var r=e.selection.lead;n(r.row+":"+r.column," ");if(!e.selection.isEmpty()){var i=e.getSelectionRange();n("("+(i.end.row-i.start.row)+":"+(i.end.column-i.start.column)+")")}t.pop(),this.element.textContent=t.join("")}}).call(s.prototype),t.StatusBar=s})