//Fieldsteel tutorial 18

//https://www.youtube.com/watch?v=ih2uqOaqb4c&list=PLPYzvS8A_rTaNDweXe6PX4CXSGq4iEWYC&index=19&t=909s


s.boot;

MIDIClient.init;
MIDIClient.destinations;
m = MIDIOut.new(3);

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
)

//midi.org



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






