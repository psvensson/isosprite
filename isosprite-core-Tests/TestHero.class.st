"
Sample here with serveral kinds of layers
"
Class {
	#name : #TestHero,
	#superclass : #TestEntityObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #operations }
TestHero class >> create [
	|instance|
	instance := self new.
	instance sprite: (TestAggregatedSprite generate: 'default').
	^ instance
]
