/* NUME: ANGHEL MIHAI-GABRIEL  GRUPA: 336CC */              




%{
// Definitions
/*
	Am declarat cateva variabile care sa ma ajute sa:
		- extrag anumite informatii din text: nume_obiect, textura, nume_imagine;
		- identez obiectele compuse: nr_tabs, nr_tabs2;
		- numar varfurile si fetele obiectului: nr_varfuri, nr_fete;
		- prelucrez mai multe fisiere de input: FisierCurent, NumarFisisere,
		  ListaFisiere;
*/

#undef yywrap

int nr_fete = 0;
int nr_varfuri = 0;
int nr_tabs = 0;
int nr_tabs2 = 0;
char nume_obiect[50];
char textura[50];
char nume_imagine[50];
unsigned int FisierCurent;
unsigned int NumarFisisere;
char **ListaFisiere;


/* Functia yywrap ma ajuta sa prelucrez mai multe fisiere de input
   Tot in cadrul acestei functii afisez output-ul pentru ultimul obiect
   din fisier (detalii in readme)
*/
int yywrap(void)
{
	FILE *fisier = NULL;
	fclose(yyin);

	// se adauga tab-urile pentru cazul obiectelor compuse
	for (int i = 0; i < nr_tabs - 1; i++) { 
		printf("\t");
	} 

	// se afiseaza datele cerute
	printf("Object %s: varfuri: %d, fete: %d, %s\n",nume_obiect,
																	nr_varfuri, 
																	nr_fete, 
																	textura);

	// se adauga separatori pentru a nu se face confuzie
	// intre output-uri in cazul in care se ruleaza mai multe
	// fisiere de input
	for (int i = 0; i < 80; i++) { 
		printf("*"); 
	}
	printf("\n\n");	
	
	// se restaureaza variabilele pentru viitoarele posibile fisiere
	nr_tabs = 0;
	nr_tabs2 = 0;
	nr_varfuri = 0;
	nr_fete = 0;

	FisierCurent++;
	if (FisierCurent >= NumarFisisere) { 
		return 1;
	}
	
	fisier = fopen(ListaFisiere[FisierCurent], "r");
	if (!fisier) { 
		printf("eroare la citire\n"); 
		exit(-1); 
	}

	yyin = fisier;

	return (fisier ? 0 : 1);

}

%}

/*
	Mi-am definit cateva macro-uri care sa ma ajute sa identific diferite
	pattern-uri. Voi explica semnificatia macro-urilor care pot crea confuzie:
	- Separation: ajuta la identificarea separatorilor permisi: ' ', '\t', '\n';
	- Nume_obiect: reprezinta numele unui obiect care incepe fie cu litera mica,
	  fie cu litera mare, poate contine litere mari / mici si cifre, contine
	  caracterul '_', iar dupa acest caracter numele poate continua cu orice sir
	  format din litere mari/mici sau cifre.  
	- Varf1: identifica un varf de forma (x y z);
	- Varf2: identifica un varf de forma (x y z w);
	- Texturi: recunoaste coordonatele de textura de forma (x y);
	- Componenta_Fata recunoaste continutul unei fete (cifra prefixata de un 
					 separator);
	- Fata identifica o fata de genul 'x y z;';
	- Nume_imagine interpreteaza un sir de litere si cifre care are 
	  sufixul '.png';
	Am folosit si 5 stari pe care le detaliez in readme.
*/

Separation [\ \t\n]+
Cifra [0-9]
Semn [+-]?
Natural {Cifra}+
Intreg {Semn}{Natural}
Real {Semn}{Natural}\.{Natural}?
Nume_obiect [a-zA-Z]+[a-zA-Z0-9]*_[a-zA-Z0-9]*
Varf1 {Separation}\({Real}{Separation}{Real}{Separation}{Real}\)
Varf2 {Separation}\({Real}{Separation}{Real}{Separation}{Real}{Separation}{Real}\)
Texturi {Separation}\({Real}{Separation}{Real}\)
Componenta_Fata {Separation}{Cifra}
Fata {Componenta_Fata}+
Nume_imagine {Separation}[a-zA-Z0-9]+.png

%s S1 S2 S3 S4 S5


%%
Rules
"Object "				{ 	
								// cand sunt la primul obiect din fisier, consider ca acesta
								// nu are textura asociata
								strcpy(textura, "fara textura");
								BEGIN(S1);
							}

"texture" 				{ BEGIN(S5); }

"vertexes" 				{ BEGIN(S2); }

"faces" 					{ BEGIN(S3); }

\n|\t 					{}

<S5>{Texturi} 			{}

"img" 					{ BEGIN(S4); }

"{" 						{nr_tabs += yyleng;}

"}" 						{nr_tabs2 += yyleng;}

<S1>{Nume_obiect} 	{strcpy(nume_obiect, yytext);}

<S2>{Varf1}|{Varf2} 	{nr_varfuri++;}

<S3>{Fata}; 			{nr_fete++;}

<S4>{Nume_imagine} 	{	
								// daca se face match pe un sir .png, inseamna ca
								// obiectul curent are textura, deci formez
								// output-ul pentru textura
								strcpy(textura, "imagine textura");
								strcat(textura, yytext);
							}

"\nObject "				{
								// adaug tab-urile corespunzatoare daca obiectul este compus
								for (int i = 0; i < nr_tabs - 1; i++) { 
									printf("\t"); 
								}

								// afisez informatia despre obiect
								printf("Object %s: varfuri: %d, fete: %d, %s\n",nume_obiect, 
																								nr_varfuri, 
																								nr_fete, 
																								textura);
							
								// recalculez identarea
								nr_tabs -= nr_tabs2;

								// restabilesc variabilele pentru posibilele viitoare obiecte
								nr_varfuri = 0; 
								nr_fete = 0;  
								nr_tabs2 = 0;

								// consider ca urmatorul posibil obiect nu are textura
								strcpy(textura, "fara textura");
								
								// caut numele noului obiectului
								BEGIN(S1);
							}



%%

int main(int argc, char **argv)
{
	
	FILE *fisier;
	ListaFisiere = argv + 1;
	NumarFisisere = argc - 1;
		
	if (NumarFisisere > 0) {
		FisierCurent = 0;
		fisier = fopen(ListaFisiere[FisierCurent], "r");
		if (!fisier) { 
			printf("eroare la citire\n");
			exit(-1);
		}
		yyin = fisier;

		// se adauga separatori pentru a nu se face confuzie
		// intre output-uri in cazul in care se ruleaza mai multe
		// fisiere de input
		for (int i = 0; i < 80; i++) {
		 	printf("*");
		}
		printf("\n");
		
		// se ruleaza programul flex
		yylex();
	
	} else {
		printf("Nu exista niciun fisier de input!");
	}
	
}