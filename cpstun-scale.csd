<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac ; realtime audio out and realtime midi in (use `csound -M#{MIDICONTROLLERNUM} file.csd)
; -iadc    ;;;uncomment -iadc if realtime audio input is needed too
; For Non-realtime ouput leave only the line below:
; -o lposcil3-sample-roller.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 88200
ksmps = 32
nchnls = 2
0dbfs  = 1

; p5 is notes per octave, p6 is number of octaves exclusive (2 is 1 octave), p7 is basefreq in CPS, p8 is basekeymidi in MIDI note value
; this is Fokker's 7-limit 12-tone just scale
gitemp ftgen 1, 0, 64, -2, 12, 2, 261.659, 60, 15/14, 9/8, 7/6, 5/4, 4/3, 45/32, 3/2, 45/28, 5/3, 7/4, 15/8, 2

instr cpstun_scale
; ftsave "table1.ftsave", 1, 1 ; save the tuning table to a function table save file (in text format)

inote_number          notnum
                      print inote_number
iamp                  ampmidi 0dbfs * 0.001 ; get the amplitude
                      print iamp
kfreq cpstun iamp, inote_number, 1
asig oscili iamp, kfreq, -1

outs asig, asig

endin
</CsInstruments>
<CsScore>
</CsScore>
</CsoundSynthesizer>
