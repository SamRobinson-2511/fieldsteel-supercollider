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

