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
		'entities',
		'minX',
		'minY',
		'maxX',
		'maxY',
		'player',
		'floorTiles',
		'wallTiles'
	],
	#category : #'isosprite-core-Tests'
}

{ #category : #initialization }
TestBoardController >> addCaveFloorTile: tileName at: boardPosition [

	| tile |
	self setMinMaxvalues: boardPosition .
	"tile := TestOldTileObject create: tileName."
	tile := TestCaveTileObject create: tileName.
	tile boardPosition: boardPosition.
	floorTiles at: boardPosition put: tile.
	"Transcript show: 'adding floor tile ',tile asString,' at ',boardPosition asString;cr."
]

{ #category : #initialization }
TestBoardController >> addCaveWallTile: tileName at: boardPosition [

	| tile |
	self setMinMaxvalues: boardPosition .
	"tile := TestOldTileObject create: tileName."
	tile := TestCaveTileObject create: tileName.
	tile boardPosition: boardPosition.
	wallTiles at: boardPosition put: tile.
	"Transcript show: 'adding tile at ',boardPosition asString;cr."
]

{ #category : #initialization }
TestBoardController >> addEntity: entityName at: boardPosition [

	| entity |
	entityName = 'hero' ifTrue: [ 
		entity := TestHero create.
		entity sprite setSelectSpriteNamed: 'clothes' forLayer: 'body'.
		entity sprite setSelectSpriteNamed: 'long_sword' forLayer: 'weapon' ].
	entityName = 'zombie' ifTrue: [ entity := TestZombie create ].
	entity sprite play: entity spriteIdleAnimationName .
	entity boardPosition: boardPosition.
	entities at: boardPosition put: entity
]

{ #category : #initialization }
TestBoardController >> addFloorTile: tileName at: boardPosition [

	| tile |
	self setMinMaxvalues: boardPosition .
	"tile := TestOldTileObject create: tileName."
	tile := TestTileObject create: tileName.
	tile boardPosition: boardPosition.
	tiles at: boardPosition put: tile.
	Transcript show: 'adding floor tile ',tile asString,' at ',boardPosition asString;cr.
]

{ #category : #initialization }
TestBoardController >> addTile: tileName at: boardPosition [

	| tile |
	self setMinMaxvalues: boardPosition .
	tile := TestOldTileObject create: tileName.
	"tile := TestTileObject create: tileName."
	tile boardPosition: boardPosition.
	tiles at: boardPosition put: tile.
	"Transcript show: 'adding tile at ',boardPosition asString;cr."
]

{ #category : #accessing }
TestBoardController >> attack [
	player sprite play: 'swing' callback: [ 
		player sprite play: 'stance' ]
]

{ #category : #accessing }
TestBoardController >> backShowing: case [

	^ ({ 1. 2. 3. 5. 6. 7. 10. 11. 14. 15 } includes: case) not
]

{ #category : #accessing }
TestBoardController >> board [

	^ board
]

{ #category : #accessing }
TestBoardController >> board: anObject [

	board := anObject
]

{ #category : #accessing }
TestBoardController >> equipItem [

	| current |
	current := player sprite selectedSpriteForLayer: 'body'.
	Transcript show:'testBoardControleer.equipItem current = ',current name;cr.
	current name = 'clothes' ifTrue: [ 
		player sprite
			setSelectSpriteNamed: 'leather_armour'
			forLayer: 'body' ].
	current name = 'leather_armour' ifTrue: [ 
		player sprite
			setSelectSpriteNamed: 'steel_armour'
			forLayer: 'body' ]	.
	current name = 'steel_armour' ifTrue: [ 
		player sprite
			setSelectSpriteNamed: 'clothes'
			forLayer: 'body' ]		
]

{ #category : #initialization }
TestBoardController >> getSpritesFrom: start to: end [

	| tilesReturned |
	tilesReturned := OrderedCollection new.
	start y to: end y do: [ :y | 
		start x to: end x do: [ :x | 
		tilesReturned add: (self getStackFor: x @ y) ] ].

	^ tilesReturned
]

{ #category : #initialization }
TestBoardController >> getStackFor: point [

	| stack floorTile wallTile entity |
	stack := OrderedCollection new.
	wallTile := self lookupWallTileAt: point.
	floorTile := self lookupFloorTileAt: point.
	entity := self lookupEntityAt: point.
	floorTile ifNotNil: [ stack add: floorTile ].
	wallTile ifNotNil: [ stack add: wallTile ].
	entity ifNotNil: [ stack add: entity ].
	^ stack
]

{ #category : #initialization }
TestBoardController >> initialize [

	minX := 0.
	maxX := 0.
	minY := 0.
	maxY := 0.
	self initializeTiles.
	self initializeEntities.
	board := IsoSpriteBoard new.
	board
		dataStore: [ :start :end | self getSpritesFrom: start to: end ];
		dataQuery: [ :boardPosition | self getStackFor: boardPosition ];
		keyboardHandler: [:evt | self keyStroke: evt].
	board paint.
	player := ((self getStackFor: 0@0) last).
	
]

{ #category : #initialization }
TestBoardController >> initializeEntities [  
	entities := Dictionary new.
	self addEntity: 'hero' at: 0@(-2).
	self addEntity: 'zombie' at: 0@(-1).
	self addEntity: 'hero' at: 0@0.
	self addEntity: 'zombie' at: 0@1.
	self addEntity: 'hero' at: 0@2.
	self addEntity: 'zombie' at: 0@3.
]

{ #category : #initialization }
TestBoardController >> initializeTiles [

	| tileData |
	floorTiles := Dictionary new.
	wallTiles := Dictionary new.
	tileData := self sampleCaveData.
	-7 to: 7 do: [ :xy | 
		-7 to: 7 do: [ :xx | 
			| tileno val x y |
			x := 8 + xx.
			y := 8 + xy.
			val := self marchingSquaresValueFor: x @ y.
			tileno := 16 atRandom.
			(self backShowing: val) ifTrue: [ 
				self addCaveFloorTile: 'tile_' , (tileno - 1) asString at: xx @ xy ].
			(val > 0 and: [ val < 15 ]) ifTrue: [ 
				self addCaveWallTile: 'case_' , val asString at: xx @ xy ] ] ]
]

{ #category : #accessing }
TestBoardController >> keyStroke: anEvent [

	| keyValue |
	keyValue := anEvent keyValue.
	
	(keyValue = 30 or: keyValue = 56) ifTrue: [ 
		self moveObject: self player dir: 'up' ]. "up arrow"
	keyValue = 55 ifTrue: [ self moveObject: self player dir: 'upleft' ]. "up arrow"
	keyValue = 57 ifTrue: [ self moveObject: self player dir: 'upright' ]. "up arrow"
	keyValue = 49 ifTrue: [ self moveObject: self player dir: 'downleft' ]. "up arrow"
	keyValue = 51 ifTrue: [ 
		self moveObject: self player dir: 'downright' ]. "up arrow"
	(keyValue = 31 or: keyValue = 50) ifTrue: [ 
		self moveObject: self player dir: 'down' ]. "down arrow"
	(keyValue = 29 or: keyValue = 54) ifTrue: [ 
		self moveObject: self player dir: 'right' ]. "right arrow"
	(keyValue = 28 or: keyValue = 52) ifTrue: [ 
		self moveObject: self player dir: 'left' ]. "left arrow"
	keyValue = 119 ifTrue: [ self wieldItem ].
	keyValue = 101 ifTrue: [ self equipItem ].
	keyValue = 113 ifTrue: [ self attack].
	
]

{ #category : #initialization }
TestBoardController >> lookupEntityAt: boardPosition [
	^ entities at: boardPosition ifAbsent: [ nil ]
]

{ #category : #initialization }
TestBoardController >> lookupFloorTileAt: boardPosition [
	^ floorTiles at: boardPosition ifAbsent: [ nil ]
	
]

{ #category : #initialization }
TestBoardController >> lookupWallTileAt: boardPosition [
	^ wallTiles at: boardPosition ifAbsent: [ nil ]
	
]

{ #category : #accessing }
TestBoardController >> marchingSquaresValueFor: point [
	| val data row1 row2 a b c d |
	data := self sampleCaveData .
	row1 := data at: point y.
	row2 := data at: point y + 1.
	a := row1 at: point x.
	b := row1 at: point x + 1.
	c := row2 at: point x + 1.
	d := row2 at: point x.
	val := 0.
	a = 1 ifTrue: [ val := val + 8 ].
	b = 1 ifTrue: [ val := val + 4 ].
	c = 1 ifTrue: [ val := val + 2 ].
	d = 1 ifTrue: [ val := val + 1 ].
	Transcript show: point asString,' - ',a asString,' ',b asString,' ',c asString,' ',d asString,' -> ',val asString;cr.
	^ val
]

{ #category : #accessing }
TestBoardController >> moveObject: obj dir: dirString [

	| dir |
	dir := IsoSprite directionString: dirString.
	board move: obj Direction: dir.
	entities removeKey: obj boardPosition ifAbsent:[].
	obj lastBoardPosition: obj boardPosition .
	obj boardPosition:
		obj boardPosition + (IsoSprite getDeltaForDirectionValue: dir).
	entities at: obj boardPosition put: obj.	
	Transcript show:'TestBoardController::moveObject boardPosition is now ',obj boardPosition asString;cr.	
]

{ #category : #accessing }
TestBoardController >> player [ 
	^ player
]

{ #category : #accessing }
TestBoardController >> sampleCaveData [
	^ {
		{ 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 }.
		{ 1 . 0 . 0 . 0 . 1 . 0 . 1 . 1 . 1 . 0 . 1 . 0 . 1 . 1 . 1 . 1 }.
		{ 1 . 0 . 0 . 0 . 1 . 0 . 1 . 1 . 1 . 0 . 0 . 0 . 0 . 0 . 0 . 1 }.
		{ 1 . 0 . 0 . 0 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 0 . 0 . 0 . 1 }.
		{ 1 . 0 . 0 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 0 . 0 . 0 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 1 . 1 . 0 . 0 . 0 . 1 . 1 . 1 . 0 . 0 . 1 }.
		{ 1 . 0 . 1 . 1 . 0 . 1 . 1 . 0 . 0 . 0 . 1 . 1 . 1 . 0 . 0 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 1 . 1 . 0 . 0 . 0 . 1 . 1 . 1 . 0 . 0 . 1 }." 8 "
		{ 1 . 0 . 0 . 1 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 1 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 0 . 1 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 1 . 1 . 0 . 0 . 0 . 1 . 1 . 0 . 1 . 1 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 0 . 1 . 1 . 1 . 0 . 0 . 0 . 0 . 0 . 0 . 1 }.
		{ 1 . 0 . 0 . 1 . 0 . 0 . 1 . 1 . 1 . 0 . 0 . 0 . 1 . 1 . 1 . 1 }.
		{ 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 . 1 }.
	}
]

{ #category : #initialization }
TestBoardController >> setMinMaxvalues: boardPosition [
	minX := boardPosition x min: minX.
	minY := boardPosition y min: minY.
	maxX := boardPosition x max: maxX.
	maxY := boardPosition y max: maxY.
]

{ #category : #accessing }
TestBoardController >> wieldItem [

	| current |
	current := player sprite selectedSpriteForLayer: 'weapon'.
	current name = 'dagger' ifTrue: [ 
		player sprite setSelectSpriteNamed: 'short_sword' forLayer: 'weapon' ].
	current name = 'short_sword' ifTrue: [ 
		player sprite setSelectSpriteNamed: 'long_sword' forLayer: 'weapon' ].
	current name = 'long_sword' ifTrue: [ 
		player sprite setSelectSpriteNamed: 'short_bow' forLayer: 'weapon' ].
	current name = 'short_bow' ifTrue: [ 
		player sprite setSelectSpriteNamed: 'dagger' forLayer: 'weapon' ]
]
