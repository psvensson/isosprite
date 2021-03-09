Class {
	#name : #TestCaveTileObject,
	#superclass : #TestGameObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #'as yet unclassified' }
TestCaveTileObject class >> create: tileName [
	| instance |
	instance := self new.
	instance sprite: (TestCaveTileSprite generate: tileName ).
	^ instance
]

{ #category : #initialization }
TestCaveTileObject >> isEntity [
	^ false
]

{ #category : #initialization }
TestCaveTileObject >> spriteIdleAnimationName [
	^ nil
]

{ #category : #initialization }
TestCaveTileObject >> spriteWalkAnimationName [
	^ nil
]
