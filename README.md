# Ashnazg - Black Speech based names and text generator

Based on ideas from **Craig Daniel**'s "A SECOND OPINION ON THE BLACK SPEECH" (http://folk.uib.no/hnohf/blackspeech.htm)

## Examples

```ShellSession
$ ashnazg
Obamb
Ozghûrz
Impbimb
Sugos
Amûmp
âskimb
Lûlârz
Kauzuth
Othhon
Idos
$ ashnazg --word
dad
tozal
zusump
hor
mûtuham
doloshâl
tusâth
hop
skâzis
nirzânkâb
$ ashnazg --sentence --times=5
Sobidirz ghûkusob nârz shâmûb tûs!
Kukambûnk mun zumuk ghûmpusâz mûnk ras...
Bolâlûk lank thrûs duth boshosâz mod huhothûn.
Shogâs thraluhûp kulûzgonk!
Bonkozg ghilâth throhis rirzuh madât.
$ ashnazg --paragraph --times=3 | fmt -t
     Hanidan ghuzgûn kâmpah thoh nub! Gâpûruk mûmârzaz
ghozgurzârz zâgh kithozg. Ram ghanazgâl mamb tânûghâk tompompim
siral. Kin skalihaz tin hithirir mâthosh... Bubamp thâp ghâzgan
hosûnûgh. Gambûth râhân skopidonk! Shûzgom mâk zambipat skur
rabûbir kûb. Bagigh glup thamp krimathush. Nâl ridip ghurzazg râmok
ghûp... Bâpombâh subasûd skakolal glugân skam. Mâg sâshût dûmâm
shurizg? Kushahûp glûnamb krânâb rus... Krozgâsh thût lonkunoz
kripunk sonkûlus shut...
    Krâl thibidûsh sûnkithap... Sud tûnût kunkighum tumb bûhûdoh
birat pibâz. Pur lul kûpâb ragot. Mûdip tip dûrânk gloshinam
skobir thûrzirirz! Sotink bisâhik tighughâr... Haghothar bagâthâsh
glûzgakâgh dib roshûhin hârz. Ghokâz zis hobazgugh.
    Sorûtimb soh hâlûzgom glighûn kranupun sûghizgog kat. Gâgith
glarûshurz rushas... Monkoth magh glim glirzit glikâlip thrit
mirzushigh. Lâhozûmp thor kûmbugh thrâriz gluthimp sâb? Kozgorarz
rûk nuk. Glurzinkod gloz ladân skusosh thânk puth? Dûbûmb ghom
luzgapâm doghonk.
```

## Options

```
Usage: ashnazg TARGET [OPTIONS]

TARGETS:
      --syllable	     generate syllable
  -n  --name		     generate name
  -w  --word		     generate word
  -s  --sentence	     generate sentence
  -p  --paragraph	     generate paragraph

OPTIONS:
  -t  --times=N		     generate TARGET N times
                         [default: 10]
  --sentence-size=N1     N words in sentence.
  --sentence-size=N1-N2  from N1 to N2 words in sentence.
                         [default: 3-8]
  --paragraph-size=N     N sentences in paragraph
  --paragraph-size=N1-N2 from N1 to N2 sentences in paragraph.
                         [default: 5-15]

  -o  --no-o		     do not use 'o'
  -a  --no-a		     do not use 'â'
  -u  --no-u		     do not use 'û'
  -c  --no-circumflex	 do not use 'â' and 'û' (equals -au)
```

## Grammar

```
<paragraph> ::= <sentence> [ <sentence>...]
<sentence> ::= <word> [ <word>...] <end_of_sentence>
<word> ::= <cvc> | <cvc> <vc> | <cvc> <vc> <vc>
<name> ::= <vovel> <cvc> | <cv> <cvc> | <vc> <cvc> | <cvc> <vc> | <cvc> <cvc>
<syllable> :== <vc> | <cv> | <cvc>

<cvc> ::= <initial_consonant> <vovel> <final_consonant>
<cv> ::= <inital_consonant> <final_vovel>
<vc> ::= <vovel> <final_consonant>

<inital_consonant> ::= <consonant> | <consonant_cluster> | <consonant_inital_cluster>
<final_consonant> ::=  <consonant> | <consonant_cluster> | <consonant_final_cluster>
<final_vovel> ::= <vovel> | <diphthong>

<end_of_sentence> :== "." | "?" | "!" | "..."
<consonant_final_cluster> ::= "mb" | "mp" | "nk" | "rz" | "zg"
<consonant_initial_cluster> ::= "gl" | "kr" | "sk" | "thr"
<consonant_cluster> ::= "gh" | "sh" | "th"
<consonant> ::= "b" | "d" | "g" | "h" | "k" | "l" | "m" | "n" | "p" | "r" | "s" | "t" | "z"
<diphthong> ::=  "ai" | "au"
<vovel> ::= "a" | "i" | "o" | "u" | "â" | "û"
```

## Installation

Clone this repository

`$ git clone https://github.com/kastian/ashnazg.git`

and run

`$ ./ashnazg.pl`

or install (default `PREFIX=/usr/local`)

`$ sudo make install`

Ashnazg consists only of one executable file so if you'll want to uninstall it you can use

`$ sudo make uninstall`

or just remove file

`$ sudo rm $(which ashnazg)`

------------------------------------------------------------------------

Any feedback, ideas, fixes, bug reports are welcomed.

 #kstn
