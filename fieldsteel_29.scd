//https://www.youtube.com/watch?v=WrhL85eXXMU&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=30


//(1) Tempo/Quantization
//(2) \sustain and \legato
//(3) Pfunc and other function based patterns
//(4) Constraint patterns
//(5) Modular pattern composition
//(6) Sharing data across several Pbinds


(
SynthDef(\tone, {
	var sig, env;
	env = Env.adsr(
		\atk.kr(0.001), \dec.kr(0.2), \slev.kr(0.4), \rel.kr(0.3)
	).ar(Done.freeSelf, \gate.kr(1));
	sig = LFTri.ar(\freq.kr(880));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.3));
	sig = sig * env;
	Out.ar(\out.kr(0), sig);
}).add;
)
x = Synth(\tone);
x.set(\gate, 0);

(
p = Pbind(
	\instrument, \tone,
	\dur, 0.5,
	\degree, Pseq([5, 7, 8, 9], inf)
);
x = p.play;
)
x.stop;

//(1) Tempo/Quantization

t = TempoClock.new(112/60).permanent_(true);
t.beats;
t.nextBar;
t.stop;


t = TempoClock(112/60).permanent_(true);
t.beats;
t.nextBar;
t.stop;

(
~tempoChange = {
	|clock, newTempo, numBeats|
	var i = 0, tempoArray;
	tempoArray = Array.interpolation(numBeats, clock.tempo, newTempo/60);
	clock.schedAbs(clock.nextBar, {
		clock.tempo_(tempoArray[i]);
		i = i + 1;
		if(i < numBeats) {1} {\done.postln};
	})
};
)

(
~post = { t.beats.postln; 1;};
t.schedAbs(t.nextBar, {~post.()});
)




t = TempoClock(112/60).permanent_(true).schedAbs(0, {t.beatsPerBar_(4)});


(
p = Pbind(
	\instrument, \tone,
	\dur, 0.5,
	\degree, Pseq([5, 7, 8, 9], inf)
);
x = p.play(t, quant: 4);
)
x.stop;

(
q = Pbind(
	\instrument, \tone,
	\dur, 0.5, //1/16th note
	\degree, Pseq([0, 1, 3s, 4], inf)
);
y = q.play(t, quant: [0.5, -0.50]);
)
y.stop;































