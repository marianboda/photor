SQL = require 'sqlite3'
config = require '../config'

db = new SQL.Database "#{config.DB_PATH}/db.sqlite"

db.serialize ->
  console.log 'somethin'
  db.run 'CREATE TABLE IF NOT EXISTS tab (a,b,c)'
  db.run 'INSERT INTO tab (a,b,c) VALUES (?,?,?)', [1,2,3]
