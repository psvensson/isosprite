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
		'renderOffset'
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
IsoImage >> initialize [ 
	super initialize .
	renderSize := 128@128.
	renderOffset := 0@0.
	scaleFactor := 2.
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
IsoImage >> scaleFactor: anObject [

	scaleFactor := anObject
]

{ #category : #accessing }
IsoImage >> transparency [

	^ transparency
]

{ #category : #accessing }
IsoImage >> transparency: anObject [

	transparency := anObject
]
