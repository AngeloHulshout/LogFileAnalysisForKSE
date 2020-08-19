Class {
	#name : #BaselineOfLogFileAnalysis,
	#superclass : #Object,
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
