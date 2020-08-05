const { main } = require('./output/Main');
const html = require("nanohtml");

// IMPURE
const app = document.getElementById("app");

main({clicks: 0, lastUpdated: new Date(), totalClicks: 0})();
