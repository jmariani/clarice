"
""I am Clarice, a SoulSeek client made with Pharo""
"
Class {
	#name : #Clarice,
	#superclass : #Object,
	#instVars : [
		'autojoin',
		'branchLevel',
		'branchRoot',
		'cache',
		'childPeers',
		'client',
		'description',
		'downloadFolder',
		'downloadQueue',
		'downloads',
		'downloadSlots',
		'downloadThrottle',
		'downloadThrottler',
		'lastBroadcastSearch',
		'lastSearch',
		'lastSelfSearch',
		'loggedIn',
		'maxChildren',
		'maxPeers',
		'parentPeer',
		'password',
		'peerAddresses',
		'peers',
		'peerServer',
		'pendingPeers',
		'port',
		'potentialParents',
		'rooms',
		'server',
		'sharedFolder',
		'shareList',
		'status',
		'tickers',
		'toDownload',
		'uploadQueue',
		'uploads',
		'uploadSlots',
		'uploadThrottle',
		'uploadThrottler',
		'username',
		'waitPort'
	],
	#category : #Clarice
}

{ #category : #accessing }
Clarice >> autojoin [
	^ autojoin
]

{ #category : #accessing }
Clarice >> autojoin: anObject [
	autojoin := anObject
]

{ #category : #accessing }
Clarice >> branchLevel [
	^ branchLevel
]

{ #category : #accessing }
Clarice >> branchLevel: anObject [
	branchLevel := anObject
]

{ #category : #accessing }
Clarice >> branchRoot [
	^ branchRoot
]

{ #category : #accessing }
Clarice >> branchRoot: anObject [
	branchRoot := anObject
]

{ #category : #accessing }
Clarice >> cache [
	^ cache
]

{ #category : #accessing }
Clarice >> cache: anObject [
	cache := anObject
]

{ #category : #accessing }
Clarice >> childPeers [
	^ childPeers
]

{ #category : #accessing }
Clarice >> childPeers: anObject [
	childPeers := anObject
]

{ #category : #accessing }
Clarice >> client [
	^ client
]

{ #category : #accessing }
Clarice >> client: anObject [
	client := anObject
]

{ #category : #accessing }
Clarice >> description [
	^ description
]

{ #category : #accessing }
Clarice >> description: anObject [
	description := anObject
]

{ #category : #accessing }
Clarice >> downloadFolder [
	^ downloadFolder
]

{ #category : #accessing }
Clarice >> downloadFolder: anObject [
	downloadFolder := anObject
]

{ #category : #accessing }
Clarice >> downloadQueue [
	^ downloadQueue
]

{ #category : #accessing }
Clarice >> downloadQueue: anObject [
	downloadQueue := anObject
]

{ #category : #accessing }
Clarice >> downloadSlots [
	^ downloadSlots
]

{ #category : #accessing }
Clarice >> downloadSlots: anObject [
	downloadSlots := anObject
]

{ #category : #accessing }
Clarice >> downloadThrottle [
	^ downloadThrottle
]

{ #category : #accessing }
Clarice >> downloadThrottle: anObject [
	downloadThrottle := anObject
]

{ #category : #accessing }
Clarice >> downloadThrottler [
	^ downloadThrottler
]

{ #category : #accessing }
Clarice >> downloadThrottler: anObject [
	downloadThrottler := anObject
]

{ #category : #accessing }
Clarice >> downloads [
	^ downloads
]

{ #category : #accessing }
Clarice >> downloads: anObject [
	downloads := anObject
]

{ #category : #initialization }
Clarice >> initialize [
	"I am the initialize method"

	"This method initializes several instance variables"

	| temporary variable names |
	super initialize.
	server := 'vps.slsknet.org'.
	port := 2416.
	waitPort := 2234.
	maxPeers := 100.
	uploadSlots := 2.
	downloadSlots := 2.
	uploadThrottle := 56 * 1024.
	downloadThrottle := 56 * 1024.
	status := 2.	"our online status (1 away, 2 online)"

	"the share list
	{ dir: [ { file, size, ... } ]"
	shareList := {}.

	"these are only P type peers, not F or D
	{ ip: { Peer } }"
	peers := {}.

	"when we send off a connect to peer request to the server, we send
	the type (P, F, D) and a token. the peer will send us back the token
	but not the type, so keep track of those.
	{ connectToken: cType }"
	pendingPeers := {}.

	"peers that could be our parent. sent from netinfo after we say we're orphaned"
	potentialParents := {}.

	"child peers to send search results to from our parent peer"
	childPeers := {}.

	"how far we are down the family tree (how many parents our parent has)"
	branchLevel := 0.

	"who our parent is"
	branchRoot := ''.

	"how many children we should accept at max. i'm hardcoding 10 for now
	but it should be a ratio packet they send divided by our speed. TODO."
	maxChildren := 10.

	"{ username: { ip, port } }"
	peerAddresses := {}.

	"our *active* transfers
   { token: { file: { file, size, ... }, dir: String, peer: Peer } }"
	uploads := {}.
	downloads := {}.

	"pending transfers
    [ ]"
	uploadQueue := {}.
	downloadQueue := {}.

	"not exactly a queue - these are files we requested and others have
  	queued
  	{ file: { file, size, ... } }"
	toDownload := {}.

	"which rooms we're in
 	{ room: [ { users }, ... ] }"
	rooms := {}.

	"ticker messages! these usually spam on the top of the chatroom you're
	in. an alternate implementation could use them as status messages
	{ room: { username: tickerMessage } }"
	tickers := {}.

	"cache gzipped search results (?) and our shares"
	cache := {}.

	"are we sucessfully logged in?"
	loggedIn := false.

	"the last time we searched (i don't want to accidentally send too many)"
	lastSearch := -1.

	"the time we sent a successful search"
	lastSelfSearch := -1.

	"the last time we broadcasted a search to our children"
	lastBroadcastSearch := -1
]

{ #category : #accessing }
Clarice >> lastBroadcastSearch [
	^ lastBroadcastSearch
]

{ #category : #accessing }
Clarice >> lastBroadcastSearch: anObject [
	lastBroadcastSearch := anObject
]

{ #category : #accessing }
Clarice >> lastSearch [
	^ lastSearch
]

{ #category : #accessing }
Clarice >> lastSearch: anObject [
	lastSearch := anObject
]

{ #category : #accessing }
Clarice >> lastSelfSearch [
	^ lastSelfSearch
]

{ #category : #accessing }
Clarice >> lastSelfSearch: anObject [
	lastSelfSearch := anObject
]

{ #category : #accessing }
Clarice >> loggedIn [
	^ loggedIn
]

{ #category : #accessing }
Clarice >> loggedIn: anObject [
	loggedIn := anObject
]

{ #category : #initialization }
Clarice >> login [
	"I am the login method"

	"login ( or connect first) to the soulseek server and send our initializing packets ( upload speed, share count, joined rooms, etc.)"

	"I will compose the message to be sent to the SoulSeek server"

	"Message structure:
	- Message length
	- Message code
	- Username length
	- Username
	- Password length
	- Password
	- Version
	- Hash length
	- Hash
	- Number"

	"scope: class-variables  &  instance-variables"

	| hash message messageCode messageSize number packedSizeOfHash passwordAsHex packedSizeOfPassword packedSizeOfUsername stream usernameAsHex version |
	Transcript
		show: 'I am the login method';
		cr.

	"I will test if username is valid"
	self username ifNil: [ self error: 'Invalid username' ].
	"I will test if password is valid"
	self password ifNil: [ self error: 'Invalid password' ].

	"I'll build the message to send to the SoulSeek server"
	"Number field"
	number := 1 asByteArray hex padRightTo: 8 with: $0.

	"Hash field: MD5 hex digest of concatenated username & password"
	hash := (MD5 new hashMessage: self username , self password) hex.

	"Hash length field"
	packedSizeOfHash := hash size asByteArray hex padRightTo: 8 with: $0.

	"Version field"
	version := 181 asByteArray hex padRightTo: 8 with: $0.
	"Password"
	passwordAsHex := self password asByteArray hex.
	"Password length field"
	packedSizeOfPassword := self password size asByteArray hex
		padRightTo: 8
		with: $0.
	"Username"
	usernameAsHex := self username asByteArray hex.
	"Username length"
	packedSizeOfUsername := self username size asByteArray hex
		padRightTo: 8
		with: $0.
	"Message code field"
	messageCode := 1 asByteArray hex padRightTo: 8 with: $0.
	message := messageCode , packedSizeOfUsername , usernameAsHex
		, packedSizeOfPassword , passwordAsHex , version , packedSizeOfHash
		, hash asByteArray hex , number.

	"Message size"
	messageSize := message size / 2.
	message := (messageSize asByteArray hex padRightTo: 8 with: $0)
		, message.
	Transcript
		show: message;
		cr.
	"I finished composing the payload"

	"I will connect to SoulSeek server"
	stream := SocketStream new
		openConnectionToHostNamed: self server port: self port;
		binary.
	stream isConnected
		ifTrue: [ stream sendCommand: message ]
]

{ #category : #accessing }
Clarice >> maxChildren [
	^ maxChildren
]

{ #category : #accessing }
Clarice >> maxChildren: anObject [
	maxChildren := anObject
]

{ #category : #accessing }
Clarice >> maxPeers [
	^ maxPeers
]

{ #category : #accessing }
Clarice >> maxPeers: anObject [
	maxPeers := anObject
]

{ #category : #accessing }
Clarice >> parentPeer [
	^ parentPeer
]

{ #category : #accessing }
Clarice >> parentPeer: anObject [
	parentPeer := anObject
]

{ #category : #accessing }
Clarice >> password [
	^ password
]

{ #category : #accessing }
Clarice >> password: anObject [
	password := anObject
]

{ #category : #accessing }
Clarice >> peerAddresses [
	^ peerAddresses
]

{ #category : #accessing }
Clarice >> peerAddresses: anObject [
	peerAddresses := anObject
]

{ #category : #accessing }
Clarice >> peerServer [
	^ peerServer
]

{ #category : #accessing }
Clarice >> peerServer: anObject [
	peerServer := anObject
]

{ #category : #accessing }
Clarice >> peers [
	^ peers
]

{ #category : #accessing }
Clarice >> peers: anObject [
	peers := anObject
]

{ #category : #accessing }
Clarice >> pendingPeers [
	^ pendingPeers
]

{ #category : #accessing }
Clarice >> pendingPeers: anObject [
	pendingPeers := anObject
]

{ #category : #accessing }
Clarice >> port [
	^ port
]

{ #category : #accessing }
Clarice >> port: anObject [
	port := anObject
]

{ #category : #accessing }
Clarice >> potentialParents [
	^ potentialParents
]

{ #category : #accessing }
Clarice >> potentialParents: anObject [
	potentialParents := anObject
]

{ #category : #accessing }
Clarice >> rooms [
	^ rooms
]

{ #category : #accessing }
Clarice >> rooms: anObject [
	rooms := anObject
]

{ #category : #accessing }
Clarice >> server [
	^ server
]

{ #category : #accessing }
Clarice >> server: anObject [
	server := anObject
]

{ #category : #accessing }
Clarice >> shareList [
	^ shareList
]

{ #category : #accessing }
Clarice >> shareList: anObject [
	shareList := anObject
]

{ #category : #accessing }
Clarice >> sharedFolder [
	^ sharedFolder
]

{ #category : #accessing }
Clarice >> sharedFolder: anObject [
	sharedFolder := anObject
]

{ #category : #accessing }
Clarice >> status [
	^ status
]

{ #category : #accessing }
Clarice >> status: anObject [
	status := anObject
]

{ #category : #accessing }
Clarice >> tickers [
	^ tickers
]

{ #category : #accessing }
Clarice >> tickers: anObject [
	tickers := anObject
]

{ #category : #accessing }
Clarice >> toDownload [
	^ toDownload
]

{ #category : #accessing }
Clarice >> toDownload: anObject [
	toDownload := anObject
]

{ #category : #accessing }
Clarice >> uploadQueue [
	^ uploadQueue
]

{ #category : #accessing }
Clarice >> uploadQueue: anObject [
	uploadQueue := anObject
]

{ #category : #accessing }
Clarice >> uploadSlots [
	^ uploadSlots
]

{ #category : #accessing }
Clarice >> uploadSlots: anObject [
	uploadSlots := anObject
]

{ #category : #accessing }
Clarice >> uploadThrottle [
	^ uploadThrottle
]

{ #category : #accessing }
Clarice >> uploadThrottle: anObject [
	uploadThrottle := anObject
]

{ #category : #accessing }
Clarice >> uploadThrottler [
	^ uploadThrottler
]

{ #category : #accessing }
Clarice >> uploadThrottler: anObject [
	uploadThrottler := anObject
]

{ #category : #accessing }
Clarice >> uploads [
	^ uploads
]

{ #category : #accessing }
Clarice >> uploads: anObject [
	uploads := anObject
]

{ #category : #accessing }
Clarice >> username [
	^ username
]

{ #category : #accessing }
Clarice >> username: anObject [
	username := anObject
]

{ #category : #accessing }
Clarice >> waitPort [
	^ waitPort
]

{ #category : #accessing }
Clarice >> waitPort: anObject [
	waitPort := anObject
]
