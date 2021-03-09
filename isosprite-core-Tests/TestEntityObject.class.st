"
I am an entity object, which knows about the default names of certain animations for the IsoAnimatedSprite or IsoAggregatedSprite which it has as representation
"
Class {
	#name : #TestEntityObject,
	#superclass : #TestGameObject,
	#category : #'isosprite-core-Tests'
}

{ #category : #initialization }
TestEntityObject >> isEntity [
	^ true
]

{ #category : #initialization }
TestEntityObject >> spriteIdleAnimationName [
	^ 'stance'
]

{ #category : #initialization }
TestEntityObject >> spriteWalkAnimationName [
	^ 'run'
]
