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
LogFileAnalysis >> parse [
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
