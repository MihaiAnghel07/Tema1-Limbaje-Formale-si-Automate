NUME: ANGHEL MIHAI-GABRIEL   GRUPA: 336CC



**************Fisiere input****************
In arhiva se afla un director 'in' in care sunt plasate toate fisierele de 
input, cele doua exemple din documentatia temei: example1.txt, example2.txt
si 4 fisiere generate de mine astfel:
 - myexample1.txt: contine 3 obiecte simple
 - myexample2.txt: contine 5 obiecte: primele 4 compuse si ultimul simplu
 - myexample3.txt: contine 8 obiecte simple/compuse aflate intr-o structura
		   arborescenta mai complexa 
 - myexample4.txt: contine 3 obiecte, scopul acestuia este de a demonstra 
		   functionalitatea identificarii elementelor obiectului,
		   indiferent de escapare sau separatori.
Fisierele sunt rulate in ordinea de mai sus.


*********Detalii implementare***************
Pentru fiecare obiect, consider initial ca nu are textura si formez output-ul
corespunzator, sarind in starea in care identific numele obiectului. 
De fiecare data cand se face match pe '{' incrementez numarul de tab-uri
si decrementez pentru '}'. Identarea afisarii insa, se calculeaza in momentul
afisarii, in functie de aparitiile '{' si '}'. In momentul in care se face 
match pe un sir cu sufixul .png, se schimba output-ul si se afiseaza numele 
imaginii. Identific cu ajutorul regulilor si macro-urilor numele obiectului, 
numarul de varfuri, numarul de fete, numele imaginii de textura. Pentru ceea ce
nu ma intereseaza, folosesc reguli care inhiba afisarea. Afisarea datelor despre
un obiect se face in momentul in care se face acceptare la "\nObject ", adica in
momentul in care se intalneste un nou obiect. (Exceptie pentru cazul ultimului 
obiect din fisier a carui date se afiseaza in functia yywrap() pentru ca nu se 
mai poate accepta sirul "\nObject "). Am ales aceasta afisare deoarece elementele obiectului se pot afla in ordine aleatoare, deci trebuie sa fac afisarea abia 
dupa ce cunosc toata informatia despre un obiect.
Am folosit si 5 stari cu urmatoarele semnificatii:
 - S1 -> starea in care sar cand identific un nou obiect pentru a-i afla numele;
 - S2 -> cand se face match pe "vertexes", calculez numarul de varfuri;
 - S3 -> cand se face match pe "faces", calculez numarul de fete;
 - S4 -> cand identific "img", inseamna ca obiectul are textura si sar in S4 
	pentru a gasi numele imaginii;
 - S5 -> la intalnirea "texture", sar in S5 unde inhib regula pentru ca nu ma
        intereseaza coordonatele de textura; 


**********Makefile************
Pentru -build: make build
       -run: make run
       -clean: make clean


*********Mentiuni*************
In fisierul sursa am adaugat comentarii prin care detaliez scopul macro-urilor
declarate, inclusiv al variabilelor c + detalii ce tin de implementare.
Identarea dintre reguli si corpul acestora este facuta astfel incat corpurile
sa fie aproximativ la aceeasi coloana(am considerat ca e mai confortabil vizual)

Pentru introducerea altor fisiere de input, adaugati fisierele in directorul
'in', apoi modificati variabila INPUT din Makefile, adaugand calea catre fisierele
dorite.

In fisierele de input am considerat cat mai multe posibilitati de definire a
structurii unui obiect(toate care mi-au venit in minte).
Rezultatele obtinute in urma rularii fisierelor de input sunt bune.

Mentionez ca tema a fost realizata si testata in linux (Ubuntu 18.04) 
(masina virtuala VMware Workstation 16 Player) si nu am intalnit probleme.




