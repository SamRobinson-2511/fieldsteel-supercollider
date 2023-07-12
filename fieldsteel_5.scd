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

(
SynthDef.new(\multi, {
	var sig, amp;
	amp = SinOsc.kr([7, 1, 2, 0.2,6]).range(0,1);
	sig = SinOsc.ar([300, 500, 700, 900, 1100]);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig); //don't deploy multichannel expansion in Out UGen
}).add;
)

x = Synth.new(\multi);


//multichannel randomness
rrand(50, 1200)!4;
{rrand(50, 1200)}!4;


(
SynthDef.new(\multi2, {
	var sig, amp;
	amp = SinOsc.kr({exprand(0.2, 12)}!8).range(0,1);
	sig = SinOsc.ar({exprand(50, 1200)}!8);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig); //don't deploy multichannel expansion in Out UGen
}).add;
)

x = Synth.new(\multi2);

//lowercase exprand keeps fixed values when SynthDef compiled, use UGen

(
SynthDef.new(\multi3, {
	var sig, amp;
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8);
	sig = sig * amp;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig); //don't deploy multichannel expansion in Out UGen
}).add;
)

x = Synth.new(\multi3);

//adding envelopes
(
SynthDef.new(\multi4, {
	var sig, amp, env;
	env = EnvGen.kr(
		Env.new([0,1,0], [10, 10], [1, -1]),
		doneAction:2

	);
	amp = SinOsc.kr({ExpRand(0.2, 12)}!8).range(0,1);
	sig = SinOsc.ar({ExpRand(50, 1200)}!8);
	sig = sig * amp * env;
	sig = Splay.ar(sig) * 0.5;
	Out.ar(0, sig); //don't deploy multichannel expansion in Out UGen
}).add;
)

x = Synth.new(\multi4);






s.freeAll;