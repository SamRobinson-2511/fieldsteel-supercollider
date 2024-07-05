s.boot;

(
SynthDef(\bpfsaw, {
	|atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, cf=1500, rq=0.2, amp=1, out=0|
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq);
	sig = BPF.ar(sig, cf, rq);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

(
SynthDef(\bpfsaw1, {
	|atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0|
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin, cfmax),
		LFNoise1.kr(0.1).exprange(rqmin, rqmax)
	);
	sig = sig * env * amp;
	Out.ar(out, sig);
}).add;
)

Synth(\bpfsaw1);
2.do{(Synth(\bpfsaw1, [\amp, 0.5]))};
10.do{(Synth(\bpfsaw1, [\amp, 0.5, \detune, 3]))};


(
10.do{
	Synth(
		\bpfsaw1,
		[
			\freq, 50,
			\amp, 0.2,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03
		],
	);
};
)


//add spatialization
(
SynthDef(\bpfsaw2, {
	|atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, pan=0,  cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0|
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq * LFNoise1.kr(0.5,detune).midiratio);
	sig = BPF.ar(
		sig,
		LFNoise1.kr(0.2).exprange(cfmin, cfmax),
		LFNoise1.kr(0.1).exprange(rqmin, rqmax)
	);
/*	sig = Pan2.ar(sig, pan);*/
	sig = sig * env * amp;
	Out.ar(out, sig!2);
}).add;
)

(
10.do{
	Synth(
		\bpfsaw2,
		[
			\freq, 50,
			\amp, 1,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
			\pan, rrand(-1.0, 1.0)
		],
	);
};
)

//duplication
rrand(0, 100)!2;
{rrand(0, 100)}!2;

(
SynthDef(\bpfsaw3, {
	|atk=2, sus=0, rel=3, c1=1, c2=(-1), freq=500, detune=0.2, pan=0,  cfmin=500, cfmax=2000, rqmin=0.1, rqmax=0.2, amp=1, out=0|
	var sig, env;
	env = EnvGen.kr(Env([0, 1, 1, 0], [atk, sus, rel], [c1, 0, c2]), doneAction:2);
	sig = Saw.ar(freq * {LFNoise1.kr(0.5,detune).midiratio}!2);
	sig = BPF.ar(
		sig,
		{LFNoise1.kr(0.2).exprange(cfmin, cfmax)}!2,
		{LFNoise1.kr(0.1).exprange(rqmin, rqmax)}!2
	);
/*	sig = Pan2.ar(sig, pan);*/
	sig = Balance2.ar(sig[0], sig[1], pan);
	sig = sig * env * amp;
	Out.ar(out, sig!2);
}).add;
)

(
10.do{
	Synth(
		\bpfsaw2,
		[
			\freq, 50,
			\amp, 1,
			\cfmin, 50*2,
			\cfmax, 50*50,
			\rqmin, 0.005,
			\rqmax, 0.03,
/*			\pan, rrand(-1.0, 1.0)*/
			\pan, 0
		],
	);
};
)









//iteration
(
[58, 65, 68, 73].midicps.do{
	|f|
	Synth(
		\bpfsaw,
		[
			\freq, f,
			\amp, 0.25,
			\cf, f * exprand(1, 12),
			\rq, exprand(0.01, 0.5),
		];
	);

};
)


(
4.do{
	Synth(
		\bpfsaw,
		[
			\freq, exprand(100, 1000),
			\amp, 0.25,
			\cf, exprand(200, 5000),
			\rq, exprand(0.01, 0.5)
		]
	);
};
)


//scale
(
4.do{
	Synth(
		\bpfsaw,
		[
			\freq, (Scale.minor.degrees+60).midicps.choose,
			\amp, 0.25,
			\cf, exprand(200, 5000),
			\rq, exprand(0.01, 0.5)
		]
	);
};
)

(
(1..6).choose.do{
	Synth(
		\bpfsaw,
		[
			\freq, (Scale.minor.degrees+60).midicps.choose,
			\amp, 0.25,
			\cf, exprand(200, 5000),
			\rq, exprand(0.01, 0.5)
		]
	);
};
)

Synth(\bpfsaw);