'''
Tämä tiedosto luo ROM-tiedoston(rom.bin) 65c02-tietokonetta varten. 

(Konekieltä käsin kirjoitettuna)

Ohjelma alustaa I/O-ohjainpiirin siten, että sen portit ovat ulostuloja.
Sen jälkeen ohjelma kirjoittaa vuorotellen kahta eri bittikuviota ulostuloon LEDeille.
'''
code = bytearray([

  0xA9, 0xFF,  # LDA #$FF
  0x8D, 0x02, 0x60, #STA $6002

  # LEDien vilkutus silmukka alkaa tästä
  0xA9, 0x55, # LDA #$55 Ledien bittikuvio 01010101, hexana 55
  0x8D, 0x00, 0x60, # STA $6000
  0xA9, 0xAA, # LDA #$AA Ledien bittikuvio 10101010
  0x8D, 0x00, 0x60, # STA $6000

  0x4C, 0x05, 0x80, # JMP $8005 (silmukan alkuun)
])

# EEPROMin muisti täyteetään NOP-käskyillä (0xEA)
rom = bytearray([0xEA] * (32768 - len(code)))

# Reset-vektori (CPU lukee tämän käynnistyessä.
# Kirjoitetaan ROMiin kaksi tavua(0x8000), joista 6502 lukee 
# käynnistyessään, mistä osoitteesta ohjelman suoritus
# aloitetaan.
rom[0x7FFC] = 0x00
rom[0x7FFD] = 0x80

with open("rom.bin", "wb") as out_file:
  out_file.write(rom)