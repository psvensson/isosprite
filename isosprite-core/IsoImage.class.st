"
I hold a fomr/image to disaply as a sprite. I understand how to resize and adjust my image, as well as add transparency.
"
Class {
	#name : #IsoImage,
	#superclass : #Morph,
	#instVars : [
		'adjustment',
		'scaleFactor',
		'transparency',
		'renderSize',
		'renderOffset',
		'globalScaleFactor',
		'form'
	],
	#category : #'isosprite-core'
}

{ #category : #accessing }
IsoImage >> adjustment [

	^ adjustment
]

{ #category : #accessing }
IsoImage >> adjustment: anObject [

	adjustment := anObject
]

{ #category : #accessing }
IsoImage >> form: f [
	form ifNotNil: [ self removeMorph: form ].
	form := f.
	"Transcript show:'IsoImage form ',form asString,' has renderOffset ',renderOffset asString;cr."
	form position: self position -  renderOffset.
	self resizecurrentImage .
	self addMorph: form
]

{ #category : #accessing }
IsoImage >> globalScaleFactor: anObject [

	globalScaleFactor := anObject
]

{ #category : #accessing }
IsoImage >> initialize [ 
	super initialize .
	self color: Color transparent .
	renderSize := 128@128.
	renderOffset := 0@0.
	scaleFactor := 2.
	globalScaleFactor := 1@1.
	transparency := 1.0
]

{ #category : #accessing }
IsoImage >> position: p [
	super position: p.
	self resizecurrentImage 
]

{ #category : #accessing }
IsoImage >> renderOffset: r [
	renderOffset := r
]

{ #category : #accessing }
IsoImage >> renderSize: r [
	renderSize := r
]

{ #category : #accessing }
IsoImage >> resizeImageToScale: image [
	| resize |
	resize := globalScaleFactor * scaleFactor * renderSize .
	^ image copy resize: resize; alpha: transparency 
]

{ #category : #accessing }
IsoImage >> resizecurrentImage [

	| resize |
	form ifNotNil: [ 
		
		form := self resizeImageToScale: form]
]

{ #category : #accessing }
IsoImage >> scaleFactor: anObject [

	scaleFactor := anObject
]

{ #category : #accessing }
IsoImage >> transparency [

	^ transparency
]

{ #category : #accessing }
IsoImage >> transparency: a [
	transparency := a.
	form alpha: a
]
