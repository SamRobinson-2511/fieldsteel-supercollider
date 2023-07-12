s.boot;

//basic server design

//Node: abstract class of objects
//Busses: pass signals
//Order of Execution:

(
SynthDef.new(\blip, {
	|out| //arg for out index
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	|in, out=0|
	var sig;
	sig = In.ar(in, 1);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2)!2;
	Out.ar(out, sig);
}).add;
)

//busses:
s.options.numAudioBusChannels;
s.options.numOutputBusChannels;
s.options.numInputBusChannels;

s.reboot;

y = Synth.new(\reverb, [\in, 6]);
x = Synth.new(\blip, [\out, 6]);
x.free;
y.free;

//divide into component nodes

//use Bus object to let SC handle allocation of sources for you
//
~reverbBus = Bus.audio(s, 1);
~reverbBus.index;

y = Synth.new(\reverb, [\in, ~reverbBus.index]);
x = Synth.new(\blip, [\out, ~reverbBus.index]);
x.free;
y.free;

y = Synth.new(\reverb, [\in, ~reverbBus]);
x = Synth.new(\blip, [\out, ~reverbBus]);
x.free;
y.free;


(
SynthDef.new(\blip, {
	|out| //arg for out index
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	|in, out=0|
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2); //already receiving stereo signal
	Out.ar(out, sig);
}).add;
)

y = Synth.new(\reverb, [\in, ~reverbBus2]);
x = Synth.new(\blip, [\out, ~reverbBus2]);
~reverbBus2 = Bus.audio(s, 2);
x.free;
y.free;

s.freeAll;

//no such thing as multi-channel Bus

~reverbBus3 = Bus.audio(s, 1);

//Order of execution: effect must appear later than source

//Group

g = Group.new;

//default group created when server starts

//Synth

(
SynthDef.new(\blip, {
	|out| //arg for out index
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(300, 1200).round(300);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(2);
	sig = sig * EnvGen.kr(Env.perc(0.01, 0.2), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	|in, out=0|
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2); //already receiving stereo signal
	Out.ar(out, sig);
}).add;
)


x = Synth.new(\blip, [\out, ~reverbBus2], s);
y = Synth.new(\reverb, [\in, ~reverbBus2], s, \addToTail); //efx will always be added to tail


x = Synth.before(y, \blip, [\out, ~reverbBus2]);

x = Synth.new(\blip, [\out, ~reverbBus2], ~sourceGrp);
y = Synth.new(\reverb, [\in, ~reverbBus2], ~fxGrp); //efx will always be added to tail

~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);

(
SynthDef.new(\blip, {
	|out, fund=300, dens=2, decay=0.2| //arg for out index
	var freq, trig, sig;
	freq = LFNoise0.kr(3).exprange(fund, fund * 4).round(fund);
	sig = SinOsc.ar(freq) * 0.25;
	trig = Dust.kr(dens);
	sig = sig * EnvGen.kr(Env.perc(0.01, decay), trig);
	sig = Pan2.ar(sig, LFNoise1.kr(10));
	Out.ar(out, sig);
}).add;

SynthDef.new(\reverb, {
	|in, out=0|
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.5, 0.8, 0.2); //already receiving stereo signal
	Out.ar(out, sig);
}).add;
)

(
8.do{
	Synth.new(
		\blip,
		[
			\out, ~reverbBus2,
			\fund, exprand(60, 300).round(30)
		],
		~sourceGrp
	);
};
)

~sourceGrp = Group.new;
~fxGrp = Group.after(~sourceGrp);



//NEED TO FIX I THINK IT'S ORDER OF EXECUTION


s.freeAll;
































