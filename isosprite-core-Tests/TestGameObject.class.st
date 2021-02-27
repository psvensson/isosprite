"
I am a game object, which is something which has a position on a map/game board and which can have a IsoSprite as a representation. I am sent as a result when the IsoGameBoard asks its controller for which things can be found at a certain point on the gameboard.
"
Class {
	#name : #TestGameObject,
	#superclass : #Object,
	#instVars : [
		'boardPosition',
		'sprite',
		'lastBoardPosition'
	],
	#category : #'isosprite-core-Tests'
}

{ #category : #initialization }
TestGameObject >> boardPosition [
	^boardPosition
]

{ #category : #initialization }
TestGameObject >> boardPosition: aBoardPosition [
	boardPosition := aBoardPosition 
]

{ #category : #initialization }
TestGameObject >> initialize [ 
	boardPosition := 0@0.
	lastBoardPosition := 0@0.
]

{ #category : #initialization }
TestGameObject >> lastBoardPosition [
	^ lastBoardPosition
]

{ #category : #initialization }
TestGameObject >> lastBoardPosition: aBoardPosition [
	lastBoardPosition := aBoardPosition 
]

{ #category : #initialization }
TestGameObject >> sprite [
	^ sprite
]

{ #category : #initialization }
TestGameObject >> sprite: aSprite [
	sprite := aSprite
]

{ #category : #initialization }
TestGameObject >> spriteIdleAnimationName [
	self subclassResponsibility 
]

{ #category : #initialization }
TestGameObject >> spriteWalkAnimationName [
	self subclassResponsibility 
]
