Class {
	#name : #TestCaveTileSprite,
	#superclass : #IsoSprite,
	#category : #'isosprite-core-Tests'
}

{ #category : #'class initialization' }
TestCaveTileSprite class >> generate: spritename [

	| instance image |
	instance := self new.
	image := IsoSprite getImageForSprite: 'cave_tiles'.
	instance		
		renderOffset: (64)@(96);
		scaleFactor: 2@2;
		tileHeight:128;
		tileWidth:64;
		renderSize: 64@128.
	(spritename beginsWith: 'tile_') ifTrue: [ | n |
		n := (spritename substrings: '_' ) last asNumber.
		instance form: (instance getTileFrom: image x: n y: 0) ].
	spritename = 'case_1' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 10 y: 3) ].
	spritename = 'case_2' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 9 y: 3) ].
	spritename = 'case_3' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 3 y: 3) ].
	spritename = 'case_4' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 9 y: 4) ].
	spritename = 'case_5' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 14 y: 3) ]."?"
	spritename = 'case_6' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 2 y: 3) ].
	spritename = 'case_7' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 1 y: 4) ].
	spritename = 'case_8' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 0 y: 4) ].
	spritename = 'case_9' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 0 y: 3) ].
	spritename = 'case_10' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 14 y: 3) ]."?"
	spritename = 'case_11' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 11 y: 3) ].
	spritename = 'case_12' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 1 y: 3) ].
	spritename = 'case_13' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 8 y: 3) ].
	spritename = 'case_14' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 9 y: 3) ].
	spritename = 'case_15' ifTrue: [ 
		instance form: (instance getTileFrom: image x: 10 y: 3) ].
	^ instance
]

{ #category : #'as yet unclassified' }
TestCaveTileSprite class >> getEncoded [
]

{ #category : #'class initialization' }
TestCaveTileSprite class >> initialize [
	IsoSprite addSpriteLookup: 'cave_tiles' method: 'getEncoded' class: self.
]