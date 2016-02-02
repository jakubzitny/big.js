gitHubClient = require './gitHubClient'
{handleRepo} = require './gitHubRepoHandler'


gitHubClient.search (repos) ->
  repos.map (repo) ->
    handleRepo(repo)
    # TODO: then
