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

; BopPad Quadrants to Notes: A 61, B 64, C 63, D 60

instr 1

kamp  = .9
kcps  = 1
ibas  = 1

kenv linsegr 0.5, 0.5, 5, 3, 0
kenv expcurve kenv, 8
aenv interp kenv

inum notnum
print inum

if (inum == 61) then
  asig loscil kamp * aenv, 1, 1, ibas
endif

if (inum == 64) then
  asig loscil kamp * aenv, 1, 2, ibas
endif

if (inum == 63) then
  asig loscil kamp * aenv, 1, 3, ibas
endif

if (inum == 60) then
  asig loscil kamp * aenv, 1, 4, ibas
endif

outs asig, asig

endin
</CsInstruments>
<CsScore>
; dummy statement for real-time MIDI/audio
f 0 43200
f 1 0 0 1 "sample-sounds/eleanore-fricke-hhc.wav" 0 0 1
f 2 0 0 1 "sample-sounds/eleanore-fricke-snare.wav" 0 0 1
f 3 0 0 1 "sample-sounds/eleanore-snare.wav" 0 0 1
f 4 0 0 1 "sample-sounds/eleanore-clave.wav" 0 0 1

</CsScore>
</CsoundSynthesizer>
