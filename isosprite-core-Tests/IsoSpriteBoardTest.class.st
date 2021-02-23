Class {
	#name : #IsoSpriteBoardTest,
	#superclass : #TestCase,
	#category : #'isosprite-core-Tests'
}

{ #category : #tests }
IsoSpriteBoardTest >> testIsoSpriteBoardCreation [
	| boardController |
	boardController := TestBoardController new.
	boardController inspect
]
