"
I am an aggregation of one or more IsoAnimatedSprites. When playing an animation, I make sure to play it simultaneously on all my IsoAnimatedSprites.

I also understand how to hold several version of an animation layer, an dto swap between version.

For example, I can have layers 'head', 'body' and'weapon', each having a number of separate IsoAnimatins each (like 'run','swing', et.c.). 

Each layer can hold one or more versions, so the 'weapon' layer can hold 'dagger', 'longsword', and so on. I can switch version between layers.
"
Class {
	#name : #IsoAggregatedSprite,
	#superclass : #IsoAnimatedSprite,
	#instVars : [
		'layers',
		'selectedAtLayer',
		'anySprite'
	],
	#classInstVars : [
		'cache'
	],
	#category : #'isosprite-core'
}

{ #category : #'as yet unclassified' }
IsoAggregatedSprite class >> flareDefinition [
	self subclassResponsibility 
]

{ #category : #'as yet unclassified' }
IsoAggregatedSprite class >> generate [
	self subclassResponsibility 
]

{ #category : #adding }
IsoAggregatedSprite >> addAnimatedSprite: animatedSprite layer: layerName [

	| layer |
	layer := layers at: layerName ifAbsent: [ Dictionary new ].
	layer at: animatedSprite name put: animatedSprite.
	layers at: layerName put: layer.
	self setSelectSpriteNamed: animatedSprite name forLayer: layerName
]

{ #category : #adding }
IsoAggregatedSprite >> addAnimatedSpriteFromBase64Image: base64img name: n layer: layerName [

	| lbytes img |
	lbytes := base64img base64Decoded.
	img := PNGReadWriter formFromStream: lbytes readStream.
	self addAnimatedSpriteFromImage: img name: n layer: layerName
]

{ #category : #adding }
IsoAggregatedSprite >> addAnimatedSpriteFromImage: img name: n layer: layerName [

	| sprite |
	sprite := IsoAnimatedSprite
		          from: self class flareDefinition
		          image: img.
	sprite
		name: n;
		scaleFactor: scaleFactor;
		renderOffset: renderOffset;
		direction: direction.
	Transcript
		show: 'IsoAggregateSprite::addAnimatedSprieFromImage name = ' , n
			, ' layer = ' , layerName;
		cr.
	self addAnimatedSprite: sprite layer: layerName
]

{ #category : #adding }
IsoAggregatedSprite >> addAnimatedSpriteFromName: n layer: layerName [

	self
		addAnimatedSpriteFromImage: (IsoSprite getImageForSprite: n)
		name: n
		layer: layerName
]

{ #category : #adding }
IsoAggregatedSprite >> directionString: dir [
	dir = 'up' ifTrue: [ self direction: 4].
	dir = 'upleft' ifTrue: [ self direction: 3].
	dir = 'upright' ifTrue: [ self direction: 5].
	dir = 'down' ifTrue: [ self direction: 8].
	dir = 'downleft' ifTrue: [ self direction: 1].
	dir = 'downright' ifTrue: [ self direction: 7].
	dir = 'left' ifTrue: [ self direction: 2].
	dir = 'right' ifTrue: [ self direction: 6]	
]

{ #category : #adding }
IsoAggregatedSprite >> initialize [
	super initialize.
	self color: Color transparent.
	layers := Dictionary new.
	selectedAtLayer := Dictionary new.
	direction := 1.
	scaleFactor := 1@1
]

{ #category : #adding }
IsoAggregatedSprite >> play: animationName [

	self removeAllMorphs.
	selectedAtLayer valuesDo: [ :sprite | 
		self addMorph: sprite.
		"Transcript
		show: '--------------- IsoAggregatedSprite::play ' , animationName,' for sprite ',sprite name,' scaleFactor: ',scaleFactor asString;cr."
		sprite
			direction: direction;
			scaleFactor: scaleFactor ;
			position: self position;
			play: animationName ]
]

{ #category : #adding }
IsoAggregatedSprite >> selectSpriteNamed: spriteName forLayer: layerName [

	selectedAtLayer at: layerName ifAbsent: [ ^nil ]
]

{ #category : #adding }
IsoAggregatedSprite >> setSelectSpriteNamed: spriteName forLayer: layerName [

	| sprite oldSprite |
	oldSprite := self selectSpriteNamed: spriteName forLayer: layerName.
	oldSprite ifNotNil: [ self removeMorph: oldSprite ].
	sprite := (layers at: layerName) at: spriteName.
	selectedAtLayer at: layerName put: sprite.
	anySprite := sprite.
	self addMorph: sprite
]
