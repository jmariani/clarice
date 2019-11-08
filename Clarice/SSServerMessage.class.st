"
I represent a generic SoulSeek server message 
"
Class {
	#name : #SSServerMessage,
	#superclass : #Object,
	#classVars : [
		'code',
		'majorVersion',
		'minorVersion'
	],
	#category : #Clarice
}

{ #category : #accessing }
SSServerMessage class >> code [
	^ self subclassResponsibility 
]

{ #category : #encoding }
SSServerMessage class >> codePacked [
	^ ClariceHelper packNumberAsByteArray: self  code width: 4
]

{ #category : #encoding }
SSServerMessage class >> encode [
^self subclassResponsibility 
]

{ #category : #accessing }
SSServerMessage class >> majorVersion [ 
^157
]

{ #category : #accessing }
SSServerMessage class >> majorVersionPacked [
	^ ClariceHelper packNumberAsByteArray: self majorVersion  width: 4
]

{ #category : #accessing }
SSServerMessage class >> messageCodes [
	| x |
	x := Dictionary new.
	x
		at: 1 put: 'Login';
		at: 2 put: 'Get Peer Address';
		at: 3 put: 'Set Listen Port';
		at: 5 put: 'Add User';
		at: 6 put: 'Unknown';
		at: 7 put: 'Get Status';
		at: 13 put: 'Say in Chat Room';
		at: 14 put: 'Join a Room';
		at: 15 put: 'Leave Room';
		at: 16 put: 'A User Joined a Room';
		at: 17 put: 'A User Left a Room';
		at: 18 put: 'Connect To Peer';
		at: 22 put: 'Private Messages';
		at: 23 put: 'Acknowledge Private Message';
		at: 26 put: 'File Search';
		at: 28 put: 'Set Online Status';
		at: 32 put: 'Ping';
		at: 34 put: 'Send Speed';
		at: 35 put: 'Shared Folders & Files';
		at: 36 put: 'Get User Stats';
		at: 40 put: 'Queued Downloads';
		at: 41 put: 'Kicked from Server';
		at: 42 put: 'User Search';
		at: 51 put: 'Add Liked Interest';
		at: 52 put: 'Remove Liked Interest';
		at: 54 put: 'Get Recommendations';
		at: 56 put: 'Get Global Recommendations';
		at: 57 put: 'Get User Interests';
		at: 64 put: 'Room List';
		at: 65 put: 'Exact File Search';
		at: 66 put: 'Global/Admin Message';
		at: 69 put: 'Privileged Users';
		at: 71 put: 'Have No Parents';
		at: 73 put: 'Parent''s IP';
		at: 83 put: 'ParentMinSpeed';
		at: 84 put: 'ParentSpeedRatio';
		at: 86 put: 'Parent Inactivity Timeout';
		at: 87 put: 'Search Inactivity Timeout';
		at: 88 put: 'Minimum Parents In Cache';
		at: 90 put: 'Distributed Alive Interval';
		at: 91 put: 'Add Privileged User';
		at: 92 put: 'Check Privileges';
		at: 93 put: 'Search Request';
		at: 100 put: 'Accept Children';
		at: 102 put: 'Net Info';
		at: 103 put: 'Wishlist Search';
		at: 104 put: 'Wishlist Interval';
		at: 110 put: 'Get Similar Users';
		at: 111 put: 'Get Item Recommendations';
		at: 112 put: 'Get Item Similar Users';
		at: 113 put: 'Room Tickers';
		at: 114 put: 'Room Ticker Add';
		at: 115 put: 'Room Ticker Remove';
		at: 116 put: 'Set Room Ticker';
		at: 117 put: 'Add Hated Interest';
		at: 118 put: 'Remove Hated Interest';
		at: 120 put: 'Room Search';
		at: 121 put: 'Send Upload Speed';
		at: 122 put: 'A user''s Soulseek Privileges';
		at: 123 put: 'Give Soulseek Privileges to user';
		at: 124 put: 'Server sends us a Notification about our privileges';
		at: 125 put: 'Acknowledge Privilege Notification';
		at: 126 put: 'Branch Level';
		at: 127 put: 'Branch Root';
		at: 129 put: 'Child depth';
		at: 133 put: 'Private Room Users that we can (dis)op/dismember';
		at: 134 put: 'Private Room Add User';
		at: 135 put: 'Private Room Remove User';
		at: 136 put: 'Private Room Drop Membership';
		at: 137 put: 'Private Room Drop Ownership';
		at: 138 put: 'Private Room Unknown';
		at: 139 put: 'Private Room Added';
		at: 140 put: 'Private Room Removed';
		at: 141 put: 'Private Room Toggle';
		at: 142 put: 'New Password';
		at: 143 put: 'Private Room Add Operator';
		at: 144 put: 'Private Room Remove Operator';
		at: 145 put: 'Private Room Operator Added';
		at: 146 put: 'Private Room Operator Removed';
		at: 148 put: 'Private Room Operators';
		at: 149 put: 'Message Users';
		at: 150 put: 'Ask Public Chat';
		at: 151 put: 'Stop Public Chat';
		at: 152 put: 'Private Chat';
		at: 1001 put: 'Cannot Connect'.
		^x
]

{ #category : #accessing }
SSServerMessage class >> minorVersion [
	^ 100
]

{ #category : #accessing }
SSServerMessage class >> minorVersionPacked [
	^ ClariceHelper packNumberAsByteArray: self minorVersion   width: 4
]

{ #category : #converting }
SSServerMessage >> decode: aStream [
^self subclassResponsibility 
]
