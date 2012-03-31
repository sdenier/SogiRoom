# SogiRoom

A tiny web app in the browser which allows one to book a room. Toy app made to explore 'rich' Internet applications, concurrent modifications and optimistic replication of data between a server and multiple Javascript clients.

## Challenge

How a RIA, hosted in the client browser, can make use of a local data store to avoid server communication, and how the data store syncs with the server to commit changes and resolve conflicts using [optimistic replication](http://en.wikipedia.org/wiki/Optimistic_replication) techniques. See [survey](http://www.ysaito.com/survey.pdf) by Saito/Shapiro (2005).

## Domain model & Business rules
- One room (one resource for reservation)
- Any time slot (date, time + duration) is open for reservation
- No overlapping reservations
- Anyone can make a reservation (anonymously)

## Access URL
- `http://localhost:8080/booking` - browser app in Javascript
- `http://localhost:8080/booking-api` - REST API for the JS app
- `http://localhost:8080/RoomReservation` - basic and standard Seaside app (old)

## Technologies
- Pure Javascript client in the browser, lib JQuery, Underscore.js and Date.js to facilitate development
- Seaside 3 server with REST handler
