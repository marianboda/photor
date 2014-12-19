gulp = require 'gulp'
shell = require 'gulp-shell'
downloadatomshell = require 'gulp-download-atom-shell'
coffee = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
sass = require 'gulp-ruby-sass'

srcDirs =
  js: 'src'
  jade: 'src'
  sass: 'src/styles'
destDirs =
  js: 'app'
  lib: 'app/lib'
  templates:'app'
  styles:'app/css'
  binaries: 'binaries'

paths =
  csFiles: ["#{srcDirs.js}/**/*.coffee"]
  jadeFiles: ["#{srcDirs.jade}/**/*.jade"]
  sassFiles: ["#{srcDirs.sass}/**/*.sass"]

gulp.task 'downloadatomshell', (cb) ->
  downloadatomshell
    version: '0.17.2',
    outputDir: destDirs.binaries
  , cb

gulp.task 'demo', shell.task(["#{destDirs.binaries}/Atom.app/Contents/MacOS/Atom ."])

gulp.task 'lint', ->
  gulp.src(paths.csFiles).pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  gulp.src(paths.csFiles)
  .pipe(coffee({bare: true}).on('error', (a,b) -> console.log a,b))
  .pipe(gulp.dest(destDirs.js))

gulp.task 'sass', ->
  gulp.src(paths.sassFiles)
  .pipe(sass({'sourcemap=none': true})).on('error', (e) -> console.log e)
  .pipe(gulp.dest(destDirs.styles))

gulp.task 'default', ['coffee', 'sass', 'demo']
