Class {
	#name : #BaselineOfLogFileAnalysis,
	#superclass : #BaselineOf,
	#category : #BaselineOfLogFileAnalysis
}

{ #category : #accessing }
BaselineOfLogFileAnalysis >> baseline: spec [

	<baseline>
	spec
		for: #common
		do: [
			spec package: 'LogFileAnalysis']
]
