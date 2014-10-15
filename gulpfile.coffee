gulp = require 'gulp'
shell = require 'gulp-shell'
downloadatomshell = require 'gulp-download-atom-shell'
coffee = require 'gulp-coffee'
mainBowerFiles = require 'main-bower-files'
coffeelint = require 'gulp-coffeelint'

gulp.task 'downloadatomshell', (cb) ->
  downloadatomshell
    version: '0.17.2',
    outputDir: 'binaries'
  , cb

gulp.task 'demo', shell.task(['binaries/Atom.app/Contents/MacOS/Atom .'])

gulp.task 'bowerFiles', ->
  gulp.src(mainBowerFiles()).pipe(gulp.dest('app/libs'))

gulp.task 'lint', ->
  gulp.src('./src/*.coffee').pipe(coffeelint()).pipe(coffeelint.reporter())

gulp.task 'coffee', ->
  gulp.src('./src/*.coffee').pipe(coffee({bare: true}).on('error', (a,b) -> console.log a,b)).pipe(gulp.dest('./app/'))

gulp.task 'default', ['coffee', 'demo']
