//https://www.youtube.com/watch?v=7nrUBbmY1hE&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=25

//multiple wavetable synthesis

Buffer.freeAll(s)
(
~wt0 = Signal.sineFill(
	1024,
	1/(1..8),
	0!8
).asWavetable;

~wt1 = Signal.sineFill(
	1024,
	[1, 0, 1/2, 1, 1/4],
	[0, 0, pi, 0, pi]
).asWavetable;
)
~wt0.plot; ~wt1.plot;

(
~b0 = Buffer.loadCollection(s, ~wt0);
~b1 = Buffer.loadCollection(s, ~wt1);
)
~b0.bufnum;
~b1.bufnum;
(
{
	var sig;
	sig = VOsc.ar(MouseX.kr(13, 14), 300, mul: 0.2!2);
}.play;
)

(
SynthDef(\vosc, {
	|out|
	var sig, bufpos;
	bufpos = MouseX.kr(13, 14);
	sig = VOsc.ar(bufpos, 300, mul:0.2!2);
	Out.ar(out, sig);
}).add;
)


(
SynthDef(\vosc, {
	|out, buf=0, numBufs=2|
	var sig, bufpos;
	bufpos = buf + MouseX.kr(0, numBufs-1);
	sig = VOsc.ar(bufpos, 300, mul:0.2!2);
	Out.ar(out, sig);
}).add;
)
Synth(\vosc, [\buf, ~b0.bufnum, \numBufs, 2]);



Buffer.freeAll(s);
(
~wt = Array.fill(4, {
	var numSegs = rrand(4, 20);
	Env(
		[0]++
		(({rrand(0.0, 1.0)}!numSegs-1)) * [1,-1].scramble
		++[0],
		{exprand(1, 20)}!numSegs,
		{rrand(-20, 20)}!numSegs
	).asSignal(1024).asWavetable;
});
)

~buf = Buffer.allocConsecutive(4, s, 2048);
~buf[0];

(
~buf.do({
	|buf, i|
	buf.loadCollection(~wt[i]);
});
)

~wt.do({|n, i| n.plot(~buf[i].bufnum.asString)});

(
SynthDef(\vosc, {
	|out, buf=0, numBufs=2, freq=60|
	var sig, bufpos;
	bufpos = buf + LFNoise1.kr(0.5).range(0, numBufs-1);
	sig = VOsc.ar(bufpos.poll, freq, mul:0.2!2);
	Out.ar(out, sig);
}).add;
)
Synth(\vosc, [\freq, 28.midicps, \buf, ~buf[0], \numBufs, 4]);










