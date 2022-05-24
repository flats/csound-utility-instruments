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
giosc1 OSCinit 7401

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
ihalfdursecs  = idursecs / 2
iinitialendtime = p6 + (isecperbeat * p7)
ifinalendtime = p6 + (isecperbeat * p8)
ileft_f_table_length = ftlen(1)
iright_f_table_length = ftlen(2)
kwii_pitch init 0.0
kwii_a_button init 0.0
kwii_max_range init 1.2
kwii_min_range init 0.001
kwii_a_button_max_range init 0.6
kwii_a_button_min_range init 0.001
kwii_2_pitch init 0.0
kwii_2_a_button init 0.0
kwii_2_max_range init 1.2
kwii_2_min_range init 0.001
kwii_2_a_button_max_range init 0.6
kwii_2_a_button_min_range init 0.001
kstart_scale init 0.0

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
elseif (p10 == 5) then
  ; wiimote control using osculator
  kwii_pitch_ans OSClisten giosc1, "/wii/1/accel/pry/0", "f", kwii_pitch
  kwii_2_pitch_ans OSClisten giosc1, "/wii/2/accel/pry/0", "f", kwii_2_pitch
  ; kwii_pitch_a_button_ans OSClisten giosc1, "/wii/1/button/A", "f", kwii_a_button
  ; kwii_2_pitch_a_button_ans OSClisten giosc1, "/wii/2/button/A", "f", kwii_2_a_button
  ; kwii_max = (kwii_a_button == 1.0) ? kwii_a_button_max_range : kwii_max_range
  ; kwii_2_max = (kwii_a_button == 1.0) ? kwii_2_a_button_max_range : kwii_2_max_range
  ; kwii_min = (kwii_a_button == 1.0) ? kwii_a_button_min_range : kwii_min_range
  ; kwii_2_min = (kwii_a_button == 1.0) ? kwii_2_a_button_min_range : kwii_2_min_range
  ; kscale scale kwii_pitch, ifinalendtime, p6
  kscale scale kwii_pitch, (ileft_f_table_length / 44100), p6
  ; kscale_2 scale kwii_2_pitch, ifinalendtime, p6
  kscale_2 scale kwii_2_pitch, (iright_f_table_length / 44100), p6
  ; kstart_scale = p6 + (kscale * .35)
  asigL flooper2 .5, p11, kscale_2, kscale, .01, 1
  asigR flooper2 .5, p11, kscale_2, kscale, .01, 2
  ; kdelayedscale vdel_k kscale, (kscale * (idursecs / 2))
  
  ; asig2 flooper2 1, p11, p6, kdelayedscale, .01, 1
endif

if (p10 == 5) then
  outs asigL, asigR
else
  outs asig, asig
endif

endin
</CsInstruments>
<CsScore>
; tempo in pairs: time, tempo
; the initial tempo value below should agree with ibpm in instr 1
t 0 72
; Its table size is deferred,
; and format taken from the soundfile header.
; f 1 0 176400 1 "sample-sounds/snare_click.wav" 0 0 1
; f 1 0 176400 1 "sample-sounds/eleanore-fricke-hhc-with-trailing-silence.wav" 0 0 1
; f 1 0 176400 1 "sample-sounds/Juno 71 Sampler Low E.wav" 0 0 1
f 1 0 0 1 "sample-sounds/Gesture.L.wav" 0 0 1
f 2 0 0 1 "sample-sounds/Gesture.R.wav" 0 0 1
; f 1 0 176400 1 "sample-sounds/hh.wav" 0 0 1
; f 1 0 176400 1 "sample-sounds/Juno-106_A78_C#.wav" 0 0 1

/* Play the sampleroller instrument.
   This will loop the sample by truncating the loop sample over time.
   i "sampleroller" 0 8 tempo lengthbeats loopstartsecs initlengthbeats ultimatelengthbeats curvesteepness shape cps
   The tempo, p4, should match the t statement above. */
i "sampleroller" 0 1200.0 72 12.0 0 0.125 3.5 0.85 5 0.5

</CsScore>
</CsoundSynthesizer>
