"
I am Clarice's little helper
"
Class {
	#name : #ClariceHelper,
	#superclass : #Object,
	#category : #Clarice
}

{ #category : #initialization }
ClariceHelper class >> packNumberAsByteArray: aNumber width: bytes [
	"I take aNumber as a parameter and return a ByteArray 4 or 8 bytes width"

	bytes = 4
		ifTrue: [ ^ {0 . 0 . 0 . 0} asByteArray
				replaceFrom: 1
				to: aNumber asByteArray size
				with: aNumber asByteArray ].
	bytes = 8
		ifTrue: [ ^ {0 . 0 . 0 . 0 . 0 . 0 . 0 . 0} asByteArray
				replaceFrom: 1
				to: aNumber asByteArray size
				with: aNumber asByteArray ].
	self error: 'width must be 4 or 8 bytes'
]
