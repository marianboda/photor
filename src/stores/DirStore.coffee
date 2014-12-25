
I = require 'immutable'

treeData =
  name: 'root', items: [
    {name: 'Applications', items: [
      {name: 'App Store', items: []}
      {name: 'Atom', items: []}
      {name: 'Calculator', items: []}
      {name: 'EasyFind', items: []}
      {name: 'GitHub', items: []}
      {name: 'Google Chrome', items: []}
      {name: 'Path Finder', items: []}
      {name: 'Pocket', items: []}
      {name: 'Sublime Text', items: []}
      {name: 'Swinsian', items: []}
      ]}
    {name: 'Extra', items: [
      {name: 'modules', items: []}
      {name: 'Themes', items: [
        {name: 'Default', items: []}
        ]}
      ]}
    {name: 'Library', items: [
      {name: 'Application Support', items: []}
      {name: 'Caches', items: []}
      {name: 'Extensions', items: []}
      {name: 'Filesystems', items: []}
      {name: 'Fonts', items: []}
      {name: 'Keyboard Layouts', items: []}
      {name: 'Logs', items: []}
      {name: 'Messages', items: []}
      {name: 'Python', items: []}
      {name: 'QuickLook', items: []}
      {name: 'Scripts', items: []}
      {name: 'Updates', items: []}
      {name: 'Video', items: []}
      ]}
    {name: 'opt', items: []}
    {name: 'System', items: [
      {name: 'Library', items: [
        {name: 'Application Support', items: []}
        {name: 'Caches', items: []}
        {name: 'Extensions', items: []}
        {name: 'Filesystems', items: []}
        {name: 'Fonts', items: []}
        {name: 'Keyboard Layouts', items: []}
        {name: 'Logs', items: []}
        {name: 'Messages', items: []}
        {name: 'Python', items: []}
        {name: 'QuickLook', items: []}
        {name: 'Scripts', items: []}
        {name: 'Updates', items: []}
        {name: 'Video', items: []}
        ]}
      {name: 'Spam', items: []}
      ]}
    {name: 'Users', items: [
      {name: 'arnoldrimmer', items: []}
      {name: 'davidlister', items: []}
      {name: 'kryten', items: []}
      ]}
    ]

treeDataStore =
  data: I.Map treeData
  token: null

module.exports = treeDataStore
