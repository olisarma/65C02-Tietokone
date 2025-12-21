"""
6502-prosessorissa on A-rekisteri(Accumulator)
-> LDA(Load Accumulator) käsky lataa arvon A-rekisteriin.
-> STA(Store Accumulator) käsky tallentaa A-rekisterin arvon muistiin.

->A9 = LDA-immediate käsky(löytyy data-lehdestä), joka lataa A-rekisteriin arvon.
-> 8D = STA-absolute käsky(löytyy data-lehdestä), joka tallentaa A-rekisterin arvon annettuun muistiosoitteeseen.

Koodi tekee seuraavan:
8000 r -> a9
8001 r -> 42
8002 r -> 8d
8003 r -> 00
8004 r -> 60
6000 W -> 42 tallennettu muistiin

"""

rom = bytearray([0xEA] * 32768)

rom[0] = 0xA9 # LDA-immediate käsky
rom[1] = 0x42 # arvo 42 ladattu A-rekisteriin

rom[2] = 0x8D # STA-absolute käsky
rom[3] = 0x00
rom[4] = 0x60 # osite johon tallennetaan A-rekisterin arvo

# aloitus osoite 0x8000
rom[0x7FFC] = 0x00
rom[0x7FFD] = 0x80

with open("rom.bin", "wb") as out_file:
  out_file.write(rom)