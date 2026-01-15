# Flutter Test Assignment / Flutter Testitehtävä

## Tehdyt korjaukset ja parannukset

### 1. Vanhentunut versio

**Flutter v3.38.6**

Projektin Android-projektipohja oli vanhentunut (V1 embedding), jota Flutter-versio 3.38.6 ei enää tukenut. Päivitin Android-projektipohjan **V2 embeddingiin**, jolloin projekti toimii yhteensopivasti nykyisen Flutter-version kanssa.

---

### 2. Syötteen validointi (tyhjät todot)

**Ennen:**
`_addTodo` lisäsi todo-itemin sellaisenaan, jolloin myös tyhjät tai pelkistä välilyönneistä koostuvat syötteet päätyivät listaan.

**Jälkeen:**
Lisäsin `trim()`-käsittelyn ja `isEmpty`-tarkistuksen. Jos syöte on tyhjä, todoa ei lisätä ja käyttäjälle näytetään `SnackBar`-viesti (sovelluksen pohjassa).

**Muutos:**

```dart
final trimmedTitle = title.trim();

if (trimmedTitle.isEmpty) {
  SnackBar(...);
  return;
}
```

---

### 3. Indeksivirhe toggle-toiminnossa (kaatuminen)

**Ennen:**
`_toggleTodo` käytti `indexWhere`-haun palauttamaa indeksiä suoraan. Jos id:tä ei löytynyt, `indexWhere` palautti `-1`, jolloin `_todos[-1]` aiheutti `RangeError`-kaatumisen.

**Jälkeen:**
Lisäsin suojauksen: jos indeksi on `-1`, funktio palautuu eikä sovellus kaadu.

**Muutos:**

```dart
if (index == -1) return;
```

---

### 4. Käyttöliittymän saavutettavuus (AppBar-kontrasti)

**Ennen:**
AppBarissa käytettiin:

* `backgroundColor: Colors.blue[400]`
* `foregroundColor: Colors.blue[300]`

Tekstin kontrasti oli heikko.

**Jälkeen:**
Vaihdoin `foregroundColor`-värin valkoiseksi (`Colors.white`), jolloin otsikko erottuu selkeästi ja saavutettavuus parani.

---

### 5. Koodin tyyli (tehoton pituustarkistus)

**Ennen:**

```dart
_todos.length == 0
```

**Jälkeen:**
Käytin idiomaattisempaa ja luettavampaa tapaa:

```dart
_todos.isEmpty
```

---

### 6. Testitapaukset (toiminnan varmistus)

**Ennen:**
Testit tarkistivat vain `TodoItem`-luokan ominaisuuksia (unit-tyyppinen testi), mutta eivät sovelluksen käyttöliittymää tai käyttäjäpolkuja.

**Jälkeen:**
Lisäsin **widget-testit**, jotka kattavat keskeiset käyttäjätoiminnot:

* todo lisätään ja näkyy listassa
* tyhjää todoa ei lisätä
* duplikaattia ei lisätä (case-insensitive) ja näytetään `SnackBar`
* checkboxin painaminen vaihtaa `completed`-tilan (yliviivaus)
* delete poistaa todo-itemin ja tyhjätilateksti palautuu

---

## Omat lisämuutokset (bonus)

### Duplikaattien estäminen

Lisäsin liiketoimintasäännön, joka estää samannimisten todojen lisäämisen (case-insensitive). Käyttäjälle näytetään tästä `SnackBar`-viesti (“Todo already exists”).
Tämä parantaa käyttökokemusta ja estää listan täyttymisen identtisillä riveillä.

**Muutos:**

```dart
_todos.any(
  (todo) => todo.title.toLowerCase() == trimmedTitle.toLowerCase()
)
```

---

### UI-komponentin eristäminen (TodoInput)

Eristin syötekentän ja Add-painikkeen omaksi widgetikseen (`widgets/todo_input.dart`).
Tämä selkeyttää `main.dart`-tiedostoa, helpottaa ylläpitoa ja mahdollistaa tyylityksen sekä käytöksen muuttamisen yhdestä paikasta.

---

### Moderni ja designia vastaava tyylitys

Rakensin inputin **“pill”-tyyliseksi** komponentiksi ja käytin määriteltyjä värejä (harmaa/sininen/tausta).
Komponentti reagoi syötteeseen ja fokukseen:

* reuna muuttuu siniseksi, kun kentässä on teksti tai fokus
* Add-painike on disabloitu, jos kenttä on tyhjä

---

### Resurssien vapautus

Lisäsin `dispose()`-metodin `TextEditingController`lle:

```dart
_textController.dispose();
```

Tämä on Flutterin paras käytäntö ja estää resurssivuotoja.

---

## Arviointikriteerit ja miten ne täyttyvät

* **Bugien tunnistus ja korjaus:**
  Korjattu syötteen validointi, toggle-toiminnon kaatuminen ja AppBarin kontrasti.

* **Koodin laatu / best practices:**
  `isEmpty`, selkeämmät funktiot, `dispose()`, komponenttien eristäminen.

* **Widget- ja elinkaaren ymmärrys:**
  `dispose()` ja turvalliset state-päivitykset.

* **Reunatapaukset:**
  Tyhjät syötteet, duplikaatit, puuttuvat id:t → ei kaatumista.

* **Testaus:**
  Widget-testit kattavat keskeiset käyttäjäpolut.