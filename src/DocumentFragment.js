const html = require("nanohtml");

exports.concatFragments = fragments => fragments.reduce((prev, curr) => html`${prev}${curr}`, html``);

exports.emptyHtml = html``