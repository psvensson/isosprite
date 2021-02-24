Class {
	#name : #TestTileObject,
	#superclass : #TestGameObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #'as yet unclassified' }
TestTileObject class >> create: tileName [
	| instance |
	instance := self new.
	instance sprite: (TestCrackedTileSprite generate: tileName ).
	^ instance
]

{ #category : #initialization }
TestTileObject >> spriteIdleAnimationName [
	^ nil
]

{ #category : #initialization }
TestTileObject >> spriteWalkAnimationName [
	^ nil
]
