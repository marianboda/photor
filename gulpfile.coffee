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
    version: '0.21.0',
    outputDir: destDirs.binaries
  , cb

gulp.task 'demo', shell.task(["#{destDirs.binaries}/Atom.app/Contents/MacOS/Atom ."])
gulp.task 'linux', shell.task(["#{destDirs.binaries}/atom ."])

gulp.task 'lint', ->
  gulp.src(paths.csFiles).pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  gulp.src(paths.csFiles)
  .pipe(coffee({bare: true}).on('error', (e) -> console.log "#{e}"; @end() ))
  .pipe(gulp.dest(destDirs.js))

gulp.task 'sass', ->
  gulp.src(paths.sassFiles)
  .pipe(sass({'sourcemap=none': true})).on('error', (e) -> console.log e)
  .pipe(gulp.dest(destDirs.styles))

gulp.task 'copy', ->
  gulp.src('index.html').pipe(gulp.dest('app'))

gulp.task 'watch', ->
  gulp.watch [paths.csFiles], ['coffee']
  gulp.watch [paths.sassFiles], ['sass']

gulp.task 'default', ['coffee', 'sass', 'copy']
