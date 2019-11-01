"
I am Clarice, a SoulSeek client made with Pharo.
"
Class {
	#name : #Clarice,
	#superclass : #Object,
	#classVars : [
		'Password',
		'Scheduler',
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

{ #category : #actions }
Clarice class >> connect [
	"--- Open the server socket ---"

	self
		serverSocket:
			(SocketStream
				openConnectionToHostNamed: self serverName
				port: self serverPort).
	"--- set socket as binary ---"
	self serverSocket
		binary;
		autoFlush: true.
	self serverSocket		isConnected ifFalse: [ self error: 'Server connection failed' ]
]

{ #category : #initialize }
Clarice class >> initializeMe [
	"I am the initialize method"

	"This method initializes several variables"

self schedulerInit .
self connect 
]

{ #category : #actions }
Clarice class >> login [
	"I am the login method"

	"login ( or connect first) to the soulseek server and send our initializing packets ( upload speed, share count, joined rooms, etc.)"

	"--- Send the buffer to the server ---"

	self
		sendMessage: (SSLogin username: self username password: self password) encode.
]

{ #category : #accessing }
Clarice class >> password [
^Password
]

{ #category : #accessing }
Clarice class >> password: aString [
Password:=aString 
]

{ #category : #processing }
Clarice class >> processLoginResponse: response [
	"I process the login message response"

	| chunk |
	chunk := response next: 4.
	(chunk reverse asInteger) = 1
		ifFalse: [ Transcript show: (response next: response size - 4) ].
	self halt
]

{ #category : #processing }
Clarice class >> processServerResponse [
	"I  process the server response"

	| chunk response responseCode responseSize |
	"--- Stop scheduler ---"
		self scheduler stop.
	"--- wait until there' data available ---"
	[ self serverSocket isDataAvailable ]
		whileTrue: [ (Delay forMilliseconds: 100) wait.
			"--- do according the responseCode ---"
			"--- code 1 is a response to the login message ---"
			"	responseCode = 1
		ifTrue: [ self processLoginResponse: response ]"
			"--- first four bytes is message size (not including these bytes)---"
			chunk := self serverSocket next: 4.
			responseSize := chunk reverse asInteger - 4.
			"--- next four bytes is response code ---"
			chunk := self serverSocket next: 4.
			responseCode := chunk reverse asInteger.
			Transcript
				traceCr: 'Message code ' , responseCode asString , ' received'.
			"--- read response ---"
			response := self serverSocket next: responseSize ].
]

{ #category : #run }
Clarice class >> run [
	self
		initializeMe;
		login.
		self scheduler do: [ self processServerResponse  ] every: 10 seconds 

]

{ #category : #scheduler }
Clarice class >> scheduler [
	^Scheduler
]

{ #category : #scheduler }
Clarice class >> scheduler: aTaskScheduler [
	Scheduler := aTaskScheduler
]

{ #category : #'as yet unclassified' }
Clarice class >> schedulerInit [
	self
		scheduler: TaskScheduler new.
		self scheduler start
]

{ #category : #messages }
Clarice class >> sendMessage: aMessageEncoded [
	"I send messages to the SoulSeek server"

	"--- Send the buffer to the server ---"

	self serverSocket
		nextPutAll:
			(ClariceHelper
				packNumberAsByteArray: aMessageEncoded size asByteArray
				width: 4);
		nextPutAll: aMessageEncoded .
	self serverSocket flush
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

{ #category : #messages }
Clarice class >> setListeningPort: aPort [
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

{ #category : #accessing }
Clarice class >> username [
^Username
]

{ #category : #accessing }
Clarice class >> username: aString [
Username:=aString
]
