Class {
	#name : #TestEntityObject,
	#superclass : #TestGameObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #initialization }
TestEntityObject >> spriteIdleAnimationName [
	^ 'stance'
]

{ #category : #initialization }
TestEntityObject >> spriteWalkAnimationName [
	^ 'run'
]
