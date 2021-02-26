"
Sample entity holding a Zombie IsoAnimatedSprite
"
Class {
	#name : #TestZombie,
	#superclass : #TestEntityObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #operations }
TestZombie class >> create [
	|instance|
	instance := self new.
	instance sprite: (TestAnimatedSprite generate: 'default').
	^ instance
]
