"
I am the login message. My code is 1

Message structure:
	- Message length (Not including this field) (ByteArray 4)
	- Message code (ByteArray 4)
	- Username length (ByteArray 4)
	- Username
	- Password length
	- Password
	- Version
	- Hash length
	- Hash
	- Number
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

{ #category : #accessing }
SSLogin >> code [
	^ 1
]

{ #category : #encoding }
SSLogin >> encode [
	| buffer hash |
	"Hash field: MD5 hex digest of concatenated username & password"
	hash := (MD5 new hashMessage: self username , self password) hex.

	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: self codePacked;
		nextPutAll: (self class packNumberAsByteArray: self username size width: 4);
		nextPutAll: self username asByteArray;
		nextPutAll: (self class packNumberAsByteArray: self password size width: 4);
		nextPutAll: self password asByteArray;
		nextPutAll: (self class packNumberAsByteArray: self majorVersion  width: 4);
		nextPutAll: (self class packNumberAsByteArray: hash size width: 4);
		nextPutAll: hash asByteArray;
		nextPutAll: (self class packNumberAsByteArray: self minorVersion  width: 4).
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

{ #category : #'instance creation' }
SSLogin >> username: anUsername password: aPassword [
	self username: anUsername;password: aPassword .
	
	
]
