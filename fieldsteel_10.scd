(
SynthDef.new(\sine, {
	|freq=440, atk=0.005, rel=0.3, amp=1, pan=0|
	var sig, env;
	sig = SinOsc.ar(freq);
	env = EnvGen.kr(Env.new([0,1,0], [atk, rel], [1, -1]), doneAction:2);
	sig = Pan2.ar(sig, pan, amp);
	sig = sig * env;
	Out.ar(0, sig);
}).add;
)

//Pbind: key/value pairs, generates stream of events, provide value for dur key

(
p = Pbind(
	\type, \note,
	\instrument, \sine
).play;
)
p.stop;


//note is default type
(
p = Pbind(
	\instrument, \sine
).play;
)
p.stop;

//use dur key with delta time
(
p = Pbind(
	\instrument, \sine,
	\dur, 0.1
).play;
)
p.stop;


//use Pseq to sequence values
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace //print to console
).play;
)
p.stop;

//args in synthdef available as pbind keys
//Pbind.play is returning synths on audio server

(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pseq([330, 247, 370], inf).trace

).play;
)
p.stop;

//falling out of phase

(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pseq([330, 247, 370, 220], inf).trace

).play;
)
p.stop;

//resulting event stream is only as long as the shortest pattern
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], 4).trace, //12 events
	\freq, Pseq([330, 247, 370, 220], inf).trace

).play;
)
p.stop;


(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], 4).trace,
	\freq, Pseq([330, 247, 370, 220], 2).trace //8 events

).play;
)
p.stop;


//midi nn vs. cps
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\freq, Pseq([68, 45, 44, 81].midicps, inf).trace

).play;
)
p.stop;

//with midi note key, checkout naming conventions in helpfile, use only one symbol
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf).trace,
	\midinote, Pseq([68, 45, 44, 81], inf).trace
).play;
)
p.stop;

//generating random numbers

//Pexprand: exponential distribution
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf),
	\freq, Pexprand(50, 4000, inf).trace
).play;
)
p.stop;


//Pwhite: linear distribution
(
p = Pbind(
	\instrument, \sine,
	\dur, Pseq([0.6, 0.15, 0.15], inf),
	\freq, Pwhite(50, 4000, inf).trace
).play;
)
p.stop;


//sequencing args in synthdef
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 4000, inf),
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)
p.stop;

//patterns understand mathematical methods / messages

(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\freq, Pexprand(50, 4000, inf).round(55).trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)
p.stop;


//using midinote and harmonic keys
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\midinote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pexprand(0.01, 0.2, inf),
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)
p.stop;

//amplitude pattern bound to on pitch pattern
(
p = Pbind(
	\instrument, \sine,
	\dur, Pwhite(0.05, 0.5, inf),
	\midinote, 33,
	\harmonic, Pexprand(1, 80, inf).round.trace,
	\atk, Pwhite(2.0, 3.0, inf),
	\rel, Pwhite(5.0, 10.0, inf),
	\amp, Pkey(\harmonic).reciprocal * 0.3,
	\pan, Pwhite(-0.8, 0.8, inf)
).play;
)
p.stop;

//using Pdef to control Pbind
//once inside Pdef there's no need for global variable
//can change while running (real-time pattern manipulation)
(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([29.5], inf).trace,
		\harmonic, Pexprand(1, 80, inf).round.trace,
		\atk, Pwhite(2.0, 3.0, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play;
)

//cutout higher partials

(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([29.5], inf).trace,
		\harmonic, Pexprand(1, 40, inf).round.trace,
		\atk, Pwhite(2.0, 3.0, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf),
	);
).play;
)


//replace .play with .stop
(
Pdef(
	\sinepat,
	Pbind(
		\instrument, \sine,
		\dur, Pwhite(0.05, 0.5, inf),
		\midinote, Pseq([29.5], inf).trace,
		\harmonic, Pexprand(1, 40, inf).round.trace,
		\atk, Pwhite(2.0, 3.0, inf),
		\rel, Pwhite(5.0, 10.0, inf),
		\amp, Pkey(\harmonic).reciprocal * 0.3,
		\pan, Pwhite(-0.8, 0.8, inf)
	);
).play;
)


//using Dictionary
(
d = Dictionary.new;
d.add().entries.collect({});
)






























