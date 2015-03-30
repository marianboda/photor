jest.dontMock '../../src/services/ProcessService.coffee'

describe 'init', ->
  it 'should have init defined', ->
    ProcessService = require '../../src/services/ProcessService.coffee'
    expect(ProcessService.init).toBeDefined()
    expect(false).toEqual(false)
