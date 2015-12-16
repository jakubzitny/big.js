var GitHubApi = require("github");
 
var github = new GitHubApi({
    // required 
    version: "3.0.0",
    // optional 
    debug: true,
    protocol: "https",
    host: "api.github.com",
    timeout: 5000,
});

github.authenticate({
    type: "oauth",
    key: "2d504099f323ab60a4ad",
    secret: "bfc397e7bc66808b7b82bc825695cd6741d8c896"
})

github.search.repos({
  sort: "stars",
  q: "language:JavaScript",
  language: "javascript"
}, function(err, res) {
    console.log(res.items.map(function(item) {return item.full_name;}));
});
