"
I am a sprite which holds one or more ISOAnimations. 
"
Class {
	#name : #IsoAnimatedSprite,
	#superclass : #IsoSprite,
	#instVars : [
		'image',
		'section',
		'animationDefinitions',
		'animations',
		'selectedAnimation',
		'stepTime',
		'stepIncrement',
		'moveDirection',
		'moveSteps',
		'moveCallback'
	],
	#category : #'isosprite-core'
}

{ #category : #'instance creation' }
IsoAnimatedSprite class >> from: flareSpriteDefinition image: img [

	| instance |
	instance := self new.
	instance
		image: img;
		parse: flareSpriteDefinition.
	"add animated sprite somehow"
	^ instance
]

{ #category : #accessing }
IsoAnimatedSprite >> animations [

	^ animations
]

{ #category : #accessing }
IsoAnimatedSprite >> animations: anObject [

	animations := anObject
]

{ #category : #generating }
IsoAnimatedSprite >> generateAnimationsFromDefinition [

	animationDefinitions keysAndValuesDo: [ :n :values | 
		| animation |
		animation := IsoAnimatedImage
			             fromFlareDefinition: values
			             images: spriteImages
			             spritesPerRow: spritesPerRow.
		animation
			name: n;
			renderSize: renderSize;
			renderOffset: renderOffset.
		"Transcript show:'IsoAnimatedSprite::generateAnimationFromDefintion: ',n;cr."
		animations at: n put: animation.
		self setSelectedAnimation: animation ]
]

{ #category : #accessing }
IsoAnimatedSprite >> image [

	^ image
]

{ #category : #accessing }
IsoAnimatedSprite >> image: anObject [

	image := anObject
]

{ #category : #accessing }
IsoAnimatedSprite >> initialize [

	super initialize.
	direction := 1.
	scaleFactor := 1 @ 1.
	animationDefinitions := Dictionary new.
	animations := Dictionary new.
	"self
		borderWidth: 2;
		borderColor: Color blue"
]

{ #category : #accessing }
IsoAnimatedSprite >> isSection: row [
	^ (row findString: '[') > 0
]

{ #category : #accessing }
IsoAnimatedSprite >> move: dir moveCallback: aBlock [
	moveCallback := aBlock.
	moveSteps := selectedAnimation frames size.
	stepIncrement := (1 / moveSteps) * 64.	
	Transcript
		show: 'IsoAnimatedSprite move for ' , self asString , ' direction '
			, dir asString , ' start position: ' , self position asString;
		cr.
	direction := dir.
	moveDirection := IsoSprite getDeltaForDirectionValue: dir.
	self startStepping
]

{ #category : #accessing }
IsoAnimatedSprite >> parse: aDefinition [

	| rows |
	rows := aDefinition substrings: String crlf.
	rows do: [ :row | self parseRow: row ].
	"animatedSprite setEncoded: (self class base64EncodeFromImage: image)."
	self
		renderOffset: renderOffset;
		renderSize: renderSize.

	self
		loadSpriteImage: image
		spriteWidth: renderSize x
		spriteHeight: renderSize y
		spritesPerRow: 32.
	self generateAnimationsFromDefinition
]

{ #category : #accessing }
IsoAnimatedSprite >> parseGlobalKeyValue: kv [

	kv first trim = 'image' ifTrue: [ image := kv last ].
	kv first trim = 'render_size' ifTrue: [ renderSize := (self parsePoint: kv last) ].
	kv first trim = 'render_offset' ifTrue: [ renderOffset := (self parsePoint: kv last) ]
]

{ #category : #accessing }
IsoAnimatedSprite >> parsePoint: pointString [

	| values |
	values := pointString substrings: ','.
	^ (values first asNumber ) @ (values last asNumber )
]

{ #category : #accessing }
IsoAnimatedSprite >> parseRow: row [

	(self isSection: row)
		ifTrue: [ self switchSection: row ]
		ifFalse: [ self parsekeyValuesFrom: row ]
]

{ #category : #accessing }
IsoAnimatedSprite >> parsekeyValuesFrom: row [

	| kv animationDefinition |
	kv := row substrings: '='.
	section ifNil: [ self parseGlobalKeyValue: kv ] ifNotNil: [ 
		"Transcript show:'   parseKeyValues ',kv first,' -> ',kv last;cr."
		animationDefinition := animationDefinitions at: section.
		animationDefinition at: kv first put: kv last ]
]

{ #category : #accessing }
IsoAnimatedSprite >> play: animationName [

	| animation |
	animation := animations at: animationName.
	self setSelectedAnimation: animation.
	animation
		scaleFactor: scaleFactor;
		renderOffset: renderOffset;
		direction: direction;
		position: self position;
		play
]

{ #category : #accessing }
IsoAnimatedSprite >> setSelectedAnimation: animation [
	"Transcript show:'IsoAnimatedSprite::setSelectedAnimation for ',animation asString;cr."
	selectedAnimation ifNotNil: [ self removeMorph: selectedAnimation ].
	selectedAnimation := animation.
	self addMorph: selectedAnimation.
	stepTime := animation animationStepTime .
	
]

{ #category : #accessing }
IsoAnimatedSprite >> step [

	moveDirection ifNotNil: [ 
		self position: self position + (moveDirection * stepIncrement).
		Transcript
			show: 'sprite position = ' , self position asString;
			cr.
		moveSteps := moveSteps - 1.
		moveSteps = 0 ifTrue: [ 
			self stopStepping.
			moveCallback value ] ]
]

{ #category : #accessing }
IsoAnimatedSprite >> stepTime [
	^ stepTime
]

{ #category : #accessing }
IsoAnimatedSprite >> switchSection: row [

	section := row onlyLetters.
	"Transcript show:'--- switching to section ',section,;cr."
	animationDefinitions at: section put: Dictionary new
]
