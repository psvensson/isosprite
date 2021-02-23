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
		'dataLayerPriority'
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
	side := (1 + (2 * cursorRadius)) * tileSize.
	self extent: side @ side
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
IsoSpriteBoard >> getTilesFromLayers [

	| tilesForLayers start end |
	start := self getStartCoord.
	end := self getEndCoord.
	tilesForLayers := Dictionary new.
	dataLayers keysAndValuesDo: [ :name :block | 
		| result |
		result := block value: start value: end.
		Transcript show:'getTilesFromLayers got ',result keys size asString,' for layer ',name;cr.
		tilesForLayers at: name put: result ].
	^ tilesForLayers 
]

{ #category : #initialization }
IsoSpriteBoard >> getTilestacksFromLayers [

	"get sprites from all layers, building a dictionary where for each position there is an orderedcollection with sprites in order of registration preference (so tiles can be lowest/first and entities can be highest/last)"

	| firstLayerName firstLayerCoords tileStacks tilesFromLayers |
	tileStacks := Dictionary new.
	tilesFromLayers := self getTilesFromLayers.
	firstLayerName := dataLayerPriority first.
	firstLayerCoords := (tilesFromLayers at: firstLayerName) keys.
	Transcript show:'getTileStacksFromLayers pasrsing ',firstLayerCoords size asString,' coords';cr.
	firstLayerCoords do: [ :coord | 
		| stack |
		stack := OrderedCollection new.
		tileStacks at: coord put: stack.
		dataLayerPriority do: [ :layerName | 
			| sprite layer |
			layer := tilesFromLayers at: layerName.
			sprite := layer at: coord ifAbsent: [nil].
			sprite ifNotNil: [ stack add: sprite ] ] ].
	^ tileStacks 
]

{ #category : #initialization }
IsoSpriteBoard >> initialize [

	super initialize.
	cursor := 0 @ 0.
	tileSize := 128.
	self
		borderWidth: 2;
		borderColor: Color green;
		cursorRadius: 3.
	dataLayers := Dictionary new.
	dataLayerPriority := OrderedCollection new
]

{ #category : #initialization }
IsoSpriteBoard >> paint [
	| tileStacks |
	tileStacks := self getTilestacksFromLayers.
	tileStacks keysAndValuesDo: [ :boardPosition :tileStack | 
		 self paintTilestack: tileStack at: boardPosition  ]
]

{ #category : #initialization }
IsoSpriteBoard >> paintIsometricSprite: object boardPosition: boardPosition [

	"Calculate real position of isometric projection of boardPosition and add sprite"

	| mid midPoint normalizedBoardPosition spritePosition sprite |
	mid := self extent x / 2.
	midPoint := mid @ mid.

	normalizedBoardPosition := boardPosition - cursor.
	spritePosition := normalizedBoardPosition * tileSize + midPoint.
	isoSpritePosition := self class toISO: spritePosition.
	sprite := object sprite.
	sprite position: isoSpritePosition.
	self addMorph: sprite
]

{ #category : #initialization }
IsoSpriteBoard >> paintTilestack: tileStack at: boardPosition [
	"Paint al sprites in stack from lowest to highest"
	tileStack do: [ :object |
		Transcript show: 'IsoSpriteBoard::paintTileStack adding sprite ',object asString;cr.
		self paintIsometricSprite: object boardPosition: boardPosition  ]
]
