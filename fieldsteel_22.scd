

//https://www.youtube.com/watch?v=dLMSR2Kjq6Y&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=23


{SinOsc.ar(800 + SinOsc.ar(200, mul:MouseY.kr(0, 400).poll)) * 0.2!2}.play;

//increase in modulator amp increases sidebands

{SinOsc.ar(800 + SinOsc.ar(MouseX.kr(200, 1200).poll, mul:MouseY.kr(0, 400).poll)) * 0.2!2}.play;

//interval at which sidebands appear is equal to modulator frequency

//negative frequency = waveform polarity inverted

{SinOsc.ar(800 + SinOsc.ar(350, mul:400)) * 0.2!2}.play;

(
SynthDef(\fm, {
	|freq=500, mRatio=1, cRatio=1, modAmp=200, atk=0.01, rel=1, amp=0.5, pan=0|
	var car, mod, env;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	mod = SinOsc.ar(freq*mRatio, mul:modAmp);
	car = SinOsc.ar(freq*cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

Synth(\fm, [\freq, 700]);

(
Synth(\fm, [
	\freq, 60.midicps,
	\cRatio, rrand(0.0125, 3.14),
	\mRatio, rrand(0.125, 3.14)
	]
);
)

//index = modAmp/modHz


(
SynthDef(\fm, {
	|freq=500, mRatio=1, cRatio=1, index=1, atk=0.01, rel=1, amp=0.5, pan=0|
	var car, mod, env;
	env = EnvGen.kr(Env.perc(atk, rel), doneAction:2);
	mod = SinOsc.ar(freq*mRatio, mul:freq*mRatio*index);
	car = SinOsc.ar(freq*cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

(
Synth(\fm, [
	\freq, 60.midicps,
	\cRatio, rrand(0.0125, 3.14),
	\mRatio, rrand(0.125, 3.14),
	\index, rrand(0.1, 20)
	]
);
)


(
SynthDef(\fm, {
	|freq=500, mRatio=1, cRatio=1, index=1, iScale=5, atk=0.01, rel=3, cAtk=4, cRel=(-4), amp=0.5, pan=0|
	var car, mod, env, iEnv;
	iEnv = EnvGen.kr(
		Env(
			[index, index * iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	env = EnvGen.kr(
		Env.perc(atk, rel, curve:[cAtk, cRel]),
		doneAction:2
	);
	mod = SinOsc.ar(freq*mRatio, mul:freq*mRatio*iEnv);
	car = SinOsc.ar(freq*cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

(
Synth(\fm, [
	\freq, 32.midicps,
	\rel, 4,
	\index, 20,
	\iScale, 0.05,
	\mRatio, rrand(0.5, 10.0)
	]
);
)


{PMOsc.ar(500, 4, 50) * 0.2!2}.play;


(
SynthDef(\fm, {
	|freq=500, mRatio=1, cRatio=1, index=1, iScale=5, atk=0.01, rel=3, cAtk=4, cRel=(-4), amp=0.5, pan=0|
	var car, mod, env, iEnv, mod2;
	iEnv = EnvGen.kr(
		Env(
			[index, index * iScale, index],
			[atk, rel],
			[cAtk, cRel]
		)
	);
	env = EnvGen.kr(
		Env.perc(atk, rel, curve:[cAtk, cRel]),
		doneAction:2
	);
	mod2 = SinOsc.ar(freq/10, mul:freq/10 * iEnv);
	mod = SinOsc.ar(freq * mRatio + mod2, mul:freq*mRatio*iEnv);
	car = SinOsc.ar(freq * cRatio + mod) * env * amp;
	car = Pan2.ar(car, pan);
	Out.ar(0, car);
}).add;
)

(
Synth(\fm, [
	\freq, 32.midicps,
	\rel, 4,
	\index, 20,
	\iScale, 0.05,
	\mRatio, rrand(0.5, 10.0)
	]
);
)






























