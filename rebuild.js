console.log(':)')

i = require('electron-rebuild');

installNodeHeaders = i.installNodeHeaders;
rebuildNativeModules = i.rebuildNativeModules;
shouldRebuildNativeModules = i.shouldRebuildNativeModules;



// import { installNodeHeaders, rebuildNativeModules, shouldRebuildNativeModules } from 'electron-rebuild';

shouldRebuildNativeModules('./binaries/Electron.app')
  .then((shouldBuild) => {

    if (!shouldBuild)
      console.log('shouldn\'t build')
      // return true;

    return installNodeHeaders('v0.27.2')
      .then(() => rebuildNativeModules('v0.27.2', './node_modules'));
  })
  .catch((e) => {
    console.error("Building modules didn't work!");
    console.error(e);
  });
