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
	#classVars : [
		'password',
		'username'
	],
	#category : #Clarice
}

{ #category : #accessing }
SSLogin class >> code [
	^ 1
]

{ #category : #encoding }
SSLogin class >> encode [
	| buffer hash |
	"Hash field: MD5 hex digest of concatenated username & password"
	hash := (MD5 new hashMessage: self username , self password) hex.

	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: self codePacked;
		nextPutAll: (ClariceHelper packNumberAsByteArray: self username size width: 4);
		nextPutAll: self username asByteArray;
		nextPutAll: (ClariceHelper packNumberAsByteArray: self password size width: 4);
		nextPutAll: self password asByteArray;
		nextPutAll: (ClariceHelper packNumberAsByteArray: self majorVersion width: 4);
		nextPutAll: (ClariceHelper packNumberAsByteArray: hash size width: 4);
		nextPutAll: hash asByteArray;
		nextPutAll: (ClariceHelper packNumberAsByteArray: self minorVersion width: 4).
	^ buffer contents 
]

{ #category : #accessing }
SSLogin class >> password [
	^ password
]

{ #category : #accessing }
SSLogin class >> password: anObject [
	password := anObject
]

{ #category : #accessing }
SSLogin class >> username [
	^ username
]

{ #category : #accessing }
SSLogin class >> username: anObject [
	username := anObject
]

{ #category : #'instance creation' }
SSLogin class >> username: anUsername password: aPassword [
	self username: anUsername;password: aPassword .
	
	
]
