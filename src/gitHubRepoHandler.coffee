childProcess = require 'child-process-promise'
uuid = require 'node-uuid'
fs = require 'fs-promise'

exec = childProcess.exec

gitHubClient = require './gitHubClient'


handleRepo = (repo) ->

  repoDir = "tmp/#{repo.name}_#{repo.id}"

  writeFile = (fileName, data) ->
    fs.writeFile "#{repoDir}/github/#{fileName}.json",
        JSON.stringify(data, null, 4)

  cloneBareRepo = (res) ->
    exec("git clone --bare #{repo.git_url} #{repoDir}/bare_repo")

  cloneLatestRepo = (res) ->
    exec("git clone --depth 1 #{repo.git_url} #{repoDir}/latest")

  # format index.json
  writeIndex = (res) ->
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
    fs.writeFile "#{repoDir}/index.json",
        JSON.stringify(indexJson, null, 4)

  # github/info.json
  writeInfo = (res) ->
    fs.writeFile "#{repoDir}/github/info.json",
        JSON.stringify(repo, null, 4)

  # TODO: partial appl
  writeContributors = (res) ->
    gitHubClient.contributors repo, (contributors) ->
      writeFile('contributors', contributors)

  writeLanguages = (res) ->
    gitHubClient.languages repo, (languages) ->
      writeFile('languages', languages)

  writeForks = (res) ->
    gitHubClient.forks repo, (forks) ->
      writeFile('forks', forks)

  writeTags = (res) ->
    gitHubClient.tags repo, (tags) ->
      writeFile('tags', tags)

  writeReleases = (res) ->
    gitHubClient.releases repo, (releases) ->
      writeFile('releases', releases)

  writeBranches = (res) ->
    gitHubClient.branches repo, (branches) ->
      writeFile('branches', branches)

  writeLabels = (res) ->
    gitHubClient.labels repo, (labels) ->
      writeFile('labels', labels)

  writeMilestones = (res) ->
    gitHubClient.milestones repo, (milestones) ->
      writeFile('milestones', milestones)

  writePrs = (res) ->
    gitHubClient.prs repo, (prs) ->
      writeFile('prs', prs)

  writeIssues = (res) ->
    gitHubClient.issues repo, (issues) ->
      writeFile('issues', issues)

  writeCommits = (res) ->
    gitHubClient.commits repo, (commits) ->
      writeFile('commits', commits)

  writeStargazers = (res) ->
    gitHubClient.stargazers repo, (stargazers) ->
      writeFile('stargazers', stargazers)

  writeTotalSize = (res) ->
    # TODO: do this.
    totalSize =
      timestamp: new Date().getTime()
      total_size: 'TODO'
      metadata_size: 'TODO'
      project_size: 'TODO'

    fs.writeFile "#{repoDir}/github/totalSize.json",
        JSON.stringify(totalSize, null, 4)

  # TODO: if package.json

  exec("mkdir -p #{repoDir}/github")
  .then(cloneBareRepo)
  .then(cloneLatestRepo)
  .then(writeIndex)
  .then(writeInfo)
  .then(writeContributors)
  .then(writeLanguages)
  .then(writeForks)
  .then(writeTags)
  .then(writeReleases)
  .then(writeBranches)
  .then(writeLabels)
  .then(writeMilestones)
  .then(writePrs)
  .then(writeIssues)
  .then(writeCommits)
  .then(writeStargazers)
  .then(writeTotalSize)
  .fail (err) -> console.error 'ERROR:', err

  return repo.name

module.exports = {
  handleRepo
}
