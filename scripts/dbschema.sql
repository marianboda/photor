CREATE TABLE "dir"(
	"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"path" Text NOT NULL,
	"name" Text NOT NULL,
	"filesCount" Integer,
	"deepFilesCount" Integer,
	"deepUnrecognizedCount" Integer,
	"scanDate" Text,
	"processDate" Text,
	"hash" Text );

CREATE UNIQUE INDEX "photo_path" ON "dir"( "path" );

CREATE TABLE "file"(
	"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"name" Text NOT NULL,
	"path" Text NOT NULL,
	"dir" Text NOT NULL,
	"stat" Text,
	"status" Integer DEFAULT 0,
	"exif" Text,
	"hash" Text,
	"scanDate" Text,
	"processDate" Text );

CREATE UNIQUE INDEX "dir_path" ON "file"( "path" );

CREATE TABLE "ignore_path"(
	"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"path" Text NOT NULL );

CREATE TABLE "scanning_path"(
	"id" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,
	"path" Text NOT NULL );

CREATE UNIQUE INDEX "scanning_path_path" ON "scanning_path"( "path" );
