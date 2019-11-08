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
		'greet',
		'ip',
		'passwordDigest',
		'reason',
		'status'
	],
	#classVars : [
		'Password',
		'Username'
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
	^ Password
]

{ #category : #accessing }
SSLogin class >> password: anObject [
	Password := anObject
]

{ #category : #accessing }
SSLogin class >> username [
	^ Username
]

{ #category : #accessing }
SSLogin class >> username: anObject [
	Username := anObject
]

{ #category : #accessing }
SSLogin class >> username: anUsername password: aPassword [
	Username:= anUsername.
	Password:= aPassword.
	
	
]

{ #category : #converting }
SSLogin >> decode: aStream [
	| chunk ip1 ip2 ip3 ip4 reasonSize |
	"--- first four bytes is the status: 1-Success, 0-Failure ---"
	chunk := aStream next: 4.
	status := chunk reverse asInteger.
	status = 1
		ifFalse: [ reasonSize := chunk reverse asInteger.
			reason := aStream next: reasonSize.
			Transcript
				show: 'Login failed';
				cr ]
		ifTrue: [ "--- swallow one next byte ---"
			chunk := aStream next: 1.
			"--- next four bytes is my IP (reversed) ---"
			ip4 := aStream next: 1.
			ip3 := aStream next: 1.
			ip2 := aStream next: 1.
			ip1 := aStream next: 1.
			ip := {ip1.
			ip2.
			ip3.
			ip4}.
			"--- next four bytes is length of password digest ---"
			chunk := aStream next: 4.
			passwordDigest := aStream next: chunk reverse asInteger.
			Transcript
				show: 'Login successful';
				cr ]
]

{ #category : #accessing }
SSLogin >> greet [
	^ greet
]

{ #category : #accessing }
SSLogin >> greet: anObject [
	greet := anObject
]

{ #category : #accessing }
SSLogin >> ip [
	^ ip
]

{ #category : #accessing }
SSLogin >> ip: anObject [
	ip := anObject
]

{ #category : #accessing }
SSLogin >> passwordDigest [
	^ passwordDigest
]

{ #category : #accessing }
SSLogin >> passwordDigest: anObject [
	passwordDigest := anObject
]

{ #category : #accessing }
SSLogin >> reason [
	^ reason
]

{ #category : #accessing }
SSLogin >> reason: anObject [
	reason := anObject
]

{ #category : #accessing }
SSLogin >> status [
	^ status
]

{ #category : #accessing }
SSLogin >> status: anObject [
	status := anObject
]
