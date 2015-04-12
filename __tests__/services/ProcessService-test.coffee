jest.dontMock '../../src/services/ProcessService.coffee'

describe 'queue', ->
  it 'should have queue defined', ->
    ProcessService = require '../../src/services/ProcessService.coffee'
    expect(ProcessService.queue).toBeDefined()
