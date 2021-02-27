"
I am a morph which displays sprite in different layers in isometric projection.

A layer can be 'tiles', another can be 'items', 'mid-air events' or 'entities'.
I take care of animating moving sprites, and can center myself around one specific sprite 
so that I pan all other sprites around it when it is being moved.

I step
"
Class {
	#name : #IsoSpriteBoard,
	#superclass : #Morph,
	#instVars : [
		'cursor',
		'cursorRadius',
		'tileSize',
		'isoSpritePosition',
		'dataStore',
		'dataQuery',
		'keyboardHandler',
		'globalScaleFactor'
	],
	#category : #'isosprite-core'
}

{ #category : #'as yet unclassified' }
IsoSpriteBoard class >> toISO: point [
	"isoX = cartX - cartY;
 	isoY = (cartX + cartY) / 2;"
 	| isoX isoY x y | 	
 	x := point x.
 	y := point y.
 	isoX := x - y.
 	isoY := (x + y) / 2.
 	^ isoX @ isoY 
]

{ #category : #initialization }
IsoSpriteBoard >> cursorRadius: aNumber [

	| side |
	cursorRadius := aNumber.
	side := 1 + (4 * cursorRadius) * tileSize.
	self extent: ("self class toISO: "side @ side)
]

{ #category : #initialization }
IsoSpriteBoard >> dataQuery: aBlock [ 
	"A block that let us query for the stack of sprites for a given board position"
	dataQuery := aBlock
]

{ #category : #initialization }
IsoSpriteBoard >> dataStore: aBlock [ 
	dataStore := aBlock
]

{ #category : #initialization }
IsoSpriteBoard >> getEndCoord [
	^ cursor + (cursorRadius@cursorRadius )
]

{ #category : #initialization }
IsoSpriteBoard >> getStartCoord [
	^ cursor - (cursorRadius@cursorRadius )
]

{ #category : #initialization }
IsoSpriteBoard >> getTilestacksFromDataStore [
	^ dataStore value: (self getStartCoord ) value: (self getEndCoord )
]

{ #category : #initialization }
IsoSpriteBoard >> handleKeyStroke: anEvent [
	^ true
]

{ #category : #initialization }
IsoSpriteBoard >> handlesKeyboard: anEvent [
	^ true
]

{ #category : #initialization }
IsoSpriteBoard >> initialize [

	super initialize.
	cursor := 0 @ 0.
	tileSize := 64.
	globalScaleFactor := 2 @ 2.
	self
		color: Color transparent;
		borderWidth: 2;
		borderColor: Color green;
		cursorRadius: 2
]

{ #category : #initialization }
IsoSpriteBoard >> keyStroke: anEvent [
	keyboardHandler value: anEvent 
]

{ #category : #initialization }
IsoSpriteBoard >> keyboardHandler: aBlock [ 
	keyboardHandler := aBlock
]

{ #category : #initialization }
IsoSpriteBoard >> move: gameObject Direction: direction [

	| sprite |
	Transcript
		show: 'gmaeObject ' , gameObject asString , ' moves from position '
			, gameObject boardPosition asString;
		cr.
	sprite := gameObject sprite.
	sprite
		move: direction moveCallback: [ 
			sprite play: gameObject spriteIdleAnimationName.
			self positionIsometricObject: gameObject ]
		incrementCallback: [ 
			self
				repaintStackInfFrontOfMovementFor: gameObject
				direction: direction ];
		play: gameObject spriteWalkAnimationName
]

{ #category : #initialization }
IsoSpriteBoard >> paint [
	| tileStacks |
	tileStacks := self getTilestacksFromDataStore .
	tileStacks do: [ :tileStack | 
		 self paintTilestack: tileStack   ]
]

{ #category : #initialization }
IsoSpriteBoard >> paintTilestack: tileStack [ 
	"Paint al sprites in stack from lowest to highest"
	tileStack do: [ :object |
		"Transcript show: 'IsoSpriteBoard::paintTileStack adding sprite ',object asString;cr."
		self positionIsometricObject: object .		
		self addMorph: object sprite  ]
]

{ #category : #initialization }
IsoSpriteBoard >> positionIsometricObject: object [

	| boardPosition midPoint normalizedBoardPosition spritePosition sprite |
	boardPosition := object boardPosition.
	midPoint := self extent x / 3 @ (self extent y / 2).
	sprite := object sprite.
	normalizedBoardPosition := boardPosition - cursor.
	spritePosition := normalizedBoardPosition.
	isoSpritePosition := self class toISO:
		                     spritePosition * tileSize * globalScaleFactor.
	"Transcript
		show:
			'positionIsometricSprite ' , sprite asString , ' for boardPos '
			, boardPosition asString , ' pos = ' , isoSpritePosition asString;
		cr."
	sprite
		globalScaleFactor: globalScaleFactor;
		position: isoSpritePosition + self position.
	sprite isAnimated ifTrue: [ 
		sprite play: object spriteIdleAnimationName ]
]

{ #category : #initialization }
IsoSpriteBoard >> repaintStackInfFrontOfMovementFor: gameObject direction: dir [

	| delta from to |
	delta := IsoSprite getDeltaForDirectionValue: dir.
	from := gameObject lastBoardPosition.
	to := gameObject boardPosition.
	self paintTilestack: (dataQuery value: from + (0 @ 1)).
	self paintTilestack: (dataQuery value: to + (0 @ 1))

	"goingto y ~= in y ifTrue: [ 
		self paintTilestack: (dataQuery value: goingto + (0 @ 1)) ]"
]
