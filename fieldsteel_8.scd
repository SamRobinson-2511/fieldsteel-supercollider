//Buffer: server side object

~b0 = Buffer.read(s, "/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen20_164.wav");

~b0.play;
~b0.zero; //clear buffer
~b0.free; //remove buffer from server

~b0 = Buffer.read(s, "/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen20_164.wav");
~b1 = Buffer.read(s,"/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen17_175.wav" );
~b2 = Buffer.read(s, "/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen13_173.wav");

~b0.play;
~b1.play;
~b2.play;

//every buffer has a certain number of frames
~b0.numFrames;

//channels
~b0.numChannels;

//numSamples = numFrames * numChannels

//make mono
~b3 = Buffer.readChannel(s, "/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen20_164.wav", channels:[0,1]);
~b3.play;

//duration
~b3.duration;

//Buffer numbers (bufnum)
~b3.bufnum;

//Buffer sample rate
~b0.sampleRate;

//all attributes
~b0.query;

//startFrame and numFrames
~b3.play;

~b3_part0 = Buffer.read(s, "/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen20_164.wav", 0, s.sampleRate/4);
~b3_part0.play;


~b3.numFrames;
~b3_part1 = Buffer.read(s,"/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV/cw_amen20_164.wav", 111000, ~b3.numFrames - 111334);
~b3_part1.play;


//load multiple sound files
//store in an array and iterate through

~amens = Array.new;
~folder = PathName.new("/Volumes/Samsung 870 QVO/SAMPLES/rhythm-lab.com_amen_vol.1/WAV");
~folder.entries;
(
~folder.entries.do({
	|path|
	~amens = ~amens.add(Buffer.read(s, path.fullPath));
});
)
~amens;
~amens.at(0).play;
~amens.at(1).play;
~amens.at(2).play;
~amens.at(3).play;
~amens.at(4).play;
~amens.at(5).play;
~amens.at(6).play;
~amens.at(7).play;

~amens[0].play;
~amens[1].play;


//buffer playback
//PlayBuf: num channels, buffer
//BufRd:

(
SynthDef.new(\playbufTest, {
	|amp=1, out=0, buf, rate=1,da=2|
	var sig;
	sig = PlayBuf.ar(2, buf, rate, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\playbufTest, [\buf, ~b2.bufnum, \rate, 0.25]);


//can't change number of channels dynamically
//num channels needs to match channels in buffer

s.freeAll;
//playbuf is finite and wants a doneAction
//convenience UGens to match samplerates (BufRateScale.kr)


(
SynthDef.new(\playbufTest, {
	|amp=1, out=0, buf, rate=1, t_trig=1, start=0, da=2|
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, start, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


//
x = Synth.new(\playbufTest, [\buf, ~b0.bufnum, \start, s.sampleRate/4, \da, 0]); //da 0 to retrigger
y = Synth.new(\playbufTest, [\buf, ~b2.bufnum, \start, s.sampleRate/4, \da, 0]); //da 0 to retrigger
x.set(\t_trig, 1);
y.set(\t_trig, 1);




(
SynthDef.new(\playbufTest1, {
	|amp=1, out=0, buf, rate=1, t_trig=1, start=0, loop=0, da=2|
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, t_trig, start, loop, doneAction:da);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\playbufTest1, [\buf, ~b2.bufnum, \loop, 1]); //loop can be changed while loop is playing
y = Synth.new(\playbufTest1, [\buf, ~b3.bufnum, \loop, 1, \rate, -1, \start, ~b3.numFrames - 2]); //start -2 bc da

//playback rates: midiratio
12.midiratio;
-23.midiratio;

Synth.new(\playbufTest1, [\buf, ~amens[0].bufnum, \rate, -7.midiratio]);
Synth.new(\playbufTest1, [\buf, ~amens[0].bufnum, \rate, 7.midiratio]);



g = Group.new;
(
x = Synth.new(\playbufTest, [\buf, ~b0.bufnum, \rate, 1.5, \loop, 1, \amp, 0.5], g);
y= Synth.new(\playbufTest, [\buf, ~b1.bufnum, \rate, 0.25, \loop, 1, \amp, 0.5], g);
z = Synth.new(\playbufTest, [\buf, ~b2.bufnum, \rate, 0.75, \loop, 1, \amp, 0.5], g);
)

g.set(\rate, 0.7);
g.set(\buf, ~b3.bufnum);
x.set(\rate, exprand(0.2, 2.0));

g.set(\loop, 0);

s.freeAll;

//BufRd

(
SynthDef.new(\bufreadTest, {
	|amp=1, out=0, buf|
	var sig, ptr;
	ptr = Line.ar(0, BufFrames.kr(buf)-1, BufDur.kr(buf), doneAction:2);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

Synth.new(\bufreadTest, [\buf, ~b2.bufnum]);


//add start and end args
(
SynthDef.new(\bufreadTest1, {
	|amp=1, out=0, buf, start, end|
	var sig, ptr;
	ptr = Line.ar(start, end, BufDur.kr(buf), doneAction:2);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


Synth.new(\bufreadTest1, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames -1]); //forward
Synth.new(\bufreadTest1, [\buf, ~b2.bufnum, \start, ~b2.numFrames -1, \end, 0]); //backward

//loop with Phasor
(
SynthDef.new(\bufreadTest_loop, {
	|amp=1, out=0, buf, start, end, rate=1|
	var sig, ptr;
	ptr = Phasor.ar(0, BufRateScale.kr(buf)*rate, start, end); //can use any .ar
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)


x = Synth.new(\bufreadTest_loop, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames -1]); //forward
x.set(\start, ~b2.numFrames/2, \end, ~b2.numFrames-1);
x.set(\start, 200, \end, 20000);
x.set(\rate, -3.midiratio);
x.free;


//control with SinOsc.ar
(
SynthDef.new(\bufreadTest_sine, {
	|amp=1, out=0, buf, start, end, freq=1|
	var sig, ptr;
	ptr = SinOsc.ar(freq, 3pi/2).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

x = Synth.new(\bufreadTest_sine, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames -1, \freq, 0.5]);
x.free;

//using noise
(
SynthDef.new(\bufreadTest_noise, {
	|amp=1, out=0, buf, start, end, freq=1|
	var sig, ptr;
	ptr = LFDNoise1.ar(freq).range(start, end);
	sig = BufRd.ar(2, buf, ptr);
	sig = sig * amp;
	Out.ar(out, sig);
}).add;
)

g = Group.new;
x = Synth.new(\bufreadTest_noise, [\buf, ~b2.bufnum, \start, 0, \end, ~b2.numFrames -1, \freq, exprand(0.25, 3), \amp, exprand(0.2, 0.5)], g);
y = Synth.new(\bufreadTest_noise, [\buf, ~b1.bufnum, \start, 0, \end, ~b2.numFrames -1, \freq, exprand(0.75, 5), \amp, exprand(0.2, 0.5)], g);
g.set(\freq, 0.25, \amp, 0.5);



s.freeAll;

































