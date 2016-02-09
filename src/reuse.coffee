esprima = require 'esprima'
fs = require 'fs-extra-promise'
path = require 'path'
shell = require 'shelljs'

#dataPath = '../crawlnpm/tmp/'
dataPath = '../tmp/'
parentId = 1
blockId = 1

processFile = (file) ->
  fs.readFile file, (err, data) ->
    if err
      console.error(err)
      return
    options = tokens: true
    tokenPairs = Object.create(null)
    incTokenPair = (token) ->
      count = tokenPairs[token] or 0
      tokenPairs[token] = count + 1
    try
      esprima
        .tokenize(data, options)
        .filter (token) ->
          isId = token.type is 'Identifier'
          isKey = token.type is 'Keyword'
          isLit = token.type is 'Literal'
          isId or isKey or isLit
        .forEach (token) ->
          isLit = token.type is 'Literal'
          isString = typeof token.value is 'string'
          tokenValues = []
          if isLit and isString
            tokenValues = token.value.split(' ')
          else
            tokenValues.push(token.value)
          tokenValues.forEach(incTokenPair)
    catch e
      # TODO: return this
      representation = "error"
      return

    representation = "#{parentId},#{blockId++},@#@"
    Object.keys(tokenPairs).forEach (token) ->
      count = tokenPairs[token]
      representation += "#{token}@@::@@#{count},"
    if representation.endsWith("@#@") then return
    fs.appendFile 'message.txt', "#{representation}\n", (e) ->
      console.error(e) if e
    #console.log("\npairs: (#{file})\n", representation)

processProject = (projectPath) ->
  fs.readdir projectPath, (err, files) ->
    if err
      console.error(err)
      return
    jss = shell.find(projectPath).filter (file) ->
      file.match(/\.js$/) and not file.match(/\.min.js$/)
    #srcs = files.filter (file) ->
    #  file is 'src' or file is 'lib'
    #return jss
    
    jss.forEach (js) ->
      processFile(js)
    

fs.readdir dataPath, (err, files) ->
  if err then console.error(err)
  projectRootPaths = files.map (file) ->
    path.join(dataPath, file, 'latest')
  projectRootPaths.map (projectPath) ->
    processProject(projectPath)
