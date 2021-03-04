"
I store metadata for this package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestisospritecoreTests,
	#superclass : #PackageManifest,
	#category : #'isosprite-core-Tests-Manifest'
}

{ #category : #'code-critics' }
ManifestisospritecoreTests class >> ruleLongMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'TestCaveTileSprite class' #generate: #true)) #'2021-03-04T19:39:53.118753+01:00') )
]
