_ = require 'lodash'
Path = require 'path'

class TreeUtils
  @traversePost = (node, callback, itemsField) ->
    itemsField ?= 'items'
    if node[itemsField]?.length > 0
      @traversePost(sub, callback) for sub in node[itemsField]
    callback node

  @traverse = (node, callback, itemsField) ->
    itemsField ?= 'items'
    callback node
    if node[itemsField]?.length > 0
      @traverse(sub, callback) for sub in node[itemsField]

  @transform = (node, callback, itemsField) ->
    newTree = _.cloneDeep node
    @traverse(newTree, callback, itemsField)
    newTree

  @transformPost = (node, callback, itemsField) ->
    newTree = _.cloneDeep node
    @traversePost(newTree, callback, itemsField)
    newTree

  @getNode = (tree, path, keyField, itemsField) ->
    itemsField ?= 'items'
    keyField ?= 'key'
    pathParts = if Array.isArray(path) then path else path.split(Path.sep)
    pathParts.shift() if pathParts[0] is ''
    pathParts.shift() if pathParts[0] is tree[keyField]

    getSubtree = (tree, path) ->
      found = _.find tree[itemsField], (item) -> item[keyField] is path[0]
      if found? and path.length > 1
        found = getSubtree(found, path[1..])
      found

    getSubtree(tree,pathParts)

  @buildTree = (objects, pathField, sep, keyField, valueField, itemsField) ->
    objects = _.sortBy(objects, 'path')
    sep ?= Path.sep
    keyField ?= 'key'
    valueField ?= 'value'
    itemsField ?= 'items'
    pathField ?= 'path'
    tree = {}
    tree[keyField] = 'root'
    tree[itemsField] = []
    tree[pathField] = ''

    for o in objects
      rawPathParts = o.path.split(sep)
      pathParts = rawPathParts[1..] if rawPathParts[0] is ''
      current = tree
      for p, i in pathParts
        found = _.find current[itemsField], (item) ->
          item[keyField] is p
        unless found?
          newNode = if i is pathParts.length-1 then _.extend(o,{}) else {}
          newNode[keyField] = p
          newNode[pathField] = rawPathParts[0..i+1].join(sep)
          newNode[itemsField] = []
          current[itemsField].push newNode
          found = newNode
        current = found
      current = _.extend(o, current)
    tree

module.exports = TreeUtils
