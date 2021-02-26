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
		'stepTime',
		'animationEvents',
		'keyboardHandler'
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
IsoSpriteBoard >> addAnimationEvent: e [
	animationEvents add: e.
	self startStepping.
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
	"StepTime taken from the run animation of the hero flare definition"
	stepTime := (533 / 8) asInteger. 
	animationEvents := OrderedCollection new.
	self
		color: Color transparent ;
		borderWidth: 2;
		borderColor: Color green;
		cursorRadius: 2.
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
IsoSpriteBoard >> move: gameObject direction: direction [

	| animationEvent |
	Transcript
		show:
			'board move ' , gameObject asString , ' dir ' , direction asString,' start boardPosition ;',gameObject boardPosition asString;
		cr.
	animationEvent := Dictionary new.
	gameObject sprite
		direction: direction;
		play: gameObject spriteWalkAnimationName.
	animationEvent
		at: #object put: gameObject;
		at: #count put: 8;
		at: #delta
		put: (IsoSprite getDeltaForDirectionValue: direction) * 0.12.
	self addAnimationEvent: animationEvent
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
		self positionIsometricSprite: object .
		self addMorph: object sprite  ]
]

{ #category : #initialization }
IsoSpriteBoard >> positionIsometricSprite: object [ 

	| boardPosition midPoint normalizedBoardPosition spritePosition sprite |
	boardPosition := object boardPosition .
	midPoint := self extent x / 3 @ (self extent y / 2).
	sprite := object sprite.
	normalizedBoardPosition := boardPosition - cursor.
	spritePosition := normalizedBoardPosition .
	isoSpritePosition := self class toISO: spritePosition * tileSize .
	Transcript show:'positionIsometricSprite for boardPos ',boardPosition asString,' pos = ',(isoSpritePosition + midPoint) asString;cr.
	sprite position: isoSpritePosition + midPoint.
	
]

{ #category : #initialization }
IsoSpriteBoard >> runAnimationEvent: evt [

	| object count delta |
	object := evt at: #object.
	count := evt at: #count.
	count := count - 1.
	evt at: #count put: count.
	delta := evt at: #delta.
	Transcript show: 'running animation event for ' , object asString , ' count = ', count asString;cr.
	object boardPosition: object boardPosition + delta .
	self positionIsometricSprite: object.
	count > 0 ifFalse: [ "object sprite play: object spriteIdleAnimationName" ].
	^ count > 0
]

{ #category : #initialization }
IsoSpriteBoard >> runAnimationEvents [
	animationEvents := animationEvents select: [ :evt | self runAnimationEvent: evt ].
]

{ #category : #initialization }
IsoSpriteBoard >> step [
	self runAnimationEvents.
	animationEvents size = 0 ifTrue: [ self stopStepping  ]
]

{ #category : #initialization }
IsoSpriteBoard >> stepTime [ 
	^ stepTime 
]
