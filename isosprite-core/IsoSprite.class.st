"
I am a Morph who holds an image. I am positioned by the IsoSpriteBoard and I am resposible for resizing and adjusting the image.

I hold a class-side cache which can be asked for new instances of a named sprite. All unique sprites are also registered here by IsoSprite, IsoAnimatedSprite or IsoAggregatedSprite subclasses, so they can be refered to later.

The cache acts as a factory for named types of sprites, like 'floor_tile1', 'floor_tile2', 'hero', 'zombie', et.c. regardless of what kind.
----
How to load png's and store them as base64 encoded strings in methods;

|img writeStream encoded byteArray newImg method|
img := PNGReadWriter formFromStream: 'imagefile.png' asFileReference binaryReadStream.
writeStream := WriteStream on: ByteArray new.
PNGReadWriter putForm: img onStream: writeStream.
encoded := writeStream contents base64Encoded.

""Decode the base64Encoded bytes and display the image""
byteArray := encoded base64Decoded.
newImg := PNGReadWriter formFromStream: byteArray readStream.
newImg asMorph openInHand.

method := (String streamContents: [:s |
    s
        nextPutAll: 'getEncoded';
        nextPut: Character cr;
        nextPut: Character tab;
 			 nextPut: $^;
        nextPut: $';
        nextPutAll: encoded;
        nextPut: $']).
""Add the method to the Sprite subclass""
Human compile: method

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
		'tileHeight',
		'globalScaleFactor',
		'diff'
	],
	#classInstVars : [
		'spriteCache',
		'registeredSpriteFactories',
		'imageCache',
		'encodedSprites',
		'formCache'
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
IsoSprite class >> directionString: dir [

	dir = 'up' ifTrue: [ ^ 4 ].
	dir = 'upleft' ifTrue: [ ^ 3 ].
	dir = 'upright' ifTrue: [ ^ 5 ].
	dir = 'down' ifTrue: [ ^ 8 ].
	dir = 'downleft' ifTrue: [ ^ 1 ].
	dir = 'downright' ifTrue: [ ^ 7 ].
	dir = 'left' ifTrue: [ ^ 2 ].
	dir = 'right' ifTrue: [ ^ 6 ]
]

{ #category : #'class initialization' }
IsoSprite class >> getDeltaForDirectionValue: v [

	| x y |
	x := 0.
	y := 0.
	v = 1 ifTrue: [ 
		x := -1.
		y := 1 ].
	v = 2 ifTrue: [ x := -1 ].
	v = 3 ifTrue: [ 
		x := -1.
		y := -1 ].
	v = 4 ifTrue: [ y := -1 ].
	v = 5 ifTrue: [ 
		x := 1.
		y := -1 ].
	v = 6 ifTrue: [ x := 1 ].
	v = 7 ifTrue: [ 
		x := 1.
		y := 1 ].
	v = 8 ifTrue: [ y := 1 ].
	^ x @ y
]

{ #category : #'class initialization' }
IsoSprite class >> getFormFrom: tilename height: tileHeight width: tileWidth x: x y: y img: img [

	| f lookup i startx starty endx endy |
	lookup := img asString , '_' , x asString , '_' , y asString.
	f := formCache at: lookup ifAbsent: [ 
		  | form |
		  startx := x * tileWidth.
		  starty := y * tileHeight.
		  endx := startx + tileWidth.
		  endy := starty + tileHeight.

		  i := img copy: (startx @ starty corner: endx @ endy).
		  form := AlphaImageMorph new image: i.
		  formCache at: lookup put: form.
		  form ].
	^ f copy
]

{ #category : #'class initialization' }
IsoSprite class >> getImageForSprite: spriteName [

	| bytes |
	^ imageCache at: spriteName ifAbsent: [ 
		  | img classMethod c m |
		  Transcript
			  show: 'IsoSprite::getImageForSprite cache miss for ' , spriteName;
			  cr.
		  classMethod := encodedSprites at: spriteName.
		  c := classMethod at: #spriteclass.
		  m := classMethod at: #spritemethod.
		  bytes := (c perform: m asSymbol) base64Decoded.
		  img := PNGReadWriter formFromStream: bytes readStream.
		  imageCache at: spriteName put: img.
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
		spriteName := spriteHolder name.
		  factory := self getSpriteFactoryFor: spriteName.
		  instance := factory generate: spriteName.
		  spriteCache at: spriteHolder put: instance.
		  instance ]
]

{ #category : #'class initialization' }
IsoSprite class >> getTargetForDirectionString: dir position: pos [
	| x y |
	x := pos x.
	y := pos y.
	(dir findString: 'up') > 0
		ifTrue: [ y := y - 1 ].
	(dir findString: 'down') > 0
		ifTrue: [ y := y + 1 ].
	(dir findString: 'left') > 0
		ifTrue: [ x := x - 1 ].
	(dir findString: 'right') > 0
		ifTrue: [ x := x + 1 ].
	^ x @ y
]

{ #category : #'class initialization' }
IsoSprite class >> getTargetForDirectionValue: v position: pos [
	| x y |
	x := pos x.
	y := pos y.
	v = 1	ifTrue: [ x := x - 1.y := y + 1 ].
	v = 2	ifTrue: [ x := x - 1. ].
	v = 3	ifTrue: [ x := x - 1.y := y - 1 ].
	v = 4	ifTrue: [ y := y + 1 ].
	v = 5	ifTrue: [ x := x + 1.y := y - 1 ].
	v = 6	ifTrue: [ x := x + 1. ].
	v = 7	ifTrue: [ x := x + 1.y := y + 1 ].
	v = 8	ifTrue: [ y := y + 1 ].	
	
	^ x @ y
]

{ #category : #'class initialization' }
IsoSprite class >> initialize [
	spriteCache := Dictionary new.
	imageCache := Dictionary new.
	formCache := Dictionary new.
	encodedSprites := Dictionary new.
	registeredSpriteFactories := Dictionary new.
]

{ #category : #'class initialization' }
IsoSprite class >> registerSpriteFactoryFor: spriteName factory: aBlock [
	registeredSpriteFactories at: spriteName put: aBlock
]

{ #category : #accessing }
IsoSprite >> diff [
	^ diff
]

{ #category : #accessing }
IsoSprite >> diff: d [
	diff:= d
]

{ #category : #accessing }
IsoSprite >> direction [

	^ direction
]

{ #category : #accessing }
IsoSprite >> direction: anObject [
	
	direction := anObject
]

{ #category : #adding }
IsoSprite >> directionString: dir [
	dir = 'up' ifTrue: [ self direction: 4].
	dir = 'upleft' ifTrue: [ self direction: 3].
	dir = 'upright' ifTrue: [ self direction: 5].
	dir = 'down' ifTrue: [ self direction: 8].
	dir = 'downleft' ifTrue: [ self direction: 1].
	dir = 'downright' ifTrue: [ self direction: 7].
	dir = 'left' ifTrue: [ self direction: 2].
	dir = 'right' ifTrue: [ self direction: 6]	
]

{ #category : #accessing }
IsoSprite >> form [
	^ form
]

{ #category : #accessing }
IsoSprite >> form: f [

	| isoimage |
	isoimage := IsoImage new.
	isoimage
		scaleFactor: scaleFactor ;
		renderSize: renderSize ;
		renderOffset: renderOffset;
		form: f.
	self addMorph: isoimage
]

{ #category : #accessing }
IsoSprite >> getTileFrom: img x: x y: y [

	^ IsoSprite
		  getFormFrom: name
		  height: tileHeight
		  width: tileWidth
		  x: x
		  y: y
		  img: img
]

{ #category : #accessing }
IsoSprite >> globalScaleFactor: x [
	globalScaleFactor := x
]

{ #category : #accessing }
IsoSprite >> initialize [

	super initialize.
	renderSize := 256 @ 256.
	renderOffset := 0 @ 0.
	scaleFactor := 1@1.
	self color: Color transparent.
	globalScaleFactor := 1@1.
	diff := 0@0.
	"self
		borderWidth: 2;
		borderColor: Color orange"
]

{ #category : #accessing }
IsoSprite >> isAnimated [ 
^ false
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
			"TODO: Here is 45% of all CPU during initialization"
			"Create a class cache for images for a given resize"
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

{ #category : #accessing }
IsoSprite >> toString [
	^ name
]
