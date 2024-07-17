(
s.meter;
s.plotTree;
s.scope;
)
Buffer.freeAll;
~b0 = Buffer.readChannel(s, "/Volumes/Samsung 870 QVO/Tascam/DR 05X recordings/wetWater.wav", channels: [0]);
~b1 = Buffer.readChannel(s, "/Volumes/Samsung 870 QVO/Tascam/DR 05X recordings/waterNoise.wav", channels: [0]);

~b0.play;
~b1.play;

~b1.numChannels;
~b1.duration;
~b1.free;

Signal.hanningWindow(1024).plot;

(
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Impulse.ar(10),
		MouseX.kr(0.0005, 1, 1),
		[~b1,~b0],
		1,
		0.25,
		2,
		0,
		-1,
		1024
	);
}.play;
)

//dust as randomizer
(
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Dust.ar(MouseX.kr(1, 20, 1).poll),
		0.09,
		~b1,
		1,
		0.2,
		2,
		0,
		-1,
		512
	);
}.play;
)





//grain duration
s.boot;
(
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Impulse.ar({ExpRand(0.2, 4.0)}),
		2,
		[~b0,~b1],
		0.25, 5.0,
		0.2,
		2,
		0,
		-1,
		512
	);
}.play;
)




//inverse values
(
{
	var sig;
	sig = GrainBuf.ar(
		1,
		// Impulse.ar([60, 60.5]),
		//MouseX.kr(0.0001, 1, 1).poll,
		Impulse.ar({ExpRand(20, 60.5)}!12),
/*		Dust.ar({ExpRand(4, 40.5)}!48),*/
		LFNoise1.kr(0.3!12).exprange(0.02, 10.0).poll,
		b,
		1,
		0.02,
		2,
		0,
		-1,
		512
	);
	sig = Splay.ar(sig);
}.play;
)

(
{
	var sig;
	sig = GrainBuf.ar(
		1,
		// Impulse.ar([60, 60.5]),
		//MouseX.kr(0.0001, 1, 1).poll,
		//Impulse.ar({ExpRand(60, 60.5)}!12),
		Dust.ar(20!2),
		LFNoise1.kr(0.3!2).exprange(0.02, 10.0).poll,
		b,
		1,
		0.02,
		2,
		0,
		-1,
		512
	);
	sig = Splay.ar(sig);
}.play;
)


(
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Impulse.ar(10),
		0.9,
		b,
		LFNoise1.kr(0.5),
		LFNoise1.ar(0.1).range(0.1),
		2,
		0,
		-1,
		512
	);
}.play;
)

(
{
	var sig;
	sig = GrainBuf.ar(
		2,
		Dust.ar(10),
		0.5,
		b,
		1,
		LFNoise1.ar(0.1).range(0.1),
		2,
		0,
		-1,
		512
	);
	sig = sig * 0.5;
}.play;
)
