"
I represent a SoulSeek room
I am responible of holding information about a SoulSeek room

Public API and Key Messages

- name: room name
- users: room users
- SSRoom new

Example:
|room|
room := SSRoom new.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	name:		String
	users:		Integer

"
Class {
	#name : #SSRoom,
	#superclass : #Object,
	#instVars : [
		'name',
		'users'
	],
	#category : #Clarice
}

{ #category : #initialization }
SSRoom >> initialize [ 
super initialize .
]

{ #category : #accessing }
SSRoom >> name [
	^ name
]

{ #category : #accessing }
SSRoom >> name: anObject [
	name := anObject
]

{ #category : #accessing }
SSRoom >> users [
	^ users
]

{ #category : #accessing }
SSRoom >> users: anObject [
	users := anObject
]
