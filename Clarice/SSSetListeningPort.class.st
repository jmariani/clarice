Class {
	#name : #SSSetListeningPort,
	#superclass : #SSServerMessage,
	#classVars : [
		'Port'
	],
	#category : #Clarice
}

{ #category : #accessing }
SSSetListeningPort class >> code [
	^ 2
]

{ #category : #encoding }
SSSetListeningPort class >> encode [
	| buffer |
	"set up buffer"
	buffer := ByteArray new writeStream.

	"fill buffer"
	buffer
		nextPutAll: self codePacked;
		nextPutAll: (ClariceHelper packNumberAsByteArray: (self port) asInteger width: 4).

	^ buffer contents
]

{ #category : #accessing }
SSSetListeningPort class >> port [ 
^Port
]

{ #category : #accessing }
SSSetListeningPort class >> port: aNumber [
Port:=aNumber
]
