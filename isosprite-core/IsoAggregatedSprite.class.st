"
I am an aggregation of one or more IsoAnimatedSprites. When playing an animation, I make sure to play it simultaneously on all my IsoAnimatedSprites.

I also understand how to hold several version of an animation layer, an dto swap between version.

For example, I can have layers 'head', 'body' and'weapon', each having a number of separate IsoAnimatins each (like 'run','swing', et.c.). 

Each layer can hold one or more versions, so the 'weapon' layer can hold 'dagger', 'longsword', and so on. I can switch version between layers.
"
Class {
	#name : #IsoAggregatedSprite,
	#superclass : #IsoAnimatedSprite,
	#category : #'isosprite-core'
}
