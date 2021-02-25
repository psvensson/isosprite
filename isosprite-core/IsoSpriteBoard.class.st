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
		'dataLayers',
		'tileSize',
		'isoSpritePosition',
		'dataLayerPriority',
		'dataStore'
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
IsoSpriteBoard >> addDataLayer: aBlock named: dataLayerName [
	dataLayerPriority add: dataLayerName .
	dataLayers at: dataLayerName put: aBlock
]

{ #category : #initialization }
IsoSpriteBoard >> cursorRadius: aNumber [

	| side |
	cursorRadius := aNumber.
	side := (1 + (4 * cursorRadius)) * tileSize.
	self extent: (side @ side)
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
IsoSpriteBoard >> initialize [

	super initialize.
	cursor := 0 @ 0.
	tileSize := 128.
	self
		color: Color transparent ;
		borderWidth: 2;
		borderColor: Color green;
		cursorRadius: 2.
	dataLayers := Dictionary new.
	dataLayerPriority := OrderedCollection new
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
		self positionIsometricSprite: object boardPosition: object boardPosition  ]
]

{ #category : #initialization }
IsoSpriteBoard >> positionIsometricSprite: object boardPosition: boardPosition [

	| midPoint normalizedBoardPosition spritePosition sprite |
	midPoint := self extent x / 3 @ (self extent y / 2).
	sprite := object sprite.
	normalizedBoardPosition := boardPosition - cursor.
	spritePosition := normalizedBoardPosition - sprite renderOffset.
	isoSpritePosition := self class toISO: spritePosition * sprite scaleFactor * tileSize .
	sprite position: isoSpritePosition + midPoint.
	self addMorph: sprite
]
