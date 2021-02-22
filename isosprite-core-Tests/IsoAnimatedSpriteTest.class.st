Class {
	#name : #IsoAnimatedSpriteTest,
	#superclass : #TestCase,
	#instVars : [
		'testDefinition'
	],
	#category : #'isosprite-core-Tests'
}

{ #category : #running }
IsoAnimatedSpriteTest >> setUp [ 

]

{ #category : #running }
IsoAnimatedSpriteTest >> testAnimatedSprite [
	|sprite|
	sprite := TestAnimatedSprite generate: 'default'.
	sprite inspect
	"
	in inspector;
	-------------
	self openInWorld.
	self scaleFactor: 2@2.
	self direction: 6.
	self play: 'swing'
	"

]
