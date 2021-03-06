Class {
	#name : #IsoSpriteBoardAnimation,
	#superclass : #Object,
	#instVars : [
		'object',
		'moveSteps',
		'stepIncrement',
		'moveDirection',
		'directionIncrement',
		'currentStep',
		'sprite',
		'callback'
	],
	#category : #'isosprite-core'
}

{ #category : #'as yet unclassified' }
IsoSpriteBoardAnimation >> gameObject: obj direction: direction [

	object := obj.
	sprite := object sprite.
	currentStep := 0.
	moveSteps := sprite selectedAnimation frames size.
	stepIncrement := 1 / moveSteps * IsoSpriteBoard tileSize.
	moveDirection := IsoSprite getDeltaForDirectionValue: direction.
	directionIncrement := moveDirection * stepIncrement.
	sprite
		direction: direction;
		play: object spriteWalkAnimationName.
	
	
]

{ #category : #'as yet unclassified' }
IsoSpriteBoardAnimation >> gameObject: obj direction: direction callback: aBlock [
	callback := aBlock.
	object := obj.
	sprite := object sprite.
	currentStep := 0.
	moveSteps := sprite selectedAnimation frames size.
	stepIncrement := 1 / moveSteps * IsoSpriteBoard tileSize.
	moveDirection := IsoSprite getDeltaForDirectionValue: direction.
	directionIncrement := moveDirection * stepIncrement.
	sprite
		direction: direction;
		play: object spriteWalkAnimationName
]

{ #category : #'as yet unclassified' }
IsoSpriteBoardAnimation >> move [
	| notDone d |
	d := directionIncrement * (moveSteps - currentStep).
	currentStep := currentStep + 1.
	sprite diff: d.
	notDone := currentStep < moveSteps.
	Transcript
		show:
			'move ' , sprite asString , ' currentStep = ' , currentStep asString
				, ' moveSteps = ' , moveSteps asString , ' dirctionIncrement = '
				, directionIncrement asString , ' diff = ' , d asString;
		cr.
	notDone
		ifFalse: [ sprite play: object spriteIdleAnimationName ]
		ifTrue: [ callback value ].
	^ notDone
]
