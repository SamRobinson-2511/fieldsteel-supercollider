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

Synth(\bpfsaw);