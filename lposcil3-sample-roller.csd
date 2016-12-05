<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
; -iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o lposcil3-sample-roller.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 88200
ksmps = 32
nchnls = 2
0dbfs  = 1

instr sampleroller
/* args: 4: bpm
         5: length (in beats)
         6: loop start time in frames
         7: intial sample length in beats
         8: ultimate sample length in beats
         9: logcurve steepness (only applies to shapes 3 and 4)
        10: ramp shape
           1: linear ramp
           2: exponential curve ramp
           3: scaled logarithmic curve ramp
           4: scaled exponential curve ramp
        11: cps sample rate speed - 1.5 would be a fifth up */

ibpm        = p4
ibeatlength = sr / (p4 / 60)            ; length of roll in beats
idursecs    = (60 / p4) * p5            ; length of roll in SECONDS
iinitialendtime = p6 + (ibeatlength * p7)
ifinalendtime = p6 + (ibeatlength * p8)

if (p10 == 1) then
  ; linear ramp
  kline line iinitialendtime, idursecs, ifinalendtime
  asig lposcil3 1, p11, p6, kline, 1
elseif (p10 == 2) then
  ; exponential curve ramp
  kexp expon iinitialendtime, idursecs, ifinalendtime
  asig lposcil3 1, p11, p6, kexp, 1
elseif (p10 == 3) then
  print idursecs
  ; scaled logarithmic curve ramp (different curve algorithm)
  klfo lfo 1.0, 1 / idursecs, 4
  kcurve logcurve klfo, p9
  kscale scale kcurve, ifinalendtime, iinitialendtime
  asig lposcil3 1, p11, p6, kscale, 1
elseif (p10 == 4) then
  ; scaled exponential curve ramp (different curve algorithm)
  klfo lfo 1.0, 1 / idursecs, 4
  kcurve expcurve klfo, p9
  kscale scale kcurve, ifinalendtime, iinitialendtime
  asig lposcil3 1, p11, p6, kscale, 1
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
f 1 0 0 1 "sample-sounds/drumset-pattern.wav" 0 0 0

/* Play the sampleroller instrument.
   This will loop the drum pattern by truncating the loop sample over time.
   The tempo, p4, should match the t statement above. */
i "sampleroller" 0 16 120 16 10000 8 0.125 10.0 3 1.5

</CsScore>
</CsoundSynthesizer>
