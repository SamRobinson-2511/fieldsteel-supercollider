128.tempodur;
128.28.tempodur;

0.8.durtempo;
60.midicps;
0.5.ampdb;

(60/144)

TempoClock.new(144/60).beatDur;

(
~tempodur = {
	|bpm|
	60/bpm
};
)

~tempodur.(144);

Platform.userExtensionDir;
Platform.systemExtensionDir;


a = Array.series(8, 1, 3);
a.reverse;
a.scramble;



//Tutorial 23
(
var env, numSegs = 16;
env = Env(
	{rrand(-1.0, 1.0)}!(numSegs + 1),
	{exprand(1, 10)}!numSegs,
	{rrand(-4.0, 4.0)!numSegs}
);
env.plot;
)

Env.rand(12, 5, false).plot;

62.play;


//Pseudo-UGen
/*(
SynthDef(\reverb, {
	|in=0, dec=3.5, mix=0.08, lpf1=2000, lpf2=6000, predel=0.025, out=0|
	var dry, wet, sig;
	dry = In.ar(in, 2);
	wet = In.ar(in, 2);
	wet = DelayN.ar(wet, 0.5, predel.clip(0.0001, 0.5));
	wet = 16.collect{
		var temp;
		temp = CombL.ar(
			wet,
			0.1,
			LFNoise1.kr({ExpRand(0.02, 0.04)}!2).exprange(0.02, 0.099),
			dec
		);
		temp = LPF.ar(temp, lpf1);
	}.sum * 0.25;
	8.do{
		wet = AllpassL.ar(
			wet,
			0.1,
			LFNoise1.kr({ExpRand(0.02, 0.04)}!2).exprange(0.02, 0.099),
			dec
		);
	};
	wet = LeakDC.ar(wet);
	wet = LPF.ar(wet, lpf2, 0.5);
	sig = dry.blend(wet, mix);
	Out.ar(out, sig);
}).add;
)*/

(
SynthDef(\reverb, {
	|in=0, dec=3.5, mix=0.08, lpf1=2000, lpf2=6000, predel=0.025, out=0|
	var sig;
	sig = In.ar(in, 2);
	sig = VerbEF.ar(sig, dec, mix, lpf1, lpf2, predel);
	Out.ar(out, sig);
}).add;
)

b = Bus.audio(s, 2);
r = Synth(\reverb, [\in, b]);
r.set(\mix, 0.6);
r.set(\dec, 10);
r.set(\lpf2, 4000);
86.play(b);


//GUI
// (
// var win;
// win = Window("", Window.screenBounds, false, false);
// win.view.background_(Color.black);
// win.view.keyDownAction_({
// 	|view, char, mod, uni|
// 	if(uni == 27, {win.close});
// });
// win.front;
// )

Window.blackout;

(
var color, window, palette;

color = Color(0.8, 0.8, 0.8);
window = Window("ColorEF", Rect(50, 50, 210, 160)).front;

Knob(window, Rect(10, 10, 40, 40))
.mode_(\vert)
.value_(color.red)
.color_([Color.red])
.action_({
	|view|
	color.red_(view.value);
	palette.background_(color)
});

Knob(window, Rect(10, 60, 40, 40))
.mode_(\vert)
.value_(color.green)
.color_([Color.green])
.action_({
	|view|
	color.green_(view.value);
	palette.background_(color)
});

Knob(window, Rect(10, 110, 40, 40))
.mode_(\vert)
.value_(color.blue)
.color_([Color.blue])
.action_({
	|view|
	color.blue_(view.value);
	palette.background_(color)
});

palette = View(window, Rect(60, 10, 140, 140))
.background_(color);
)


c = ColorEF.make;
c.close;

ColorEF.browse;









