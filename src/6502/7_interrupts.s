;
;
;
;   -------------------------------------------


PORTB = $6000
PORTA = $6001
DDRB  = $6002
DDRA  = $6003
PCR   = $600C
IFR   = $600D
IER   = $600E

value   = $0200
mod10   = $0202
message = $0204

counter = $020A

E  = %10000000
RW = %01000000
RS = %00100000

.org $8000

init:
  LDX #$FF
  TXS

  CLI

  LDA #$82
  STA IER

  LDA #$00
  STA PCR

  LDA #%11111111
  STA DDRB

  LDA #%11100000
  STA DDRA

  LDA #%00111000
  JSR lcd_send_instruction
  LDA #%00001110
  JSR lcd_send_instruction
  LDA #%00000110
  JSR lcd_send_instruction
  LDA #%00000001
  JSR lcd_send_instruction

  LDA #0
  STA counter
  STA counter + 1

loop:
  LDA #%00000001
  JSR lcd_send_instruction

  LDA #0
  STA message

  SEI
  LDA counter
  STA value
  LDA counter + 1
  STA value + 1
  CLI

div_start:
  LDA #0
  STA mod10
  STA mod10 + 1

  CLC

  LDX #16
div_loop:
  ROL value
  ROL value + 1
  ROL mod10
  ROL mod10 + 1

  SEC
  LDA mod10
  SBC #10
  TAY
  LDA mod10 + 1
  SBC #0

  BCC decrement_index
  STY mod10
  STA mod10 + 1

decrement_index:
  DEX
  BNE div_loop

  ROL value
  ROL value + 1

  LDA mod10
  CLC
  ADC #"0"

  JSR ram_push_char

  LDA value
  ORA value + 1
  BNE div_start

  LDX #0
lcd_print:
  LDA message, x
  BEQ loop

  JSR lcd_print_char
  INX
  JMP lcd_print

number:
  .word 1729

ram_push_char:
  PHA
  LDY #0

push_char_loop:
  LDA message, y
  TAX

  PLA
  STA message, y

  INY
  TXA
  PHA

  BNE push_char_loop

  PLA
  STA message, y

  RTS

lcd_send_instruction:
  JSR lcd_check_busy_flag

  STA PORTB

  LDA #0
  STA PORTA
  LDA #E
  STA PORTA
  LDA #0
  STA PORTA

  RTS

lcd_print_char:
  JSR lcd_check_busy_flag

  STA PORTB

  LDA #RS
  STA PORTA
  LDA #E
  STA PORTA
  LDA #RS
  STA PORTA

  RTS

lcd_check_busy_flag:
  PHA

  LDA #%00000000
  STA DDRB

check_busy_flag_loop:
  LDA #RW
  STA PORTA
  LDA #(RW | E)
  STA PORTA

  LDA PORTB
  AND #%10000000
  BNE check_busy_flag_loop

  LDA #RW
  STA PORTA

  LDA #%11111111
  STA DDRB

  PLA
  RTS

nmi_handler:
irq_handler:
  PHA
  TXA
  PHA
  TYA
  PHA

  INC counter
  BNE exit_interrupt_handler
  INC counter + 1

exit_interrupt_handler:
  LDY #$FF
  LDX #$FF
interrupt_handler_delay:
  DEX
  BNE interrupt_handler_delay
  DEY
  BNE interrupt_handler_delay

  BIT PORTA

  PLA
  TAY
  PLA
  TAX
  PLA

  RTI

.org $FFFA
.word nmi_handler
.word init
.word irq_handler
