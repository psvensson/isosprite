"
I hold instances of tiles generated from the TestTileSprite object
"
Class {
	#name : #TestOldTileObject,
	#superclass : #TestGameObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #'as yet unclassified' }
TestOldTileObject class >> create: tileName [
	| instance |
	instance := self new.
	instance sprite: (TestTileSprite generate: tileName ).
	^ instance
]

{ #category : #initialization }
TestOldTileObject >> spriteIdleAnimationName [
	^ nil
]

{ #category : #initialization }
TestOldTileObject >> spriteWalkAnimationName [
	^ nil
]
