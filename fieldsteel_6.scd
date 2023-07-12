//iteration


//Collection
//do = forEach, always returns its receiver
[1, 2, 3, 4, 5].do{"hello".postln};

(
[1,2,3,4,5].do{
	|i, count|
	[count, i.squared.postln];
}
)

(
x = Array.newClear(5);
[1,2,3,4,5].do{
	|i, count|
	x[count] = i.squared;
}
)

x;

//collect: returns a new collection
(
z = [1,2,3,4,5].collect{|i| i.squared}
)

//sugar
(
z = [1,2,3,4,5].collect(_.squared);
)

5.do{|i| i.postln};
[0,1,2,3,4].do{|i| i.postln};

x = {VarSaw.ar(40!2, 0, 0.05)}.play;
x.free;


(
SynthDef.new(\iter, {
	|freq=40|
	var temp, sum, env;
	sum = 0; //needs to have a value that's not nil
	env = EnvGen.kr(
		Env.perc(0.01, 5, 1, -2),
		doneAction:2

	);
	10.do{
		temp = VarSaw.ar(
			freq * {Rand(0.99, 1.02)}!2,
			{Rand(0.0, 1.0)}!2, //randomize phase to prevent popping
			{ExpRand(0.005, 0.05)}!2 //randomize duty cycle
		);
		sum = sum + temp;
	};
	sum = sum * 0.05;
	Out.ar(0, sum)
}).add;
)

x = Synth(\iter, [\freq, 200]);
x = Synth(\iter, [\freq, 69.midicps]);

//iterate
(
[69, 73, 77].do{
	|midinote|
	Synth.new(\iter, [\freq, midinote.midicps])
};
)

//don't use language side iteration

//incorporate iteration count into audio manipulation
(
SynthDef.new(\iter2, {
	|freq=200|
	var temp, sum;
	sum = 0;
	10.do{
		|count|
		temp =  SinOsc.ar(freq * (count + 1));
		sum = sum + temp;
	};
	sum = sum + 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter2);


(
SynthDef.new(\iter3, {
	|freq=200 dev=1.02|
	var temp, sum;
	sum = 0;
	10.do{
		|count|
		temp =  SinOsc.ar(
			freq *
			(count + 1) *
			LFNoise1.kr({Rand(0.05, 0.2)}!2).range(dev.reciprocal, dev)
		);
		temp = temp * LFNoise1.kr({Rand(0.5, 8)}!2).exprange(0.01, 0.2);
		sum = sum + temp;
	};
	sum = sum + 0.05;
	Out.ar(0, sum);
}).add;
)

x = Synth.new(\iter3);
x.set(\freq, 36, \dev, 2.02);
x.free;

//


s.boot;

