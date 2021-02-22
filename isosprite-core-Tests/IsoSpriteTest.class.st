Class {
	#name : #IsoSpriteTest,
	#superclass : #TestCase,
	#category : #'isosprite-core-Tests'
}

{ #category : #'as yet unclassified' }
IsoSpriteTest >> testcreateIsoSprite [
	|sprite|
	sprite := TestTileSprite generate: 'brown_wall'.
	self assert: sprite form isNotNil .
	sprite inspect
]
