;------------------------------------------------------------------
; Kirjoitetaan Assemblyllä samalla tyylillä ledit vilkkumaan
; nyt eri tavalla
;
; EEPROM on muistialueessa 0x8000-0x8000–0xFFFF
; -> tänne tallennetaan ohjelmakoodi
;
; I/O-ohjainpiiri on muistialueessa 0x6000-0x7FFF
; -> tähän osoiteavaruuteen kirjoittaminen ohjaa ulkoisia laitteita
;-------------------------------------------------------------------

  ; origin directive: kertoo assemblerille mihin alla olevat
  ; koodit tulee sijoittaa muistissa 
  .org $8000

  ; init on aloituskohta, johon CPU hyppää resetin jälkeen. 
  ; Tässä ladataan VIAn PB-rekisteriin 11111111,
  ; joka määrittää kaikki portin B bitit ulostuloiksi
init:
  LDA #$FF     ; load accumulator, lataa rekisteriin 0xFF(11111111)
  STA $6002    ; store accumulator, tallentaa VIAn PB-rekiteriin.

  LDA #$50     ; 0x50 (01010000). Määrää mitkä LEDit syttyy ensin
  STA $6000    ; Tallennetaan VIAn porttiin B (0x6000)

loop:
  ROR          ; Rotate right (siirtää bitit yhden askeleen oikealle)
  STA $6000    ; Tallennetaan porttiin B. Bittikuvio päivittyy

  JMP loop     ; Hypätään alkuun

  .org $FFFC   ; kirjoitetaan muistipaikkaan 0xFFFC(65C02 reset-vektori)
  .word init   ; kirjoita init-osoite (0x8000) muistiin

  .word $0000