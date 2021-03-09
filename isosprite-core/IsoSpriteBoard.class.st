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
		'isoSpritePosition',
		'dataStore',
		'dataQuery',
		'keyboardHandler',
		'globalScaleFactor',
		'animations',
		'followEntity'
	],
	#category : #'isosprite-core'
}

{ #category : #'as yet unclassified' }
IsoSpriteBoard class >> tileSize [ 
	^ 64.
]

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
	side := 3 + (4 * cursorRadius) * self class tileSize.
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
IsoSpriteBoard >> followEntity: entity [
	followEntity := entity
]

{ #category : #initialization }
IsoSpriteBoard >> getEndCoord [
	^ cursor + (cursorRadius@cursorRadius )
]

{ #category : #initialization }
IsoSpriteBoard >> getScaledSpritePositionFrom: boardPosition [
	| midPoint normalizedBoardPosition spriteBoardPosition |
	midPoint := self extent x / 3 @ (self extent y / 2).
	normalizedBoardPosition := boardPosition - cursor.
	spriteBoardPosition := normalizedBoardPosition.
	^ spriteBoardPosition * self class tileSize .
]

{ #category : #initialization }
IsoSpriteBoard >> getSpriteInFrontOf: boardPosition direction: dir [

	| diff frontStack |
	dir = 2 ifTrue: [ diff := 0 @ 1 ].
	dir = 3 ifTrue: [ diff := 0 @ 1 ].
	dir = 4 ifTrue: [ diff := 1 @ 0 ].
	dir = 5 ifTrue: [ diff := 1 @ 0 ].
	dir = 6 ifTrue: [ diff := 0 @ 1 ].
	dir = 7 ifTrue: [ diff := 1 @ 0 ].
	dir = 8 ifTrue: [ diff := 1 @ 0 ].
	frontStack := dataQuery value: boardPosition + diff.
	frontStack size > 0
		ifTrue: [ ^ frontStack first sprite ]
		ifFalse: [ ^ nil ]
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
	globalScaleFactor := 2 @ 2.
	self
		color: Color black;
		borderWidth: 2;
		borderColor: Color green;
		cursorRadius: 3.
	animations := OrderedCollection new.	
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
	| anim |
	anim := IsoSpriteBoardAnimation new.
	anim
		gameObject: gameObject
		direction: direction
		callback: [ gameObject = followEntity
				ifTrue: [ cursor := gameObject boardPosition.
					self paint ] ].
	animations add: anim.
	self isStepping
		ifFalse: [ self startStepping ]
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
		"Transcript show: 'IsoSpriteBoard::paintTileStack adding sprite ',object sprite asString;cr."
		self removeMorph: object sprite.
		self positionIsometricObject: object .		
		self addMorph: object sprite  ]
]

{ #category : #initialization }
IsoSpriteBoard >> positionIsometricObject: object [

	| boardPosition |
	boardPosition := object boardPosition.
	self transparentIfInFrontOfEntity: object.
	self positionSprite: object sprite from: boardPosition withDiff: object sprite diff
]

{ #category : #initialization }
IsoSpriteBoard >> positionSprite: sprite from: boardPosition withDiff: diff [

	| spritePosition totalSpritePosition |
	"Transcript show:'positionSprite ',sprite asString ,' diff = ',diff asString;cr."
	spritePosition := self getScaledSpritePositionFrom: boardPosition.	
	isoSpritePosition := self class toISO: spritePosition - diff.
	totalSpritePosition := isoSpritePosition + self center.

	sprite
		globalScaleFactor: globalScaleFactor;
		position: totalSpritePosition.
	self addMorph: sprite
]

{ #category : #'stepping and presenter' }
IsoSpriteBoard >> step [
	self removeAllMorphs .
	animations := animations select: [ :anim | anim move ].
	(animations size = 0) ifTrue: [ self stopStepping ].
	self paint
]

{ #category : #stepping }
IsoSpriteBoard >> stepTime [
	^ 67
]

{ #category : #initialization }
IsoSpriteBoard >> transparentIfInFrontOfEntity: object [
	| stack1 stack2 entities image |
	image := object sprite isoimage.
	image ifNotNil: [image transparency: 1.0 ].
	object isEntity ifTrue: [ ^self ].
	stack1 := dataQuery value: object boardPosition + (-1@(-1)).
	stack2 := dataQuery value: object boardPosition + (-1@(-0)).
	entities := stack1,stack2 select: [ :obj | obj isEntity ].
	entities isEmpty ifFalse: [ 
		| entity |
		entity := entities first.
		Transcript show:'-- sprite ',object asString,' is in front of entity ',entity  asString;cr.
		image transparency: 0.5 ]
	
	
]
