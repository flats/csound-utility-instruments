<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

; constant freq lfo
instr 1

kcps = 8.66667 ; lfo freq
itype = p4 ; lfo type
klfoamp = 1 ; lfo amp

; constant rate/amp lfo
klfo 		lfo klfoamp, kcps, itype

; base oscillator
asig 		poscil klfo, 220, 1

; resonant filter
kcf 		init 1000
kbw 		init 100
kres		lineto 1 - klfo, 1 / kcps
ares 		areson asig, kcf, kbw

; compression
acomp		compress ares, ares, -8, 40, 60, 3, 0, 0.1, .05

		outs acomp, acomp

endin

; tempo curve lfo
instr 2

itype = p4 ; lfo type
klfoamp = 1 ; lfo amp
itempo = p5 ; tempo for calculating tempo curves

; calculating total time, beat length, etc.
ibeatspersec = (itempo / 60)
isecsperbeat = 1 / ibeatspersec
i8beatlength = 8 * isecsperbeat
itotallength = i8beatlength + isecsperbeat

; exponential ramp for tempo
ktempolfo	lfo 1.0, 1 / itotallength, 4
kcurve	expcurve ktempolfo, 1.01
kscale 	scale kcurve, ibeatspersec * p6, ibeatspersec * p7

; p6 is starting note value, p7 is ending note value

; constant rate/amp lfo
klfo 		lfo klfoamp, kscale, itype

; base oscillator
asig 		poscil klfo, 220, 1

; resonant filter
kcf 		init 1000
kbw 		init 100
kres		lineto 1 - klfo, 1 / kscale
ares 		areson asig, kcf, kbw

; compression
acomp		compress ares, ares, -8, 40, 60, 3, 0, 0.1, .05

		outs acomp, acomp

endin

</CsInstruments>
<CsScore>

; sine wave.
f 1 0 32768 10 1

;i 1 0 3 0 ;lfo = sine
;i 1 + 3 2 ;lfo = square
;i 1 + 3 5 ;lfo = saw-tooth down e

i 2 0 6 5 130 4 8 ;lfo = saw-tooth down e

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
