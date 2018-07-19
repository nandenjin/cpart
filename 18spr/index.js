
const readline = require( 'readline' );

const WebSocketServer = require( 'ws' ).Server;
const http = require( 'http' );

const express = require( 'express' );
const app = express();

app.use( express.static( __dirname + '/public/' ) );

const server = http.createServer( app );
const wss = new WebSocketServer( { server: server } );

let sw = true;

let sockets = [];

wss.on( 'connection', socket => {

  sockets.push( socket );
  socket.send( JSON.stringify( { sw: sw } ) );

  console.log( `**** CONNECTION ${ sockets.length } ****` );

  socket.on( 'close', () => {


    sockets = sockets.filter( s => s !== socket ) 

  } );
  socket.on( 'message', msg => {

    broadcast( msg );
    console.log( msg );

  } );

} );

server.listen( 3030 );


function broadcast( msg ) {

  sockets.forEach( s => s.send( msg ) );

}



const reader = readline.createInterface( {

  input: process.stdin,
  output: process.stdout,

} );

reader.on( 'line', () => {

  sw = !sw;
  broadcast( JSON.stringify( { sw: sw } ) );
  console.log( "**** SW " + ( sw ? 'on' : 'off' ) + " ****" );

} )

