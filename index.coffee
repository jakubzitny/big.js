GitHubApi = require 'github'
childProcess = require 'child-process-promise'

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

  # test
  repo = tops[0]
  exec("git clone #{repo.git_url} tmp/#{repo.id}")
  .then (res) ->
    console.log repo.full_name
    console.log res
    exec("cd tmp/ #{repo.id}; npm i")
    .then (res) ->
      console.log res
      return
    .fail (err) ->
      console.error 'ERROR: ', err
     .progress (childProcess) ->
      console.log 'childProcess.pid: ', childProcess.pid
    console.log '------------'
  .fail (err) ->
    console.error 'ERROR: ', err
  .progress (childProcess) ->
    console.log 'childProcess.pid: ', childProcess.pid

  # all
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
