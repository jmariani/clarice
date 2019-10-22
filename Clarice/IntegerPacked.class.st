"
I am a ByteArray. I represent a number packed with trailing zeros
"
Class {
	#name : #IntegerPacked,
	#superclass : #ByteArray,
	#type : #bytes,
	#category : #Clarice
}

{ #category : #initialization }
IntegerPacked >> initialize [
	super initialize
]

{ #category : #'as yet unclassified' }
IntegerPacked >> pack: aNumber width: aWidth [
	^ (aNumber asByteArray hex padRightTo: aWidth with: $0)
]
