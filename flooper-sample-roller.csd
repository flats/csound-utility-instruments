<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
; -iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o flooper-sample-roller.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs  = 1

instr sampleroller
/* args: 4: bpm
         5: length (in beats)
         6: loop start time in seconds
         7: intial sample length in beats
         8: ultimate sample length in beats
         9: logcurve steepness (only applies to shapes 3 and 4)
        10: ramp shape
           1: linear ramp
           2: exponential curve ramp
           3: scaled logarithmic curve ramp (speeds up more at the end)
           4: scaled exponential curve ramp (speeds up more at the beginning)
        11: cps sample rate speed - 1.5 would be a fifth up */

ibpm        = p4
isecperbeat = (60 / p4)
idursecs    = (60 / p4) * p5            ; length of roll in SECONDS
iinitialendtime = p6 + (isecperbeat * p7)
ifinalendtime = p6 + (isecperbeat * p8)

if (p10 == 1) then
  ; linear ramp
  ; flooper2 start/end times are in seconds (lposcil3 start/end times are in samples)
  kline line iinitialendtime, idursecs, ifinalendtime
  asig flooper2 .8, 1, p6, kline, 0.05, 1, 0, 0  
elseif (p10 == 2) then
  ; exponential curve ramp
  kexp expon iinitialendtime, idursecs, ifinalendtime
  asig flooper2 1, p11, p6, kexp, .1, 1
elseif (p10 == 3) then
  ; scaled logarithmic curve ramp (different curve algorithm)
  klfo lfo 1.0, 1 / idursecs, 4
  kcurve logcurve klfo, p9
  kscale scale kcurve, ifinalendtime, iinitialendtime
  asig flooper2 1, p11, p6, kscale, .01, 1
elseif (p10 == 4) then
  ; scaled exponential curve ramp (different curve algorithm)
  klfo lfo 1.0, 1 / idursecs, 4
  kcurve expcurve klfo, p9
  kscale scale kcurve, ifinalendtime, iinitialendtime
  asig flooper2 1, p11, .1, kcurve, .01, 1
endif

outs asig, asig

endin
</CsInstruments>
<CsScore>
; tempo in pairs: time, tempo
; the initial tempo value below should agree with ibpm in instr 1
t 0 120
; Its table size is deferred,
; and format taken from the soundfile header.
f 1 0 0 1 "sample-sounds/hh.wav" 0 0 1

/* Play the sampleroller instrument.
   This will loop the sample by truncating the loop sample over time.
   i "sampleroller" 0 8 tempo lengthbeats loopstartsecs initlengthbeats ultimatelengthbeats curvesteepness shape cps
   The tempo, p4, should match the t statement above. */
i "sampleroller" 0 16 120 8.00 .3 0.25 1.0 .1 3 1.0

</CsScore>
</CsoundSynthesizer>
