(window.webpackJsonp=window.webpackJsonp||[]).push([[10],{581:function(t,e,n){"use strict";n.r(e),n.d(e,"default",function(){return y});var r=n(0),o=n.n(r),i=n(57),c=n.n(i),u=n(283);function a(t){return(a="function"==typeof Symbol&&"symbol"==typeof Symbol.iterator?function(t){return typeof t}:function(t){return t&&"function"==typeof Symbol&&t.constructor===Symbol&&t!==Symbol.prototype?"symbol":typeof t})(t)}function s(t,e){for(var n=0;n<e.length;n++){var r=e[n];r.enumerable=r.enumerable||!1,r.configurable=!0,"value"in r&&(r.writable=!0),Object.defineProperty(t,r.key,r)}}function p(t,e){return!e||"object"!==a(e)&&"function"!=typeof e?function(t){if(void 0===t)throw new ReferenceError("this hasn't been initialised - super() hasn't been called");return t}(t):e}function f(t){return(f=Object.setPrototypeOf?Object.getPrototypeOf:function(t){return t.__proto__||Object.getPrototypeOf(t)})(t)}function l(t,e){return(l=Object.setPrototypeOf||function(t,e){return t.__proto__=e,t})(t,e)}var y=function(t){function e(){var t;return function(t,e){if(!(t instanceof e))throw new TypeError("Cannot call a class as a function")}(this,e),(t=p(this,f(e).call(this))).state={currentPageIndex:0},t}return function(t,e){if("function"!=typeof e&&null!==e)throw new TypeError("Super expression must either be null or a function");t.prototype=Object.create(e&&e.prototype,{constructor:{value:t,writable:!0,configurable:!0}}),e&&l(t,e)}(e,o.a.Component),function(t,e,n){e&&s(t.prototype,e),n&&s(t,n)}(e,[{key:"cyclePage",value:function(){var t=this.state.currentPageIndex+1;this.state.currentPageIndex===this.props.pages.length-1&&(t=0),this.setState({currentPageIndex:t}),null==this.props.pages[t].name?this.props.history.push(this.props.pages[t].url):this.props.history.push("/"+this.props.pages[t].name.replace(" ","-"))}},{key:"render",value:function(){return o.a.createElement(c.a,{timeout:1e3*this.props.cyclePagesInterval,enabled:this.props.cyclePages,callback:this.cyclePage.bind(this)})}}]),e}();y=Object(u.a)(y)}}]);
//# sourceMappingURL=ud-page-cycler.189099de3849a15af466.bundle.map