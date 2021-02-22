"
I am a Morph who holds an image. I am positioned by the IsoSpriteBoard and I am resposible for resizing and adjusting the image.

I hold a class-side cache which can be asked for new instances of a named sprite. All unique sprites are also registered here by IsoSprite, IsoAnimatedSprite or IsoAggregatedSprite subclasses, so they can be refered to later.

The cache acts as a factory for named types of sprites, like 'floor_tile1', 'floor_tile2', 'hero', 'zombie', et.c. regardless of what kind.
"
Class {
	#name : #IsoSprite,
	#superclass : #Morph,
	#instVars : [
		'renderSize',
		'renderOffset',
		'spritesPerRow',
		'spriteImages',
		'direction',
		'scaleFactor',
		'name',
		'form',
		'tileWidth',
		'tileHeight'
	],
	#classInstVars : [
		'spriteCache',
		'registeredSpriteFactories',
		'imageCache',
		'encodedSprites'
	],
	#category : #'isosprite-core'
}

{ #category : #'class initialization' }
IsoSprite class >> addSpriteLookup: n method: method class: c [

	| cm |
	cm := Dictionary new.
	cm at: #spritemethod put: method.
	cm at: #spriteclass put: c.
	Transcript
		show: 'IsoSprite:.addSpriteLookup: ' , n , ' class ' , c asString
			, ' method ' , method asString;
		cr.
	encodedSprites at: n put: cm
]

{ #category : #'class initialization' }
IsoSprite class >> getImageForSprite: spriteName [

	| bytes |
	^ imageCache at: spriteName ifAbsent: [ 
		  | img classMethod c m |
		  classMethod := encodedSprites at: spriteName.
		  c := classMethod at: #spriteclass.
		  m := classMethod at: #spritemethod.
		  bytes := (c perform: m asSymbol) base64Decoded.
		  img := PNGReadWriter formFromStream: bytes readStream.
		  img ]
]

{ #category : #'class initialization' }
IsoSprite class >> getSpriteFactoryFor: spriteName [
	^ registeredSpriteFactories at: spriteName
]

{ #category : #'class initialization' }
IsoSprite class >> getSpriteFrom: spriteHolder [

	^ spriteCache at: spriteHolder ifAbsent: [ 
		  | factory instance spriteName|
		spriteName := spriteHolder spriteName.
		  factory := self getSpriteFactoryFor: spriteName.
		  instance := factory generate: spriteName.
		  spriteCache at: spriteHolder put: instance.
		  instance ]
]

{ #category : #'class initialization' }
IsoSprite class >> initialize [
	spriteCache := Dictionary new.
	imageCache := Dictionary new.
	encodedSprites := Dictionary new.
	registeredSpriteFactories := Dictionary new.
]

{ #category : #'class initialization' }
IsoSprite class >> registerSpriteFactoryFor: spriteName factory: aBlock [
	registeredSpriteFactories at: spriteName put: aBlock
]

{ #category : #accessing }
IsoSprite >> direction [

	^ direction
]

{ #category : #accessing }
IsoSprite >> direction: anObject [
	
	direction := anObject
]

{ #category : #accessing }
IsoSprite >> form [
	^ form
]

{ #category : #accessing }
IsoSprite >> form: f [
	form ifNotNil: [ self removeMorph: form ].
	form := f.
	self addMorph: f
]

{ #category : #accessing }
IsoSprite >> getTileFrom: img x: x y: y [

	| i startx starty endx endy |
	startx := x * tileWidth.
	starty := y * tileHeight.
	endx := startx + tileWidth.
	endy := starty + tileHeight.

	i := img copy: (startx @ starty corner: endx @ endy).
	^ AlphaImageMorph new image: i
]

{ #category : #accessing }
IsoSprite >> initialize [

	super initialize.
	renderSize := 256 @ 256.
	renderOffset := 0 @ 0.
	scaleFactor := 1@1.
	self color: Color transparent
]

{ #category : #accessing }
IsoSprite >> loadSpriteImage: img spriteWidth: _width spriteHeight: _height spritesPerRow: _spr [

	| index sprites |
	spritesPerRow := _spr.
	sprites := Dictionary new.
	index := 0.
	0 to: img width - _width by: _width do: [ :x | 
		0 to: img height - _height by: _height do: [ :y | 
			| i aMorph |
			i := img copy: (x @ y corner: x + _width @ (y + _height)).
			aMorph := AlphaImageMorph new image: i.
			aMorph resize: renderSize.
			sprites at: index put: aMorph.
			index := index + 1 ] ].
	spriteImages := sprites
]

{ #category : #accessing }
IsoSprite >> name [

	^ name
]

{ #category : #accessing }
IsoSprite >> name: anObject [

	name := anObject
]

{ #category : #accessing }
IsoSprite >> renderOffset [

	^ renderOffset
]

{ #category : #accessing }
IsoSprite >> renderOffset: anObject [

	renderOffset := anObject
]

{ #category : #accessing }
IsoSprite >> renderSize [

	^ renderSize
]

{ #category : #accessing }
IsoSprite >> renderSize: anObject [

	renderSize := anObject
]

{ #category : #accessing }
IsoSprite >> scaleFactor: s [
	scaleFactor := s
]

{ #category : #accessing }
IsoSprite >> tileHeight: h [
	tileHeight := h
]

{ #category : #accessing }
IsoSprite >> tileWidth: w [
	tileWidth:= w
]
