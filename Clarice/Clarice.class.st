"
I am Clarice, a SoulSeek client made with Pharo.
"
Class {
	#name : #Clarice,
	#superclass : #Object,
	#classVars : [
		'ListeningPort',
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
				description: 'Please enter your SoulSeek account password'.			(aBuilder setting: #listeningPort)
				order: 3;
				default: 2234;
				label: 'Listening port' translated;
				description: 'Please enter Clarice''s listening port' ]
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

{ #category : #accessing }
Clarice class >> listeningPort [
^ListeningPort
]

{ #category : #accessing }
Clarice class >> listeningPort: aNumber [
ListeningPort := aNumber
]

{ #category : #actions }
Clarice class >> login [
	"I am the login method"

	"login ( or connect first) to the soulseek server and send our initializing packets ( upload speed, share count, joined rooms, etc.)"

	"--- Send the buffer to the server ---"
Transcript show: 'Logging in as ', self username , ' with ', self password;cr.
	self
		sendMessage: (SSLogin username: self username password: self password) encode
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
Clarice class >> processServerResponse [
	"I  process the server response"

	| chunk response responseCode responseSize |
	GrowlMorph openWithLabel: 'Clarice' contents: 'Processing server response...'.

	Transcript
		show: 'Processing server response...';
		cr.
	"--- Stop scheduler ---"
	self scheduler isRunning
		ifTrue: [ self scheduler stop ].
	"--- wait until there' data available ---"
	[ self serverSocket isDataAvailable ]
		whileTrue: [ (Delay forSeconds: 1) wait.
			chunk := self serverSocket next: 4.
			responseSize := chunk reverse asInteger - 4.
			chunk := self serverSocket next: 4.
			responseCode := chunk reverse asInteger.
			Transcript
				trace:
					'Message code ' , responseCode asString , ' received. Size: '
						, responseSize asString;
				cr.
			response := self serverSocket next: responseSize.
			responseCode = 1
				ifTrue: [ | x |
					x := SSLogin new.
					x decode: (ReadStream on: response).
					x status = 1
						ifTrue: [ self setListeningPort ] ].
			responseCode = 64
				ifTrue: [ | x |
					Transcript
						show: 'Processing room list';
						cr.
					x := SSRoomList new.
					x decode: (ReadStream on: response) ] ].
	self scheduler start
]

{ #category : #run }
Clarice class >> run [
	self
		stop;
		initializeMe;
		login.
	self scheduler do: [ self processServerResponse ] every: 10 seconds
]

{ #category : #scheduler }
Clarice class >> scheduler [
	^Scheduler
]

{ #category : #scheduler }
Clarice class >> scheduler: aTaskScheduler [
	Scheduler := aTaskScheduler
]

{ #category : #initialize }
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
Clarice class >> setListeningPort [
Transcript show: 'Setting listening port to: ',(self listeningPort) asString;cr.
	self
		sendMessage: (SSSetListeningPort port: self listeningPort) encode
]

{ #category : #run }
Clarice class >> stop [ 
self scheduler stop.
self serverSocket close 
]

{ #category : #accessing }
Clarice class >> username [
^Username
]

{ #category : #accessing }
Clarice class >> username: aString [
Username:=aString
]
