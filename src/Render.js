const html = require("nanohtml");
//const raw = require('nanohtml/raw')
const nanomorph = require("nanomorph");

exports.rerender = fragment => () => {
  console.log('fragment', fragment)
  return nanomorph(
    app,
    //html`<div id="app">${raw(fragment)}</div>`
    html`${fragment}`
    );
  }

exports.consoleLog = a => { console.log(a); return a; }