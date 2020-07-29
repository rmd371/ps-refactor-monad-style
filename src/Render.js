const html = require("nanohtml");
//const raw = require('nanohtml/raw')
const nanomorph = require("nanomorph");

exports.rerender = fragment => {
  console.log('fragment', fragment)
  return nanomorph(
    app,
    //html`<div id="app">${raw(fragment)}</div>`
    html`<div id="app">${fragment}</div>`
    );
  }

exports.concatFragments = fragments => fragments.reduce((prev, curr) => html`${prev}${curr}`, html``);

exports.getDate = () => new Date();