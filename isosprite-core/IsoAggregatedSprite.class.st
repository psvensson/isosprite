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
		'anySprite',
		'currentAnimationname'
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
	renderOffset := animatedSprite renderOffset.
	"Transcript show:'AggregatedSprite adding animated sprite and taking renderoffset as ',renderOffset asString;cr."
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
		direction: direction.

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
IsoAggregatedSprite >> direction: dir [
	super direction: dir.
	layers keysDo: [ :layerName |
		(selectedAtLayer at: layerName) direction: dir  ]
]

{ #category : #adding }
IsoAggregatedSprite >> globalScaleFactor: x [
	super globalScaleFactor: x.
	layers keysDo: [ :layerName |
		(selectedAtLayer at: layerName) globalScaleFactor: x  ]
]

{ #category : #adding }
IsoAggregatedSprite >> initialize [
	super initialize.
	self color: Color transparent.
	layers := Dictionary new.
	selectedAtLayer := Dictionary new.
	direction := 1.
	scaleFactor := 1@1.
	"self
		borderWidth: 2;
		borderColor: Color yellow"
]

{ #category : #adding }
IsoAggregatedSprite >> play: animationName [

	currentAnimationname := animationName .
	self removeAllMorphs.
	selectedAtLayer valuesDo: [ :sprite | 
		self addMorph: sprite.		
		"Transcript
		show: '--------------- IsoAggregatedSprite::play ' , animationName,' for sprite ',sprite name,' renderOffset: ',renderOffset asString;cr."
		sprite
			"position: self position;"
			direction: direction;
			renderOffset: renderOffset ;
			scaleFactor: scaleFactor ;
			globalScaleFactor: globalScaleFactor ;
			play: animationName ]
]

{ #category : #adding }
IsoAggregatedSprite >> play: animationName callback: aBlock [

	| calls |
	currentAnimationname := animationName.
	self removeAllMorphs.
	calls := selectedAtLayer values size.
	selectedAtLayer valuesDo: [ :sprite | 
		self addMorph: sprite.
		"Transcript
		show: '--------------- IsoAggregatedSprite::play ' , animationName,' for sprite ',sprite name,' renderOffset: ',renderOffset asString;cr."
		sprite
			direction: direction;
			renderOffset: renderOffset;
			scaleFactor: scaleFactor;
			globalScaleFactor: globalScaleFactor;
			play: animationName callback: [ 
				calls := calls - 1.
				calls = 0 ifTrue: [ aBlock value ] ]
		"position: self position;" ]
]

{ #category : #adding }
IsoAggregatedSprite >> renderOffset: r [
	Transcript show:'AggregatedSprite got renderOffset ',r asString;cr.
	super renderOffset: r.
	layers keysDo: [ :layerName |
		(selectedAtLayer at: layerName) renderOffset: r  ]
]

{ #category : #adding }
IsoAggregatedSprite >> selectSpriteForLayer: layerName [

	^ selectedAtLayer at: layerName ifAbsent: [ ^nil ]
]

{ #category : #adding }
IsoAggregatedSprite >> selectedAnimation [ 
	^ selectedAtLayer values first selectedAnimation 
]

{ #category : #adding }
IsoAggregatedSprite >> setSelectSpriteNamed: spriteName forLayer: layerName [

	| sprite oldSprite |
	oldSprite := self selectSpriteForLayer: layerName.
	oldSprite ifNotNil: [ self removeMorph: oldSprite ].
	sprite := (layers at: layerName) at: spriteName.
	selectedAtLayer at: layerName put: sprite.
	self setSelectedAnimation: sprite animations values first.
	anySprite := sprite.
	sprite
		position: self position;
		direction: direction;
		renderOffset: renderOffset;
		scaleFactor: scaleFactor;
		globalScaleFactor: globalScaleFactor.
	currentAnimationname ifNotNil: [ sprite play: currentAnimationname ].
	self addMorph: sprite
]
