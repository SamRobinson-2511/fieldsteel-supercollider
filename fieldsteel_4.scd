x = {PinkNoise.ar * 0.5}.play;
x.free;

//Line: finite UGens use doneAction

Server.local.plotTree;
s.plotTree.scope;


//synth still runs without
(
x = {
	var sig, env;
	env = Line.kr(1, 0, 1);
	sig = Pulse.ar(ExpRand(30, 500)) * env;
}.play;
)
x.free;
s.freeAll;


(
x = {
	var sig, env;
	env = Line.kr(1, 0, 1, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500)) * env;
}.play;
)

//exponential line, needs to be in positive
(
{
	var sig, env;
	env = XLine.kr(1, 0.01, 1, doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500)) * env.dbamp;
}.play;
)

(
x = {
	var sig, env;
	env = Line.kr(1, 0, 1);
	sig = Pulse.ar(ExpRand(30, 500)) * env.dbamp.postln;
}.play;
)

//amp to db
0.0125.ampdb;

//XLine to control frequency of pulse wave
//conceive all envs as one unit
(
{
	var sig, freq, env;
	env = XLine.kr(1, 0.01, 1, doneAction: 2);
	freq = XLine.kr(888, 110, 1, doneAction:2);
	sig = Pulse.ar(freq) * env;
}.play;
)

//EnvGen: Env - breakpoint envelope shape with gate
Env.new.plot;
//levels: array of numbers, default [0,1,0]
//times: array of durations [1,1]
//curve: linear interpolation


(
{
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0, 1, 0.2, 0],
		[0.5, 1, 2],
		[3, -3, 0]),
	doneAction:2);
	sig = Pulse.ar(ExpRand(30, 500)) * env;
}.play;
)

x = Env.new([0, 1, 0.2, 0], [0.5, 1, 2]).plot; //linear
y = Env.new([0.01, 1, 0.2, 0.01], [0.5, 1, 2], \exp).plot; //exponential
z = Env.new([0, 1, 0.2, 0], [0.5, 1, 2], [3, -3, 0]).plot;
a = Env.new([0, 1, 0.2, 0], [0.5, 1, 2], [\sine, \sine, 0]).plot;

//gate can be used as a trigger
//t_ args: creates control rate impulse
(
x = {
	|t_gate=1|
	var sig, env;
	env = EnvGen.kr(Env.new(
		[0, 1, 0.2, 0],
		[0.5, 1, 2],
		[3, -3, 0]), t_gate, doneAction:0);
	sig = Pulse.ar(LFPulse.kr(8).range(600,800)) * env;
}.play;
)

x.set(\t_gate, 1); //can retrigger
x.free;

//Env.adsr: sustain portion as long as gate remains positive
//trigger argument useless in adsr cases, use normal gate argument
(
x = {
	|gate=0|
	var sig, env;
	env = EnvGen.kr(Env.adsr, gate, doneAction: 2);
	sig = VarSaw.ar(SinOsc.kr(16).range(500, 1000)) * env;
}.play;
)

x.set(\gate, 1);
x.set(\gate, 0);
x.free;


s.freeAll;

(
x = {
	|gate=0|
	var sig, env, freq;
	freq = EnvGen.kr(Env.adsr(1), gate, 200, 0.1);
	env = EnvGen.kr(Env.adsr, gate, doneAction:2);
	sig = VarSaw.ar(SinOsc.kr(16).range(500, 1000)) * env;
}.play;
)

x.set(\gate, 1);
x.set(\gate, 0);







































