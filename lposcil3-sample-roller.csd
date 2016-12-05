<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac      ;;;realtime audio out
;-iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o lposcil3-sample-roller.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 88200
ksmps = 32
nchnls = 2
0dbfs  = 1

instr sampleroller
; args: 4: bpm
;       5: total beats
;       6: loop start time in frames
;       7: intial sample length in beats
;       8: ultimate sample length in beats
;       9: logcurve steepness
;      10: cps sample rate speed - 1.5 would be a fifth up

ibpm        = p4
ibeatlength = sr / (p4 / 60)            ; length of roll in beats
idursecs    = (60 / p4) * p5            ; length of roll in SECONDS
iinitialendtime = p6 + (ibeatlength * p7)
ifinalendtime = p6 + (ibeatlength * p8)

kloop = 10000   ; loop start time in samples
kend  = 30000   ; loop end time in samples

; kexp expon iinitialendtime, idursecs, ifinalendtime
; kline line iinitialendtime, idursecs, ifinalendtime

klfo lfo 1.0, 1 / idursecs, 4
kcurve logcurve klfo, p9
; kcurve expcurve klfo, 10.0
kscale scale kcurve, ifinalendtime, iinitialendtime

; asig lposcil3 1, kcps, istarttime, kline, 1     ; use linear ramp
; asig lposcil3 1, kcps, istarttime, kexp, 1      ; use exponential ramp
asig lposcil3 1, p10, p6, kscale, 1            ; use variable exponential ramp
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

; Play the sampleroller instrument.
; This will loop the drum pattern by truncating the loop sample over time.
; The tempo, p4, should match the t statement above.
i "sampleroller" 0 32 120 16 10000 8 0.125 10.0 1.5

</CsScore>
</CsoundSynthesizer>
