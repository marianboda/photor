jest.dontMock '../../src/services/MediaProcessService.coffee'

console.log process.version

describe 'init', ->
  it 'should have init defined', ->
    MediaProcessService = require '../../src/services/MediaProcessService.coffee'
    expect(MediaProcessService.init).toBeDefined()
    console.log MediaProcessService
    expect(false).toEqual(false)
