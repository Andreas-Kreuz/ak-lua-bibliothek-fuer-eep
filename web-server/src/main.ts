import { app, BrowserWindow, remote, shell } from 'electron';
import * as path from 'path';

import CommandLineParser from './server/command-line-parser';
import { ServerMain } from './server/server-main';

let mainWindow: Electron.BrowserWindow;

function createWindow() {
  // Create the browser window.
  mainWindow = new BrowserWindow({
    height: 600,
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
    },
    width: 1200,
  });

  // Hide the menu
  mainWindow.removeMenu();

  // User App Code
  const server = new ServerMain();
  server.start();

  // and load the index.html of the app.
  mainWindow.loadFile(path.join(__dirname, '../index.html'));
  // mainWindow.loadURL('http://localhost:3000');

  // Open the DevTools.
  mainWindow.webContents.openDevTools();

  // Emitted when the window is closed.
  mainWindow.on('closed', () => {
    // Dereference the window object, usually you would store windows
    // in an array if your app supports multi windows, this is the time
    // when you should delete the corresponding element.
    mainWindow = null;
  });

  mainWindow.webContents.on('new-window', (e, url) => {
    e.preventDefault();
    shell.openExternal(url);
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
