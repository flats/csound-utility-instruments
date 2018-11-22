<CsoundSynthesizer>
; Usage:
; csound midi-sampler-player.csd -o dac -M0 -b8
<CsOptions>
-odac      ;;;realtime audio out
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 8
nchnls = 2
0dbfs  = 1

instr 1

kamp  = .9
kcps  = 1
ifn   = 1
ibas  = 1

kenv linsegr 0.5, 3, 5, 3, 0
kenv expcurve kenv, 8
aenv interp kenv

inum notnum

asig loscil kamp * aenv, 1, ifn, ibas

outs asig, asig

endin
</CsInstruments>
<CsScore>
; dummy statement for real-time MIDI/audio
f 0 3600
f 1 0 0 1 "sample-sounds/sds-01.7-edit.wav" 0 0 1

</CsScore>
</CsoundSynthesizer>
