jest.dontMock '../src/stores/DirStore.coffee'

describe 'dirsFromDB', ->
  it 'gets dirs from db', ->
    dataStore = require '../src/stores/DirStore.coffee'

    # expect(dataStore.scannedFiles).toEqual(0)
