import io from 'socket.io-client';
import React from 'react';

const socketUrl = window.location.protocol + '//' + window.location.hostname + ':3000';
export const socket = io(socketUrl);
export const SocketContext = React.createContext(socket);
