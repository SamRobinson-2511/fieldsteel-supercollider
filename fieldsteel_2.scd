Server.local.boot;
Server.local.quit;

//s is a global variable containing the server
s.boot;
s.quit;

//function: {}
//method: .play;

{SinOsc.ar(440, 0, 0.25)}.play;

//store in global variable
x = {SinOsc.ar(440, 0, 0.25)}.play;
x.free;

//UGen
//.ar: audio rate
//.kr: control rate
//.ir: initialization rate


//arguments must be declared before variables

(
z = {
	arg freq=440, amp=1;
	var sig;
	sig = SinOsc.ar(freq) * amp;
}.play;
)

z.set(\freq, 220);
z.set(\amp, 0.24);
z.set(\freq, 440, \amp, 0.2);


(
y = {
	var freq, sig;
	freq = LFNoise0.kr(8, 400, 600);
	sig = SinOsc.ar(freq);
}.play;
)
y.free;

//use range method
(
z = {
	var freq, sig;
	freq = LFNoise0.kr(8).range(100, 1000);
	sig = SinOsc.ar(freq);
}.play;
)
z.free;

//exponential distribution with exprange
(
e = {
	var freq, sig;
	freq = LFNoise0.kr(8).exprange(100, 1000);
	sig = SinOsc.ar(freq);
}.play;
)
e.free;