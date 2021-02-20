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
		'currentFrame'
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
	currentFrame := image.
]

{ #category : #accessing }
IsoAnimatedImage >> addFramesFrom: start to: end [

	index := 1.
	start to: end do: [ :frame | 
		| dir |
		dir := 1.
		(self getSpriteImagesColumn: frame) do: [ :img | 
			self addFrame: index direction: dir image: img.
			dir := dir + 1 ].
		index := index + 1 ]
]

{ #category : #accessing }
IsoAnimatedImage >> duration: d [
	duration:= d
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
	frames := Dictionary new
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

{ #category : #accessing }
IsoAnimatedImage >> type: t [
	type := t
]
