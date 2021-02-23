Class {
	#name : #TestGameObject,
	#superclass : #Object,
	#instVars : [
		'boardPosition',
		'sprite'
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
