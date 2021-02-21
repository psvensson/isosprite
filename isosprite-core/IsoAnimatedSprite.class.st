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
		'selectedAnimation'
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

	super initialize .
	
	animationDefinitions := Dictionary new.
	animations := Dictionary new
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
	Transcript
		show: 'IsoAnimatedSprite::play ' , animationName,' for sprite ',name;
		cr.
	animation := animations at: animationName.
	self setSelectedAnimation: animation.
	animation
		scaleFactor: scaleFactor ;
		direction: direction;
		play
]

{ #category : #accessing }
IsoAnimatedSprite >> setSelectedAnimation: animation [

	selectedAnimation ifNotNil: [ self removeMorph: selectedAnimation ].
	selectedAnimation := animation.
	self addMorph: selectedAnimation
]

{ #category : #accessing }
IsoAnimatedSprite >> switchSection: row [

	section := row onlyLetters.
	"Transcript show:'--- switching to section ',section,;cr."
	animationDefinitions at: section put: Dictionary new
]
