; 
;  EEPROM (AT28C256) on muistialueessa 0x8000–0xFFFF
;
;  I/O-ohjainpiiri(W65C22 VIA) on muistialueessa 0x6000-0x7FFF

;  VIAn rekisterit ovat alueessa 0x6000-0x600F
;  PORTA: ohjausbitit (E, RW, RS)
;  PORTB: databitit (LCDn D0-D7)
;
;  Tämä ohjelma tulostaa näytölle tekstin Hello World:)!
;  
;  ----------------------------------------------------------------------

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
  ; Porttien suunnan asetus

  ; Kaikki portti Bn bitit ulostuloiksi
  LDA #%11111111
  STA DDRB

  LDA #%11100000   ; Portti An kolme ylintä bittiä ulostuloiksi (E, RW, RS)
  STA DDRA

  ;;; LCDn alustus ;;;

  LDA #%00111000   ; LCDn 8-bit tila, 2riviä, 5x8 fontti
  STA PORTB

  ;; Enable-pulssi ;;
  ;; LCD-näyttö ei lue datalinjoja koko ajan,
  ;; vain Enable-signaalin aikana.
  LDA #0           ; E = 0, lähtötila
  STA PORTA
  LDA #E           ; E = 1, LCD lukee datan
  STA PORTA
  LDA #0           ; E = 0, lähetys päättyy ja LCD suorittaa käskyn
  STA PORTA

  LDA #%00001110   ; Näyttö päälle, kursori päälle, ei vilkkua
  STA PORTB
  LDA #0
  STA PORTA
  LDA #E
  STA PORTA
  LDA #0
  STA PORTA

  LDA #%00000110 ; kursori siirtyy oikealle, näyttö ei liiku
  STA PORTB
  LDA #0
  STA PORTA
  LDA #E
  STA PORTA
  LDA #0
  STA PORTA

  ;;; Tekstin tulostus näytölle ;;;

  LDA #"H"      ; ascii koodi kirjaimelle 'H'
  STA PORTB
  LDA #RS       ; RS = 1 -> data (merkki)
  STA PORTA
  LDA #E        ; E = 1 -> LCD lukee datan
  STA PORTA
  LDA #RS       ; RS = 1, E = 0 -> palautus, merkki vahvistuu näytölle
  STA PORTA

  LDA #"e" ; ascii koodi kirjaimelle 'e'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"l" ; ascii koodi kirjiamelle 'l'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"l" ; ascii koodi kirjaimelle 'l'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"o" ; ascii koodi kirjaimelle 'o'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"," ; ascii koodi kirjaimelle ','
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #" " ; ascii koodi kirjaimelle ' '
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"w" ; ascii koodi kirjaimelle 'w'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"o" ; ascii koodi kirjaimelle 'o'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"r" ; ascii koodi kirjaimelle 'r'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"l" ; ascii koodi kirjaimelle 'l'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"d" ; ascii koodi kirjaimelle 'd'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  LDA #"!" ; ascii koodi merkille '!'
  STA PORTB
  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA


loop:
  JMP loop     ; ikuinen silmukka

  .org $FFFC
  .word init   ; CPU aloittaa suorituksen init osoitteesta

  .word $0000  ; Vikat kaksi tavua