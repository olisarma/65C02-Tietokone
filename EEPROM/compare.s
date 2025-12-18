;Kirjoitetaan Assemblyllä samalla tyylillä ledit vilkkumaan nyt  eri tavalla

  .org $8000

init:
  LDA #$FF
  STA $6002

  LDA #$50
  STA $6000

loop:
  ROR 
  STA $6000

  JMP loop

  .org $FFFC
  .word init

  .word $0000