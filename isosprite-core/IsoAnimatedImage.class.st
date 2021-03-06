"
I am a named sequence of images, an animatioon.

I know how to create myself from a Flare spritesheet and a Flare spritedefinition.

I step myself and have different way to animat 'play_once', 'loop',' and 'back_forht' animation types.
"
Class {
	#name : #IsoAnimatedImage,
	#superclass : #IsoImage,
	#instVars : [
		'duration',
		'type',
		'index',
		'spriteImages',
		'spritesPerRow',
		'frames',
		'currentFrame',
		'frame',
		'direction',
		'playDirection',
		'name',
		'callback'
	],
	#category : #'isosprite-core'
}

{ #category : #'instance creation' }
IsoAnimatedImage class >> fromFlareDefinition: def images: imgs spritesPerRow: spr [

	| instance start end |
	instance := self new.

	start := (def at: 'position') asNumber.
	end := start + (def at: 'frames') asNumber - 1.
	instance
		spritesPerRow: spr;
		spriteImages: imgs;
		duration: (self getDurationFor: def);
		type: (def at: 'type');
		addFramesFrom: start to: end.
	^ instance
]

{ #category : #'instance creation' }
IsoAnimatedImage class >> getDurationFor: values [
	| valueString valueArr |
	valueString := values at: 'duration'.
	valueArr := valueString substrings: 'ms'.
	"Transcript show:'valueArr for ',valueString,' is ',valueArr asString;cr."
	^ valueArr first asNumber 
]

{ #category : #accessing }
IsoAnimatedImage >> addFrame: frameNo direction: dir image: image [
	| framelist |
	framelist := frames at: frameNo ifAbsent: [ Dictionary new ].	
	framelist at: dir put: image.	
	frames at: frameNo put: framelist.
	
]

{ #category : #accessing }
IsoAnimatedImage >> addFramesFrom: start to: end [

	index := 1.
	start to: end do: [ :f | 
		| dir |
		dir := 1.
		(self getSpriteImagesColumn: f) do: [ :img | 
			self addFrame: index direction: dir image: img.
			dir := dir + 1 ].
		index := index + 1 ].
	self setCurrentFrame: (frames values last) values first.
]

{ #category : #accessing }
IsoAnimatedImage >> animationStepTime [
	^ (duration / frames size) asInteger 
]

{ #category : #accessing }
IsoAnimatedImage >> direction [

	^ direction
]

{ #category : #accessing }
IsoAnimatedImage >> direction: anObject [

	direction := anObject
]

{ #category : #accessing }
IsoAnimatedImage >> duration: d [
	duration:= d
]

{ #category : #accessing }
IsoAnimatedImage >> frames [

	^ frames
]

{ #category : #accessing }
IsoAnimatedImage >> getSpriteImagesColumn: c [
	^ (1 to: 8) collect: [ :i | 
		  | col row |
		  col := (c) * 8.
		  row := i .
		  spriteImages at: (row + col) -1 ]
]

{ #category : #initialization }
IsoAnimatedImage >> initialize [
	super initialize .
	self color: Color transparent .
	frames := Dictionary new.
	frame := 1.
	direction := 1.
	playDirection := 1.
	"self
		borderWidth: 2;
		borderColor: Color blue"
]

{ #category : #accessing }
IsoAnimatedImage >> name [
	^ name
]

{ #category : #accessing }
IsoAnimatedImage >> name: n [
	name := n
]

{ #category : #accessing }
IsoAnimatedImage >> play [

	"Transcript show:'IsoAnimatedImage::play (no callback)) ',name,' scaleFactor ',scaleFactor asString;cr."

	self startStepping
]

{ #category : #accessing }
IsoAnimatedImage >> play: aBlock [
	callback := aBlock.
	Transcript show:'IsoAnimatedImage::play ',name,' scaleFactor ',type;cr.

	self startStepping
]

{ #category : #accessing }
IsoAnimatedImage >> playLooped [

	frame := frame + 1.
	"Transcript
		show: 'playLooped drawing frame ' , frame asString;
		cr."
	frame > frames size ifTrue: [ frame := 1 ]
]

{ #category : #accessing }
IsoAnimatedImage >> playOnce [

	frame := frame + 1.
	Transcript show:'----- playOnce drawing animation ',name,' once -> frame ',frame asString;cr.
	frame > frames size ifFalse: [ ^ self ].
	frame := 1.
	self stopStepping.
	callback ifNotNil: [ 
		callback value.
		callback := nil ]
]

{ #category : #accessing }
IsoAnimatedImage >> playbackAndForth [

	(frame + playDirection > frames size or: [ frame + playDirection < 1 ]) 
		ifTrue: [ 
			playDirection := playDirection negated.
			^ self ].
	frame := frame + playDirection
]

{ #category : #accessing }
IsoAnimatedImage >> position: p [
	super position: p.
	"currentFrame position: p"
]

{ #category : #accessing }
IsoAnimatedImage >> setCurrentFrame: image [
	| resizedImage |
	currentFrame ifNotNil: [ self removeMorph: currentFrame ].
	"self removeAllMorphs."
	resizedImage := self resizeImageToScale: image.
	resizedImage position: self position - renderOffset.
	currentFrame := resizedImage.
	"Transcript
		show: 'IsoAnimatedSprite::setCurrentFrame ' , currentFrame asString;
		cr."
	"currentFrame position: self position."
	self addMorph: currentFrame
]

{ #category : #accessing }
IsoAnimatedImage >> spriteImages [

	^ spriteImages
]

{ #category : #accessing }
IsoAnimatedImage >> spriteImages: anObject [

	spriteImages := anObject
]

{ #category : #accessing }
IsoAnimatedImage >> spritesPerRow [

	^ spritesPerRow
]

{ #category : #accessing }
IsoAnimatedImage >> spritesPerRow: anObject [

	spritesPerRow := anObject
]

{ #category : #'stepping and presenter' }
IsoAnimatedImage >> step [
	| aFrame directionFrames |
	directionFrames := frames at: frame.
	aFrame := directionFrames at: direction.
	self setCurrentFrame: aFrame.
	type = 'play_once'
		ifTrue: [ self playOnce ].
	type = 'looped'
		ifTrue: [ self playLooped ].
	type = 'back_forth'
		ifTrue: [ self playbackAndForth ]
]

{ #category : #accessing }
IsoAnimatedImage >> stepTime [
	^ self animationStepTime
]

{ #category : #accessing }
IsoAnimatedImage >> type: t [
	type := t
]
