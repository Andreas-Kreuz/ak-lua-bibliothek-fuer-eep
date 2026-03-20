import { ServerMain } from '../server/app/ServerMain';
import APP_IDENTIFIER from '../server/app/config/AppIdentifier';
import { app, BrowserWindow, shell } from 'electron';
import * as electron from 'electron';
import * as path from 'path';

let mainWindow: Electron.BrowserWindow;

function createWindow() {
  const icon = app.isPackaged ? undefined : path.resolve(__dirname, '../../resources/icon.ico');

  // Create the browser window.
  mainWindow = new BrowserWindow({
    width: 800,
    height: 700,
    title: 'CE Server',
    icon,
    webPreferences: {
      preload: path.join(__dirname, '/preload/index.js'),
    },
  });

  // Hide the menu
  mainWindow.removeMenu();

  // User App Code
  const server = new ServerMain(path.resolve(electron.app.getPath('appData'), APP_IDENTIFIER));
  server.start();

  mainWindow.webContents.session.clearCache();

  // and load the index.html of the app.
  // mainWindow.loadFile(path.join(__dirname, '../index.html'));
  mainWindow.loadURL('http://localhost:3000/server');

  // Open the DevTools.
  // mainWindow.webContents.openDevTools();

  // Emitted when the window is closed.
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });

  mainWindow.webContents.setWindowOpenHandler(({ url }) => {
    // open url in a browser and prevent default
    shell.openExternal(url);
    return { action: 'deny' };
  });
}

// Create Window on Windows and on MacOS if no window is there after activate
app.on('ready', createWindow);
app.on('activate', () => {
  if (mainWindow === null) {
    createWindow();
  }
});

// Quit when all windows are closed and we are not on MacOS
app.on('window-all-closed', () => {
  if (process.platform !== 'darwin') {
    app.quit();
  }
});
