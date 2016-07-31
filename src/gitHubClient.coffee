GitHubApi = require 'github'
request = require 'request'


class GitHubClient

  DEBUG: false

  API_KEY: '2d504099f323ab60a4ad'
  API_SECRET: 'bfc397e7bc66808b7b82bc825695cd6741d8c896'

  jsConfig: (page = 1) ->
    sort: 'stars'
    q: 'language:JavaScript'
    language: 'javascript'
    per_page: 100
    page: page

  constructor: ->
    @gitHubApi = new GitHubApi
      version: '3.0.0'
      debug: @DEBUG
      protocol: 'https'
      host: 'api.github.com'
      timeout: 5000

    @authenticate()

  authenticate: ->
    @gitHubApi.authenticate
      type: 'oauth'
      key: @API_KEY
      secret: @API_SECRET

  search: (onSearch, searchConfig) ->
    promisePool = []

    [1..10].forEach (i) =>
      p = new Promise (resolve, reject) =>
        callback = (err, res) => # TODO: handle error
          if err
            console.log(err)
            reject(err)
          else if res?.items
            tops = res.items
            console.log "Got #{tops.length} repositories"
            onSearch(tops)
            console.log(i, " hundred")
            resolve()
          else
            console.log("wtf")
            reject("wtf")

        searchConfig = @jsConfig(i)

        @gitHubApi.search.repos(searchConfig, callback)

      promisePool.push(p)

    Promise.all(promisePool)
    .then (x) ->
      console.log("done...")
      console.log(x)
    .catch (e) ->
      console.log("error...")
      console.log(e)

  isNodeRepo: (repo, cb) ->
    # console.log(@gitHubApi.authorization.getAll())
    # packageJsonApiLocation =
    #   "https://api.github.com/repos/#{repo.owner.login}/#{repo.name}/contents/" +
    #   "package.json?access_token"
    # args = headers: "Content-Type": "application/json"
    # requestOptions =
    #   url: packageJsonApiLocation
    #   headers: null
    #
    # request packageJsonApiLocation, (err, res, data) ->
    #   #console.log(res, data)

    true

  generalCall: (section, callName, repo, cb) ->
    sectionCall = @gitHubApi[section]
    apiCall = sectionCall[callName]
    #console.log(callName)

    callback = (err, res) ->
      if err
        # TODO: handle errors better
        console.error "Error (#{section}/#{callName})", err
      cb(res)

    msg =
      user: repo.owner.login
      owner: repo.owner.login # NOTE: for listReleases
      repo: repo.name

    apiCall(msg, callback)

  reposCall: (callName, repo, cb) ->
    @generalCall('repos', callName, repo, cb)

  issuesCall: (callName, repo, cb) ->
    @generalCall('issues', callName, repo, cb)

  contributors: (repo, cb) ->
    @reposCall('getContributors', repo, cb)

  languages: (repo, cb) ->
    @reposCall('getLanguages', repo, cb)

  forks: (repo, cb) ->
    @reposCall('getForks', repo, cb)

  tags: (repo, cb) ->
    @reposCall('getTags', repo, cb)

  releases: (repo, cb) ->
    @generalCall('releases', 'listReleases', repo, cb)

  branches: (repo, cb) ->
    @reposCall('getBranches', repo, cb)

  labels: (repo, cb) ->
    @issuesCall('getLabels', repo, cb)

  milestones: (repo, cb) ->
    @issuesCall('getAllMilestones', repo, cb)

  prs: (repo, cb) ->
    @generalCall('pullRequests', 'getAll', repo, cb)

  issues: (repo, cb) ->
    @issuesCall('repoIssues', repo, cb)

  commits: (repo, cb) ->
    @reposCall('getCommits', repo, cb)

  stargazers: (repo, cb) ->
    @reposCall('getStargazers', repo, cb)


module.exports = new GitHubClient
