"
I am Clarice, a SoulSeek client made with Pharo.
"
Class {
	#name : #Clarice,
	#superclass : #Object,
	#classVars : [
		'Password',
		'ServerName',
		'ServerPort',
		'ServerSocket',
		'Username'
	],
	#category : #Clarice
}

{ #category : #settings }
Clarice class >> clariceServerSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #serverSettings)
		label: 'Server settings' translated;
		parent: #clariceSettings;
		with: [ (aBuilder setting: #serverName)
				default: 'vps.slsknet.org';
				label: 'SoulSeek server name' translated;
				description: 'This is the SoulSeek server name. Defaults to vps.slsknet.org'.
			(aBuilder pickOne: #serverPort)
				default: 2416;
				label: 'SoulSeek server port' translated;
				description: 'This is the SoulSeek server TCP port. Defaults to 2416';
				domainValues:
					#(2242 2271 2300 2329 2358 2387 2416 2445 2474 2503 2532 2561 2590 2619 2648 2677) ]
]

{ #category : #settings }
Clarice class >> clariceSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #clariceSettings) label: 'Clarice' translated
]

{ #category : #settings }
Clarice class >> clariceUserInfoSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #userInfoSettings)
		label: 'User info' translated;
		parent: #clariceSettings;
		with: [ (aBuilder setting: #username)
				order: 1;
				default: '';
				label: 'Username' translated;				
				description: 'Please enter your SoulSeek account name.'.
			(aBuilder setting: #password)
				order: 2;
				default: '';
				label: 'Password' translated;
				description: 'Please enter your SoulSeek account password' ]
]

{ #category : #initialize }
Clarice class >> connect [ 
	"--- Open the server socket ---"
	self
		serverSocket:
			(SocketStream
				openConnectionToHostNamed: self serverName
				port: self serverPort).
	self serverSocket isConnected
		ifFalse: [ self error: 'Server connection failed' ].
	"--- set socket as binary ---"
	self serverSocket
		binary;
		autoFlush: true
]

{ #category : #initialize }
Clarice class >> initializeMe [
	"I am the initialize method"

	"This method initializes several variables"

]

{ #category : #messages }
Clarice class >> loginAs: myUsername with: myPassword [
	"I am the login method"

	"login ( or connect first) to the soulseek server and send our initializing packets ( upload speed, share count, joined rooms, etc.)"

	Transcript
		show: 'I am the login method';
		cr.

	"I will test if username is valid"
	myUsername ifNil: [ self error: 'Invalid username' ].
	"I will test if password is valid"
	myPassword ifNil: [ self error: 'Invalid password' ].

	"--- Open a socket ---"
	self
		serverSocket: (SocketStream openConnectionToHostNamed: 'vps.slsknet.org' port: 2416).	"Zdc"
	"--- set socket as binary ---"
	self serverSocket binary.
	self serverSocket autoFlush: true.

	"--- Send the buffer to the server ---"
	self
		sendMessage: (SSLogin username: myUsername password: myPassword).
	self serverSocket isConnected
		ifFalse: [ self error: 'Socket not connected' ].
	self processServerResponse
]

{ #category : #accessing }
Clarice class >> password [
^Password
]

{ #category : #accessing }
Clarice class >> password: aString [
Password:=aString 
]

{ #category : #run }
Clarice class >> run [
	self initializeMe.
	self connect.

]

{ #category : #accessing }
Clarice class >> serverName [
^ServerName
]

{ #category : #accessing }
Clarice class >> serverName: aString [
	ServerName := aString
]

{ #category : #accessing }
Clarice class >> serverPort [
^ServerPort
]

{ #category : #accessing }
Clarice class >> serverPort: aNumber [
	ServerPort := aNumber
]

{ #category : #accessing }
Clarice class >> serverSocket [
	^ ServerSocket
]

{ #category : #accessing }
Clarice class >> serverSocket: aSocketStream [
	ServerSocket := aSocketStream
]

{ #category : #accessing }
Clarice class >> username [
^Username
]

{ #category : #accessing }
Clarice class >> username: aString [
Username:=aString
]

{ #category : #messages }
Clarice >> processLoginResponse: response [
	"I process the login message response"

	| chunk |
	chunk := response next: 4.
	chunk reverse asInteger = 1
		ifFalse: [ Transcript show: (response next: response size - 4) ].
		
		self halt.
]

{ #category : #messages }
Clarice >> processServerResponse [
	"I  process the server response"

	| chunk response responseCode responseSize |
	"--- wait until there' data available ---"
	[ self serverSocket isDataAvailable ]
		whileFalse: [ (Delay forMilliseconds: 100) wait ].

	"--- first four bytes is message size (not including these bytes)---"
	chunk := self serverSocket next: 4.
	responseSize := chunk reverse asInteger - 4.
	"--- next four bytes is response code ---"
	chunk := self serverSocket next: 4.
	responseCode := chunk reverse asInteger.
	"--- read response ---"
	response := self serverSocket next: responseSize.
	"--- do according the responseCode ---"
	"--- code 1 is a response to the login message ---"
	responseCode = 1
		ifTrue: [ self processLoginResponse: response ]
]

{ #category : #messages }
Clarice >> sendMessage: aMessage [
	"I send messages to the SoulSeek server"

	"--- Send the buffer to the server ---"

	self serverSocket
		nextPutAll:
			(ClariceHelper
				packNumberAsByteArray: aMessage encode size asByteArray
				width: 4);
		"		nextPutAll: aByteArray contents."
			nextPutAll: aMessage encode.
	"packNumberAsByteArray: aByteArray size asByteArray"
	self serverSocket flush
]

{ #category : #messages }
Clarice >> setListeningPort: aPort [
	"I take a parameter and send a message to the server telling is the listening port"

	| buffer |
	Transcript
		show: 'I am the setListeningPort method';
		cr.

	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: (ClariceHelper packNumberAsByteArray: 2 width: 4);
		nextPutAll: (ClariceHelper packNumberAsByteArray: aPort width: 4).

	"--- Use existing socket ---"

	"--- Send the buffer to the server ---"
	self sendMessage: buffer
]
