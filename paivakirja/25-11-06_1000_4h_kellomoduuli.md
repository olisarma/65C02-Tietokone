## 2025-11-06   10.00 4h Kellomoduuli

### A-Stabiili kello
Rakensimme 555-ajastimeen perustuvan a-stabiilin kellon. Ymmärsin, että ajatus perustuu kondensaattorin lataukseen ja purkautumiseen, sekä kahteen vertailtavaan virtaan(1/3vcc ja 1/3vcc), jotka ohjaavat 555-timerin sisäistä flipfloppia. Opin myös lukemaan komponenttien data-lehtiä, tutkiessani 555-kellon toimintaa.

Kellon potentiometrissä joku kosketushäikkä, mikä ei korjaantunut.

### Mono-ja 

Tässä kytkennässä 555 toimii bi-stabiilina flipfloppina. 555 on kytkettynä kytkimeen, jota painamalla signaali menee high tai low. Tämän avulla pystytään myöhemmin seuraamaan koneen suoritusta askel kerrallaan, mikä tekee virheiden löytämisestä myös helpompaa.

### Bi-stabiili kello

Tämän vaiheen idea oli lisätä moduuli, joka vaihtaa kellon pulssia kahden kellon välillä(mono-ja bi-stabiilin).

### Kellojen logiikan yhdistys

Kellojen logiikan yhdistämiseksi käytettiin kolmea eri logiikkapiiriä:
-74LS04 -> Hex-inverter, joka sisältää 6kpl NOT-portteja
-74LS08 -> Quad 2-input AND gate, joka sisältää 4kpl 2 tuloisia AND-portteja
-74LS32 -> Quad input OR gate, joka sisältää 4kpl 2-tuloisia OR-portteja.

Logiikkapiirien toiminta, oli helppo ymmärtää niiden data-lehtien avulla. Tästä vaiheesta opin että HALT-signaali estää kellopulssien etenemisen prosessorille, mikä mahdollistaa kellosignaalin pysäyttämisen ja manuaalisen askelluksen, ilman että kello nollaantuu.
