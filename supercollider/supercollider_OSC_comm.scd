

s.plotTree;
s.meter;

(
s.boot;

/*
  Define the synth "chipper", test it with a single call,
  initialize the array of midi notes we use for the sketch,
  and define the OSC operation
*/
(
SynthDef(\chipper, {
	arg t_trig=1, atk=0.01, rel=0.5, crv= -3, freq = 45,
	noise=31, control=3, vola=15, volb=7, volc=3, envfreq=3000, chipType=1;
	var synth, vol, pitch, amp, env, h1, h2;
	freq = freq.midicps;
	h1 = TIRand.kr( 2, 3, Impulse.kr(1) );
	h2 = TIRand.kr( 2, 7, Impulse.kr(1) );
	env = EnvGen.ar(Env.perc(atk, rel, 1, crv), t_trig, doneAction:2);
	synth = AY.ar( AY.freqtotone(freq), AY.freqtotone(freq*h1), AY.freqtotone(freq*h2), noise, control, vola, volb, volc,
	envfreq, chiptype:1);
	synth = synth*env*0.3;// * amp
	Out.ar(0,  [synth, synth] * 0.5);
}).add;
)

(
x = Synth.new(
	\chipper
);
)




NetAddr.localAddr;

(
~notes = Array.with(
	64,66,68,71,73,75,78
) ;

OSCdef(\ball, {
	arg msg, note, rel;
	note = (~notes[msg[1]]).postln;
	Synth(\chipper, [freq: note, t_gate: 1]);

}, "ball");
)

)



