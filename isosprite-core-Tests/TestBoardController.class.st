"
I am a test/mock class which creates and uses an IsoSpriteBoard.

I add two layers, one for tiles and one for entities and make the board paint them.
"
Class {
	#name : #TestBoardController,
	#superclass : #Object,
	#instVars : [
		'testDefinition',
		'board',
		'tiles',
		'entities'
	],
	#category : #'isosprite-core-Tests'
}

{ #category : #initialization }
TestBoardController >> addEntity: entityName at: boardPosition [

	| entity |
	entityName = 'hero' ifTrue: [ 
		entity := TestHero create.
		entity sprite selectSpriteNamed: 'clothes' forLayer: 'body'.
		entity sprite selectSpriteNamed: 'long_sword' forLayer: 'wepaon' ].
	entityName = 'zombie' ifTrue: [ entity := TestZombie create ].
	entity sprite play: entity spriteIdleAnimationName.
	entity boardPosition: boardPosition.
	entities at: boardPosition put: entity
]

{ #category : #initialization }
TestBoardController >> addTile: tileName at: boardPosition [

	| tile |
	tile := TestTileObject create: tileName.
	tile boardPosition: boardPosition.
	tiles at: boardPosition put: tile.
	Transcript show: 'adding tile at ',boardPosition asString;cr.
]

{ #category : #accessing }
TestBoardController >> board [

	^ board
]

{ #category : #accessing }
TestBoardController >> board: anObject [

	board := anObject
]

{ #category : #initialization }
TestBoardController >> getEntitiesFrom: startPoint to: endPoint [

	| entitiesReturned |
	entitiesReturned := Dictionary new.
	startPoint y to: endPoint y do: [ :y | 
		startPoint x to: endPoint x do: [ :x | 
			| entity |
			entity := self lookupEntityAt: x @ y.
			entity ifNotNil: [ entitiesReturned at: x@y put: entity ] ] ].
	^ entitiesReturned
]

{ #category : #initialization }
TestBoardController >> getTilesFrom: startPoint to: endPoint [

	| tilesReturned |
	tilesReturned := Dictionary new.
	startPoint y to: endPoint y do: [ :y | 
		startPoint x to: endPoint x do: [ :x | 
			| tile |
			tile := self lookupTileAt: x @ y.
			"Transcript show:'getTilesFrom tile at ',(x@y) asString,' -> ',tile asString;cr."
			tile ifNotNil: [ tilesReturned at: x@y put: tile ] ] ].
	^ tilesReturned
]

{ #category : #initialization }
TestBoardController >> initialize [

	self initializeTiles.
	self initializeEntities.
	board := IsoSpriteBoard new.
	board
		addDataLayer: [ :start :end | self getTilesFrom: start to: end ]
		named: 'tiles'.
	board
		addDataLayer: [ :start :end | self getEntitiesFrom: start to: end ]
		named: 'entities'.
	board paint
]

{ #category : #initialization }
TestBoardController >> initializeEntities [  
	entities := Dictionary new.
	self addEntity: 'hero' at: 0@0.
	self addEntity: 'zombie' at: 3@3.
	self addEntity: 'zombie' at: -2@3.
]

{ #category : #initialization }
TestBoardController >> initializeTiles [ 
	tiles := Dictionary new.
	-2 to: 2 do: [ :y|
		-2 to: 2 do: [ :x|
			| tileno |
			tileno := 1"2 atRandom" .
		   self addTile: 'cr_floor',tileno asString at: x@y] ]
]

{ #category : #initialization }
TestBoardController >> lookupEntityAt: boardPosition [
	^ entities at: boardPosition ifAbsent: [ nil ]
]

{ #category : #initialization }
TestBoardController >> lookupTileAt: boardPosition [
	^ tiles at: boardPosition 
	
]
