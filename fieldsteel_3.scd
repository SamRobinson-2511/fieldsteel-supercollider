s.boot;

//SynthDef: recipe for particular sound
//Synth: execution of synth

(
z = {
	|noiseHz=8|
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
	amp = LFNoise1.kr(12).exprange(0.02, 1);
	sig = SinOsc.ar(freq) * amp;
}.play;
)

z.free;

//must include out
(
SynthDef.new(\sineTest, {
	|noiseHz=8|
	var freq, amp, sig;
	freq = LFNoise0.kr(noiseHz).exprange(200, 1000);
	amp = LFNoise1.kr(12).exprange(0.02, 1);
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0, sig); //must include for SynthDef
}).add;
)

x = Synth.new(\sineTest, [\noiseHz, 21]); //array of args
x.set(\noiseHz, 12);
x.free;

(
SynthDef.new(\pulseTest, {
	|ampHz=4, fund=40, maxPartial=4, width=0.5|
	var amp1, amp2, freq1, freq2, sig1, sig2;
	amp1 = LFPulse.kr(ampHz, 0, 0.12) * 0.75;
	amp2 = LFPulse.kr(ampHz, 0.5, 0.12) * 0.75;
	freq1 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round;
	freq2 = LFNoise0.kr(4).exprange(fund, fund*maxPartial).round;
	freq1 = freq1 * LFPulse.kr(8, add:1);
	freq2 = freq2 * LFPulse.kr(6, add:1);
	sig1 = Pulse.ar(freq1, width, amp1);
	sig2 = Pulse.ar(freq2, width, amp1);
	sig1 = FreeVerb.ar(sig1, 0.7, 0.8, 0.25);
	sig2 = FreeVerb.ar(sig2, 0.7, 0.8, 0.25);
	Out.ar(0, sig1);
	Out.ar(1, sig2);
}).add;
)

x = Synth.new(\pulseTest);
x.set(\width, 0.25);
x.set(\fund, 60);
x.set(\ampHz, 8);
x.set(\maxPartial, 20);

x.free;

x = Synth.new(\pulseTest, [\ampHz, 3.3, \fund, 48, \maxPartial, 4, \width, 0.15]);
