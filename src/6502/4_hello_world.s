;
;  RAM(HM62256B) muisti 0x0000 to 0x3FFF
;  -> Tarvitaan pinoa(stack) varten  
;
;  I/O-ohjainpiiri muisti 0x6000 to 0x7FFF
;  → Käytetään ulostulojen (esim. LCD) ohjaamiseen.
;    VIA:n rekisterit ovat 0x6000–0x600F.
;      PORTA:ssa ohjausbittien signaalit (E, RW, RS),
;      PORTB:ssä LCD:n databitit (D0–D7).
;
;  ROM muisti 0x8000 to 0xFFFF
;
;  Tämä koodi näyttää Hello world! LCD-näytöllä,
;  mutta tarvitsee RAMin toimiakseen, koska käyttää
;  pinoa(stack)
;
; ----------------------------------------------------

; VIA-porttien osoitteet
PORTB = $6000 ; LCDn data D0-D7
PORTA = $6001 ; LCDv ohjaus E, RW, RS
DDRB = $6002 ; Portti B:n suuntarekisteri
DDRA = $6003 ; Portti A:n suuntarekisteri

; Portti An ohjausbittien maskit
E = %10000000   ; E (Enable)
RW = %01000000  ; R/W (Read/Write)
RS = %00100000  ; RS (Register select)

  ; Asetetaan ohjelman alku EEPROM-alueelle
  .org $8000

init:
  ; Pinon(stack) alustus.
  LDX #$FF   ; Stackin osoitin arvoon $FF TODO: onko tää hexa ja mikä?
  TXS

  ; Porttien suunnan asetus ;

  ; Kaikki portti Bn bitit ulostuloiksi
  LDA #%11111111
  STA DDRB

  LDA #%11100000   ; Portti An kolme ylintä bittiä ulostuloiksi(E,RW,RS)
  STA DDRA


  ;; LCDn alustus ;;

  LDA #%00111000            ; 8-bit tila, 2 riviä, 5x8 fontti
  JSR lcd_send_instruction  ; TODO: aliohjelmakutsuko?
  LDA #%00001110            ; näyttö päälle, kursori päälle, ei vilkkua
  JSR lcd_send_instruction
  LDA #%00000110            ; kursori siirtyy oikealle, näyttö ei liiku
  JSR lcd_send_instruction

  ;; Teksitn tulostus LCDlle ;;

  LDA #"H"            ;'H'
  JSR lcd_print_char
  LDA #"e"            ;'e'
  JSR lcd_print_char
  LDA #"l"            ;'l'
  JSR lcd_print_char
  LDA #"l"            ;'l'
  JSR lcd_print_char
  LDA #"o"            ;'o'
  JSR lcd_print_char
  LDA #","            ;','
  JSR lcd_print_char
  LDA #" "            ;' '
  JSR lcd_print_char
  LDA #"w"            ;'w'
  JSR lcd_print_char
  LDA #"o"            ;'o'
  JSR lcd_print_char
  LDA #"r"            ;'r'
  JSR lcd_print_char
  LDA #"l"            ;'l'
  JSR lcd_print_char
  LDA #"d"            ;'d'
  JSR lcd_print_char
  LDA #"!"            ;'!'
  JSR lcd_print_char

loop:
  JMP loop      ; Hypätään ikuiseen silmukkaan

  ;; Aliohjelmat ;;
  
lcd_send_instruction:
  ; TODO: mitä tämä aliohjelma tekkee?

  STA PORTB      ; Store Accumulator PORTB

  ;; Enable-pulssi ;;
  ;; LCD-näyttö ei lue datalinjoja koko ajan,
  ;; vain Enable-signaalin aikana.
  LDA #0         ; E = 0, lähtötila
  STA PORTA
  LDA #E         ; E = 1, LCD lukee datan
  STA PORTA
  LDA #0         ; E = 0, lähetys päättyy ja LCD suorittaa käskyn
  STA PORTA

  RTS            ; Paluu aliohjelmasta

lcd_print_char:
  ; Tämä aliohjelma lähettää LCDlle yhden merkin.

  STA PORTB     ; Store Accumulator PORTB
  LDA #RS       ; RS = 1 -> data (merkki)
  STA PORTA
  LDA #E        ; E = 1 -> LCD lukee datan
  STA PORTA
  LDA #RS       ; RS = 1, E = 0 -> palautus, merkki vahvistuu näytölle
  STA PORTA

  RTS           ; Paluu aliohjelmasta

  .org $FFFC
  .word init   ; CPU aloittaa suorituksen init osoitteesta->reset-vektori

  .word $0000  ; Vikat kaksi tavua