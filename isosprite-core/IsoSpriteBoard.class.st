"
I ama morph which displays sprite in different layers in isomatric projection.

A layer can be 'tiles', another can be 'items', 'mid-air events' or 'entities'.
I take care of animating moving sprites, and can center myself around one specific sprite 
so that I pan all other sprites around it when it is being moved.

I step
"
Class {
	#name : #IsoSpriteBoard,
	#superclass : #Morph,
	#instVars : [
		'cursor',
		'cursorRadius',
		'dataLayers'
	],
	#category : #'isosprite-core'
}

{ #category : #initialization }
IsoSpriteBoard >> addDataLayer: aBlock named: dataLayerName [
	dataLayers at: dataLayerName put: aBlock
]

{ #category : #initialization }
IsoSpriteBoard >> initialize [ 
	super initialize .
	cursor := 0@0.
	cursorRadius := 3.
	dataLayers := Dictionary new.
]
