childProcess = require 'child-process-promise'
GitHubApi = require 'github'
uuid = require 'node-uuid'
fs = require 'fs-promise'

exec = childProcess.exec

github = new GitHubApi(
  version: '3.0.0'
  debug: true
  protocol: 'https'
  host: 'api.github.com'
  timeout: 5000)

github.authenticate
  type: 'oauth'
  key: '2d504099f323ab60a4ad'
  secret: 'bfc397e7bc66808b7b82bc825695cd6741d8c896'

github.search.repos {
  sort: 'stars'
  q: 'language:JavaScript'
  language: 'javascript'
}, (err, res) ->
  tops = res.items #.map(function(item) {return item.git_url;})
  console.log 'Got ' + tops.length + ' repositories'

  # testing
  repo = tops[0]
  repoDir = "tmp/#{repo.name}_#{repo.id}"
  exec("mkdir -p #{repoDir}/github")
  .then (res) -> exec("git clone --bare #{repo.git_url} #{repoDir}/bare_repo")
  .then (res) -> exec("git clone #{repo.git_url} #{repoDir}/latest")
  .then (res) ->
    # format index.json
    indexJson = {
      corpus_release: "1.0", # TODO: db
      code: "./latest",
      site_specific_id: repo.name,
      git_bare_repo: "./bare_repo",
      name: repo.name,
      site: "github",
      repo: "github",
      on_disk_ver: "1.2",
      crawled_date: new Date().toISOString(),
      uuid: uuid.v4()
    }
    fs.writeFile("#{repoDir}/index.json", JSON.stringify(indexJson, null, 4))
  .then ->
    # info.json
    fs.writeFile("#{repoDir}/github/info.json", JSON.stringify(repo, null, 4))
  .fail (err) -> console.error 'ERROR:', err

  # real
  #tops.forEach (repo) ->
  #  exec("git clone #{repo.git_url} tmp/ #{repo.id}")
  #  .then (res) ->
  #    console.log repo.full_name
  #    console.log res
  #    exec("cd tmp/ #{repo.id}; npm i")
  #    .then (res) ->
  #      console.log res
  #      return
  #    .fail (err) ->
  #      console.error 'ERROR: ', err
  #     .progress (childProcess) ->
  #      console.log 'childProcess.pid: ', childProcess.pid
  #    console.log '------------'
  #  .fail (err) ->
  #    console.error 'ERROR: ', err
  #  .progress (childProcess) ->
  #    console.log 'childProcess.pid: ', childProcess.pid
