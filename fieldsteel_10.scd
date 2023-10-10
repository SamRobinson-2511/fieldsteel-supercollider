//Patterns, Part 1
//https://www.youtube.com/watch?v=nB_bVJ1c1Rg&t=1008s


(
SynthDef(\sine, {
	|freq=440, atk=0.005, rel=0.3, amp=1, pan=0|
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env([0,1,0], [atk, rel], [1, -1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

Synth(\sine);

(
p = Pbind(
	/*\type, \note, */ //default
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], 4).trace,
	\midinote, Pseq([60, 65, 67, 74], inf).trace //default keys
).play;
)

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
/*	\freq, Pexprand(50, 4000, inf).round(55.5).trace,*/
	\midinote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8, 0.8, inf);
).play;
)
s.plotTree;
p.stop;

//Pdef can change while playing

(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([33], inf).trace,
		\harmonic, Pexprand(1, 80, inf).round.trace,
		\atk, Pwhite(2.0, 3.0, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf);
	);
).play;
)

//with buffers
(

d = Dictionary.new;
d.add(\ohh -> PathName("/Volumes/Samsung 870 QVO/POLYEND/Samples/ARC Noise/hats/").entries.collect({
	|sf|
	Buffer.read(s, sf.fullPath);
});
);

d.add(\chh -> PathName("/Volumes/Samsung 870 QVO/POLYEND/Samples/ARC Noise/hats/").entries.collect({
	|sf|
	Buffer.read(s, sf.fullPath);
});
);

d.add(\kick -> PathName("/Volumes/Samsung 870 QVO/POLYEND/Samples/ARC Noise/kicks/").entries.collect({
	|sf|
	Buffer.read(s, sf.fullPath);
});
);

)

d.[\kick].choose.play;

(
SynthDef(\bufplay, {
	|buf=0, rate=1, amp=1|
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf) * rate, doneAction:2);
	sig = sig * amp;
	Out.ar(0, sig);
}).add;
)

Synth(\bufplay, [\buf, d[\ohh].choose.bufnum]);

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Prand(d[\ohh]++d[\chh]++d[\kick], inf),
		\rate, 1,
		\amp, 0.5
	);
).stop;
)

//Pxrand: no two twice
(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Pxrand(d[\ohh]++d[\chh]++d[\kick], inf),
		\rate, 1,
		\amp, 0.5
	);
).stop;
)
//Pwrand: weighted by second array
(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Pwrand([d[\ohh][0], d[\chh][0], d[\kick][0]], [1,2,8].normalizeSum.postln, inf),
		\rate, 1,
		\amp, 0.5
	);
).stop;
)

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Prand(d[\ohh]++d[\chh]++d[\kick], inf),
		\rate, 1,
		\amp, 0.5
	);
).stop;
)


(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Prand(d[\ohh]++d[\chh]++d[\kick], inf),
		\rate, 1,
		\amp, Pseq([0.8]++(0.1!7), inf)
	);
).stop;
)


//better

(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Prand(d[\ohh]++d[\chh]++d[\kick], inf),
		\rate, 1,
		\amp, Pseq([0.8, Pexprand(0.005, 0.1, 7)], inf)
	);
).stop;
)

//nested patterns
(
Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Pseq(
			[
				Prand(d[\kick], 1),
				Prand(d[\chh]++d[\ohh], 7),
				Prand(d[\chh], 1),
				Prand(d[\chh]++d[\ohh]++d[\kick], 7),
			], inf
		),
		\rate, Pexprand(0.8, 1.25, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.25, 7)], inf)
	);
).stop;
)

(
s.prepareForRecord;

Pdef(
	\rhythm,
	Pbind(
		\instrument, \bufplay,
		\dur, Pseq([1/16], inf),
		\stretch, 1.875,
		\buf, Pseq(
			[
				Prand(d[\kick], 1),
				Prand(d[\chh]++d[\ohh], 6),
				Prand(d[\ohh], 1),
				Prand(d[\chh]++d[\ohh]++d[\kick], 7),
			], inf
		),
		\rate, Pexprand(0.125, 420.0, inf),
		\amp, Pseq([0.8, Pexprand(0.005, 0.2, 7)], inf)
	);
).play; //quantize per bar
)





