"
I am the login message
"
Class {
	#name : #SSLogin,
	#superclass : #SSServerMessage,
	#instVars : [
		'username',
		'password'
	],
	#category : #Clarice
}

{ #category : #encoding }
SSLogin >> encode [ 
	| buffer hash |
	"Hash field: MD5 hex digest of concatenated username & password"
	hash := (MD5 new hashMessage: self username , self password) hex.

	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: (self class packNumberAsByteArray: 1 width: 4);
		nextPutAll: (self class packNumberAsByteArray: self username size width: 4);
		nextPutAll: self username asByteArray;
		nextPutAll: (self class packNumberAsByteArray: self password size width: 4);
		nextPutAll: self password asByteArray;
		nextPutAll: (self class packNumberAsByteArray: 157 width: 4);
		nextPutAll: (self class packNumberAsByteArray: hash size width: 4);
		nextPutAll: hash asByteArray;
		nextPutAll: (self class packNumberAsByteArray: 100 width: 4).
	^ buffer
]

{ #category : #accessing }
SSLogin >> password [
	^ password
]

{ #category : #accessing }
SSLogin >> password: anObject [
	password := anObject
]

{ #category : #accessing }
SSLogin >> username [
	^ username
]

{ #category : #accessing }
SSLogin >> username: anObject [
	username := anObject
]
