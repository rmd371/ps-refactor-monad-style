const { main } = require('./output/Main');
const html = require("nanohtml");
const nanomorph = require("nanomorph");

// IMPURE
const app = document.getElementById("app");

const rerender = fragment => () => {
    console.log('fragment', fragment)
    return nanomorph(
      app,
      //html`<div id="app">${raw(fragment)}</div>`
      html`${fragment}`
      );
    }

main(rerender)({clicks: 0, lastUpdated: new Date(), totalClicks: 0})();
