Class {
	#name : #LogFileAnalysis,
	#superclass : #Object,
	#instVars : [
		'fileName',
		'log_coll'
	],
	#category : #LogFileAnalysis
}

{ #category : #accessing }
LogFileAnalysis >> calculateProportioningTimes: for [
	"Calculate proportioning times for order(s) containing given string 'for' in the Batch Nm"
	| props size times |
	props := self proportioningEntries:for.
	size := props size.
	times := OrderedCollection new.
	2 to: size do:
		[:counter | times add: ((props at: counter) at: 2) - ((props at: counter - 1) at:2).].
	^ times
]

{ #category : #accessing }
LogFileAnalysis >> filename: nm [
	"Set filename for logfile to analyse"
	fileName := nm
]

{ #category : #accessing }
LogFileAnalysis >> getProportionedBL01Orders [
	"Get unique Batch Nm for BL01"
	| s props size |
	s := Set new.
	props := self proportioningEntries: 'BL01'.
	size := props size.
	1 to: size do:
		[:counter | s add: ((((props at: counter) at: 5) value) truncateTo: 7)].
	^ s
]

{ #category : #accessing }
LogFileAnalysis >> parse [
	"Parse log file to OrderedCollection of entries"
	| string year month day hour minute second date time dateAndTime channel begin end pair entry log |
	string := fileName asFileReference contents.
	year := (#digit asPParser times: 4) flatten ==> #asNumber.
	month := (#digit asPParser times: 2) flatten ==> #asNumber.
	day := (#digit asPParser times: 2) flatten ==> #asNumber.
	hour := (#digit asPParser times: 2) flatten ==> #asNumber.
	minute := (#digit asPParser times: 2) flatten ==> #asNumber.
	second := (#digit asPParser times: 2) flatten ==> #asNumber.
	date := year, '-' asPParser, month, '-' asPParser, day ==> [:t | {t first . t third . t fifth}].
	time := hour, ':' asPParser, minute, ':' asPParser, second  ==> [:t | {t first . t third . t fifth}].
	dateAndTime := date, String space asPParser, time ==> [:t | DateAndTime year: t first first month: t first second day: t first third hour: t last first minute: t last second second: t last third].
	channel := ' [' asPParser , (#digit asPParser plus flatten ==> #asNumber) , ']' asPParser, ' @C#: ' asPParser 
	==> #second.
	begin := '----- BEGIN' asPParser , '-----' asPParser negate star flatten, '-----' asPParser, #newline asPParser ==> #second.
	end := '----- END' asPParser, '-----' asPParser negate star, '-----' asPParser.
	pair := (end / ':' asPParser) negate plus flatten, ': ' asPParser, #endOfLine asPParser negate star flatten, #newline asPParser
	==> [:t | t first  -> t third ].
	entry := dateAndTime, channel, begin, pair plus, end 
	==> [:t | OrderedCollection new 
	add: t third;
	add: t first; 
	add: t second;
	addAll: t fourth;
	yourself ].
	log := (entry sea ==> #second) plus optimize.
	log_coll := log parse: string.


]

{ #category : #accessing }
LogFileAnalysis >> proportioningEntries: for [ 
	"Return list of proportioning entries for order(s) containgin given string 'for' in the Batch Nm"
	| props |
	props := log_coll select: [:each| (each at: 1) = ' Create Proportioning ' and: [(each at: 5) value includesSubstring: for]].
	^ props
]

{ #category : #accessing }
LogFileAnalysis >> registerRRCEntries: for [
	"Return list of arrivals of RRCs on P&M"
	| props pmprops |
	pmprops := log_coll select: [:each| (each at: 1) = ' Reg Bin Position ' and: [(each at: 4) value includesSubstring: 'PickAndMix' ]].
	props := pmprops select: [:each| (each at: 6) value includesSubstring: for].
	^ props
]

{ #category : #accessing }
LogFileAnalysis >> requestRRCEntries: for [
	"Return list of entries for request and arrival of RRC, for BL01"
	| props searchstring |
	searchstring := for.
	searchstring become: searchstring, ';10;PANTRY;PM-IN'.
	props := log_coll select: [:each| (each at: 1) = ' Send Component Trigger ' and: [(each at: 7) value includesSubstring: searchstring]].
	^ props
]
