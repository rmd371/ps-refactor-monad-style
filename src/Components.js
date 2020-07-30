const html = require("nanohtml");

exports.header = html`<h1>World's best app</h1>`;

exports.contentHtml = someHtml =>
  html`
    <div id="content" class="content">
      ${someHtml}
    </div>
  `;

exports.refreshHtml = lastUpdated => onClick => html`
  <div>
    Last updated at ${lastUpdated.toLocaleString()}.
  </div>
  <button onclick=${onClick}>
    Click To Update
  </button>
`;
exports.headerHtml = title =>
  html`
    <header style="position: fixed; top: 0; left: 50%; margin-left: -50%;">
      ${title}
    </header>
  `;

exports.clickCounter = clicks => onClick => {
  console.log('onClick', onClick)
  return html`
    <div>
      You've clicked ${clicks} times
    </div>
    <button onclick=${onClick}>
      Click Me
   </button>
  `;
}

exports.decorations = html`
  <div class="decoration">
    insert decoration here
  </div>
`;

exports.unicorns = html` <span class="decoration"> 🦄🦄🦄🦄🦄🦄 </span> `;

exports.renderTotalClicks = totalClicks =>
  html`
    <div>Total clicks:</div>
    <div>${totalClicks}</div>
  `;

exports.refreshDebugHtml = lastUpdated => onClick => 
  html`
    <strong style="position: fixed; bottom: 0; width: 100vw;">
      ${lastUpdated}
      <button onclick=${onClick}>Debug Mode</button>
    </strong>
  `;

exports.emptyHtml = html``