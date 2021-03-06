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
		'moveCallback',
		'incrementCallback'
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

{ #category : #accessing }
IsoAnimatedSprite >> direction: anObject [
	super direction: anObject .
	selectedAnimation direction: anObject 
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
IsoAnimatedSprite >> globalScaleFactor: x [
	super globalScaleFactor: x.
	selectedAnimation ifNotNil: [ selectedAnimation globalScaleFactor: x ].
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
IsoAnimatedSprite >> isAnimated [ 
^ true
]

{ #category : #accessing }
IsoAnimatedSprite >> isSection: row [
	^ (row findString: '[') > 0
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
	"self removeAllMorphs ."
	Transcript
		show:
			'animatedSprite::play (no callback) ' , animationName
			, ' direction ' , direction asString;
		cr.
	animation := animations at: animationName.
	self setSelectedAnimation: animation.
	animation play
]

{ #category : #accessing }
IsoAnimatedSprite >> play: animationName callback: aBlock [

	| animation |
	Transcript
		show: 'animatedSprite::play w callback ' , animationName;
		cr.
	animation := animations at: animationName.
	self setSelectedAnimation: animation.
	animation play: aBlock
]

{ #category : #accessing }
IsoAnimatedSprite >> renderOffset: r [
	super renderOffset: r.
	selectedAnimation ifNotNil: [ 
		"Transcript show:'setting renderOffset for ',name,' animation to',r asString;cr."
		selectedAnimation renderOffset: r ].
]

{ #category : #accessing }
IsoAnimatedSprite >> selectedAnimation [

	^ selectedAnimation 
]

{ #category : #accessing }
IsoAnimatedSprite >> setAnimationProps: animation [
	Transcript
		show:
			'animatedSprite::setAnimationProps ' , animation name
			, ' position ' , self position asString;
		cr.
	animation
		scaleFactor: scaleFactor;
		globalScaleFactor: globalScaleFactor ;
		renderOffset: renderOffset;
		direction: direction;
		position: self position.
]

{ #category : #accessing }
IsoAnimatedSprite >> setSelectedAnimation: animation [
	"Transcript
		show:
			'animatedSprite::setSelectedAnimation ' , animation nameg
			, ' direction ' , direction asString;
		cr."
	selectedAnimation ifNotNil: [ self removeMorph: selectedAnimation ].
	selectedAnimation := animation.
	self setAnimationProps: animation.	
	stepTime := animation animationStepTime.
	self addMorph: selectedAnimation.
	
]

{ #category : #accessing }
IsoAnimatedSprite >> switchSection: row [

	section := row onlyLetters.
	"Transcript show:'--- switching to section ',section,;cr."
	animationDefinitions at: section put: Dictionary new
]

{ #category : #accessing }
IsoAnimatedSprite >> toString [ 
	^ name
]
