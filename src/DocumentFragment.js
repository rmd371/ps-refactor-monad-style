const html = require("nanohtml");

exports.toString = fragment => html`${fragment}`;
exports.concatFragments = fragments => fragments.reduce((prev, curr) => html`${prev}${curr}`, html``);
exports.emptyHtml = html``