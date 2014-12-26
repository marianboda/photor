
I = require 'immutable'

treeData =
  name: 'root', items: [
    {name: 'Applications', items: [
      {name: 'App Store', items: []}
      {name: 'Atom', items: []}
      ]}
    {name: 'Extra', items: [
      {name: 'modules', items: []}
      {name: 'Themes', items: [
        {name: 'Default', items: []}
        ]}
      ]}
    ]

treeDataStore =
  data: I.Map treeData
  token: null

module.exports = treeDataStore
