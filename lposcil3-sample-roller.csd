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

instr 1

ibpm        = 120                       ; should agree w/ t in the score
ibeatlength = sr / (ibpm / 60)
itotalbeats = 12                        ; length of roll in beats
idursecs    = (60 / ibpm) * itotalbeats ; length of roll in SECONDS
istarttime  = 10000                     ; loop start time in frames
istartbeats = 8                         ; initial sample length in beats (.5 is 1/8th note)
iendbeats   = .25                      ; final sample length in beats
iinitialendtime = istarttime + (ibeatlength * istartbeats)
ifinalendtime = istarttime + (ibeatlength * iendbeats)

kcps  = 1.5     ; a fifth up
kloop = 10000   ; loop start time in samples
kend  = 30000   ; loop end time in samples

; kexp expon iinitialendtime, idursecs, ifinalendtime
; kline line iinitialendtime, idursecs, ifinalendtime

klfo lfo 1.0, 1 / idursecs, 4
kcurve logcurve klfo, 10.0
; kcurve expcurve klfo, 10.0
kscale scale kcurve, ifinalendtime, iinitialendtime

; asig lposcil3 1, kcps, istarttime, kline, 1     ; use linear ramp
; asig lposcil3 1, kcps, istarttime, kexp, 1      ; use exponential ramp
asig lposcil3 1, kcps, istarttime, kscale, 1      ; use variable exponential ramp
     outs asig, asig

endin
</CsInstruments>
<CsScore>
; tempo in pairs: time, tempo
; the initial tempo value below should agree with ibpm in instr 1
t 0 60
; Its table size is deferred,
; and format taken from the soundfile header.
f 1 0 0 1 "sample-sounds/drumset-pattern.wav" 0 0 0

; Play Instrument #1 for 6 seconds.
; This will loop the drum pattern with the loop length becoming shorter for faster repitition.
i1 0 8

</CsScore>
</CsoundSynthesizer>
