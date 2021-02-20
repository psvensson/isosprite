"
I am a Morph who holds an image. I am positioned by the IsoSpriteBoard and I am resposible for resizing and adjusting the image.
"
Class {
	#name : #IsoSprite,
	#superclass : #Morph,
	#instVars : [
		'renderSize',
		'renderOffset',
		'spritesPerRow',
		'spriteImages'
	],
	#category : #'isosprite-core'
}

{ #category : #accessing }
IsoSprite >> initialize [
	super initialize .
	renderSize := 256@256.
	renderOffset := 0@0
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
