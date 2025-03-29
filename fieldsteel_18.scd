//Fieldsteel tutorial 18

//https://www.youtube.com/watch?v=ih2uqOaqb4c&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=19&t=909s


s.boot;

MIDIClient.init;
MIDIClient.destinations;
m = MIDIOut(3);

//test
m.latency = 0;
m.noteOn(0, 69, 30);
m.noteOff(0, 69);


//chord
(
[35, 49, 56, 63, 73].do{
	|nn|
	m.noteOn(0, nn, 25);
};
)
m.allNotesOff(3);
//arpeggiated inside routine
(
Routine({
	[35, 49, 56, 63, 73].do{
		|nn|
		m.noteOn(0, nn, 25);
		0.5.wait;
	};
}).play;
)

//staccato
(
r = Routine({
	{
		[35, 49, 56, 63, 73].do{
			|nn|
			m.noteOn(0, nn, 25);
			0.1.wait;
			m.noteOff(0, nn);
			0.2.wait;
		};
	}.loop;
}).play;
)

r.stop;

//allNotesOff
(
CmdPeriod.add({(0..127).do{arg n; m.noteOff(0,n)}});
CmdPeriod.add({(0..127).do{arg n; m.noteOff(1,n)}});
CmdPeriod.add({(0..127).do{arg n; m.noteOff(15,n)}});
)

(
r = Routine({
	{
		[30, 40, 30, 45].do{
			|note|
			m.noteOn(0, note, 127);
			(30,40..100).reverse.scramble.do{
				|val|
				m.control(0, 20, val.postln);
				0.15.wait;
			};
			m.noteOff(0, note);
		};
	}.loop;
}).play;
)




//With Pbinds
(
SynthDef(\basic, {
	|freq=440|
	var sig;
	sig = SinOsc.ar(freq)!2;
	sig = sig * XLine.kr(0.2, 0.01, 0.3, doneAction:2);
	Out.ar(0, sig);
}).add;
)

(
p = Pbind(
	\type, \note,
	\instrument, \basic,
	\dur, 0.15,
	\midinote, Pseq([50, 55, 57, 60, 67], inf)
).play;
)

p.stop;


(
~k1 = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, Pwrand([62, 74, 86, 98], [0.1, 0.8, 0.08,0.2],inf),
	\amp, Pexprand(50, 127, inf)/127,
	\sustain, 0.02,
	\dur, 0.15,
	\stretch, 4*60/170
).play(quant: 4*60/170);

~k1_cc20= Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, m,
	\chan, 0,
	\ctlNum, 20,
	\control, Pwrand([127, 64, 32, 0], [0.5, 0.10, 0.3, 0.1], inf),
	\dur, 0.15,
	\stretch, 4*60/170
).play(quant: 4*60/170);

~k2 = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 1,
	\midinote, Pxrand([
		[38, 50, 72, 77, 81],
		[43, 55, 70, 77, 79],
		[46, 58, 69, 74, 77, 84]
	], inf),
	\amp, Pwhite(15, 30, inf),
	\sustain, Pexprand(4, 8, inf),
	\dur, Prand([4, 6, 8], inf),
	\stretch, 4*60/170
).play(quant: 4*60/170);

~rev500_cc12 = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, m,
	\chan, 15,
	\ctlNum, 12,
	\control, Pseq([0, 12, 24, 48].reverse, inf),
	\dur, 0.15,
	\stretch, 4*60/170
).play(quant: 4*60/170);

~rev500_cc13 = Pbind(
	\type, \midi,
	\midicmd, \control,
	\midiout, m,
	\chan, 15,
	\ctlNum, 13,
	\control, Pseq([0, 12, 24, 48], inf),
	\dur, 0.15,
	\stretch, 4*60/170
).play(quant: 4*60/170);
)
(
~rev500_cc12.stop;
~rev500_cc13.stop;
~k1.stop;
~k2.stop;
)

//cc messages: kurzweil
(
m.noteOn(0, rrand(32, 35), 30);
m.control(0, 12, rrand(100, 20)); //tuning

m.control(0, 13, rrand(1, 2)); //cf shaper
m.control(0, 14, rrand(2, 3)); //cf shaper 2
m.control(0, 15, rrand(0, 1)); //cf shaper

//amp env
m.control(0, 73, exprand(1, 127)); //atk
m.control(0, 72, exprand(1, 0.5)); //dec
m.control(0, 72, exprand(1, 0.5)); //rel

//cc messages: reverb

m.control(15, 12, rrand(10, 20));
m.control(15, 13, rrand(1, 15));
m.control(15, 14, rrand(1, 127));
m.control(15, 15, rrand(1, 127));
m.control(15, 16, rrand(1, 127));
)



(
~k1 = Pbind(
	\type, \midi,
	\midicmd, \noteOn,
	\midiout,
)
)

































