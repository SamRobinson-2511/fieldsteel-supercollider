MIDIClient.init;

MIDIIn.connectAll;

MIDIdef.noteOn(\noteOnTest, {"key down".postln;});

MIDIdef(\noteOnTest).disable;
MIDIdef(\noteOnTest).enable;
MIDIdef(\noteOnTest).free;
MIDIdef.freeAll;


(
MIDIdef.noteOn(\noteOnTest, {
	|vel, nn, chan, src|
	[vel, nn, chan, src].postln;
})
)

(
MIDIdef.noteOn(\noteOnTest, {
	|vel, nn|
	[vel, nn].postln;
})
)