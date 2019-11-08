Class {
	#name : #SSRoomList,
	#superclass : #SSServerMessage,
	#instVars : [
		'numberOfRooms',
		'rooms'
	],
	#category : #Clarice
}

{ #category : #accessing }
SSRoomList class >> code [
	^ 64
]

{ #category : #converting }
SSRoomList >> decode: aStream [
	| chunk room roomName roomNameSize |
	rooms := OrderedCollection new.
	"--- first four bytes is number of rooms ---"
	numberOfRooms := (aStream next: 4) reverse asInteger.
	Transcript
		show: 'Processing ' , numberOfRooms asString , ' public rooms.';
		cr.
	"--- iterate from 1 to numberOfRooms ---"
	1 to: numberOfRooms do: [ :i | 
		"--- next four bytes are the length of the room name ---"
		roomNameSize := (aStream next: 4) reverse asInteger.
		"--- next roomNameSize bytes are the name of the room ---"
		room := SSRoom new.
		room
			name: (aStream next: roomNameSize) asString.
		rooms add: room.
		Transcript
			show: room name;
			cr ].
	"--- read the number of users on each room ---"
	"--- next four bytes is number of rooms ---"
	numberOfRooms := (aStream next: 4) reverse asInteger.

	"--- iterate from 1 to numberOfRooms ---"
	1 to: numberOfRooms do: [ :i | 
		"--- next four bytes are the users of the room ---"
		room := rooms at: i.
		room users: (aStream next: 4) reverse asInteger.
		Transcript
			show: (rooms at: i) users;
			cr ].
	self halt
]

{ #category : #accessing }
SSRoomList >> numberOfRooms [
	^ numberOfRooms
]

{ #category : #accessing }
SSRoomList >> numberOfRooms: anObject [
	numberOfRooms := anObject
]

{ #category : #accessing }
SSRoomList >> rooms [
	^ rooms
]

{ #category : #accessing }
SSRoomList >> rooms: anObject [
	rooms := anObject
]
