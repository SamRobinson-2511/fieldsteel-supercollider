s.meter(8,8);

x = {SinOsc.ar}.play; //monophonic output on channel 0
x.free;

x = {[SinOsc.ar(400), SinOsc.ar(500)]}.play; //stereo output
x.free;

x = {SinOsc.ar([300, 500])}.play; //stereo output
x.free;

(
x = {
	var sig, amp;
	amp = SinOsc.kr([7,1]).range(0,1);
	sig = SinOsc.ar([300, 500]);
	sig = sig * amp
}.play;
)

(
x = {
	var sig, amp;
	amp = SinOsc.kr([7, 1, 2, 0.2,6]).range(0,1);
	sig = SinOsc.ar([300, 500, 700, 900, 1100]);
	sig = sig * amp;
	Mix.new(sig) * 0.25; //reduces multiple channels
}.play;
)

(
x = {
	var sig, amp;
	amp = SinOsc.kr([7, 1, 2, 0.2,6]).range(0,1);
	sig = SinOsc.ar([300, 500, 700, 900, 1100]);
	sig = sig * amp;
	[Mix.new(sig), Mix.new(sig)] * 0.25;
}.play;
)

//the duplication method returns an array of duplicates

60.dup(4);
60!4;

(
x = {
	var sig, amp;
	amp = SinOsc.kr([7, 1, 2, 0.2,6]).range(0,1);
	sig = SinOsc.ar([300, 500, 700, 900, 1100]);
	sig = sig * amp;
	Mix.new(sig)!2 * 0.25;
}.play;
)

//Splay will spread an arbitrary number of channels accross a stereo field
(
x = {
	var sig, amp;
	amp = SinOsc.kr([7, 1, 2, 0.2,6]).range(0,1);
	sig = SinOsc.ar([300, 500, 700, 900, 1100]);
	sig = sig * amp;
	Splay.ar(sig) * 0.5;
}.play;
)

//common pitfall

x = {PinkNoise.ar(0.5)!2}.play; //exact copy in both channels
x = {PinkNoise.ar(0.5!2)}.play; //different in each channel





s.freeAll;