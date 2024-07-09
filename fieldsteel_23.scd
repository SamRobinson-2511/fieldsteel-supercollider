//https://www.youtube.com/watch?v=8EK9sq_9gFI&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=24

b = Buffer.alloc(s, 2048);



(
~sig = Signal.sineFill(1024, [1], [0]);
/*~sig.plot;*/
~wt = ~sig.asWavetable;
b.loadCollection(~wt);
/*~wt.collect({|n| n}).plot("wavetable");*/
)

b.plot;

{Osc.ar(b, MouseX.kr(100, 1000, 1), mul: 0.2!2)}.play;

/*~sig.size;
~wt.size;*/

(
~sig = Signal.sineFill(
	1024,
	[1, 1/4, 1/6, 1/2],
	0!4
);
~wt = ~sig.asWavetable;
b.loadCollection(~wt);
)

b.plot;
~sig.plot;

{Osc.ar(b, MouseX.kr(100, 1000, 1), mul: 0.2!2)}.play;



(
~amps = [1] ++ ({[0, exprand(0.05, 0.5)].choose}!31);
~sig = Signal.sineFill(
	1024,
	~amps,
	0!32
);
~wt = ~sig.asWavetable;
b.loadCollection(~wt);
)


~sig.plot;

{Osc.ar(b, MouseX.kr(100, 1000, 1), mul: 0.2!2)}.play;

//sin2, sin3: can specify non-integral frequencies

b.sine3([1.25],[1],[0], asWavetable:true);

(
b.sine3(
	({exprand(0.75, 40)}!16).sort,
	({exprand(0.05, 0.9)}!16).sort.reverse,
	{rrand(0, 2pi)}!16,
	asWavetable:true
);
)

{Osc.ar(b, MouseX.kr(10, 10000, 1) * [1, 2.01], mul: 0.2!2)}.play;


(
var env, sig, wt;
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \lin);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \sine);*/
env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], {rrand(-20, 20)}!4);
sig = env.asSignal(1024);
wt = sig.asWavetable;
b.loadCollection(wt);
)


(
var env, sig, wt;
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \lin);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \sine);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \step);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \hold);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \exp);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \wel);*/
/*env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \sqr);*/
env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], \cuub);
env = Env([0, 0.6, -0.9, 0.3, 0], [4, 3, 2, 1], {rrand(-20, 20)}!4);
sig = env.asSignal(1024);
wt = sig.asWavetable;
b.loadCollection(wt);
)

b.plot;

{Osc.ar(b, MouseX.kr(10, 10000, 1) * [1, 1.5], mul: 0.2!2)}.play;




(
var env, sig, wt, numSegs;
numSegs = rrand(4, 20);
env = Env(
	(({rrand(-1.0, 1.0)}!(numSegs + 1)) * [1, -1]).scramble,
	{exprand(1, 20)}!numSegs,
	{rrand(-20, 20)}!numSegs
);
sig = env.asSignal(1024);
wt = sig.asWavetable;
b.loadCollection(wt);
)


(
var sig, wt;
sig = Signal.newClear(1024);
sig.waveFill({
	|x, old, i|
	sin(x);
}, 0, 2pi);
sig.plot;
)

(
var sig, wt;
sig = Signal.newClear(1024);
sig.waveFill({
	|x, old, i|
	var out;
	out = sin(x.pow(1.5));
	out = out * 1.5;
	out = out.fold(-1, 1);
	out = out.cubed;
}, 0, 2pi);
wt = sig.asWavetable;
b.loadCollection(wt);
sig.plot;
)









































