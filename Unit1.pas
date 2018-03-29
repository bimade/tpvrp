unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  Tableau = array of array of integer ;
  Vecteur = array of integer ;
  TForm1 = class(TForm)
  private
    { Déclarations privées }


  public
    { Déclarations publiques }
  end;

var
  Form1: TForm1;
  MatriceCout : tableau;
  VecteurNbrClientDepot : Vecteur;
  MatriceClientDepot : tableau ;
  VecteurTourneeNN : Vecteur ;
  VecteurTourneeSA : Vecteur ;
  VecteurTourneeBSA : Vecteur ;
  NombreClient : integer ;
  NombreDepot : integer ;
  DeadTimeTournee : integer ;
  TailleVectTournee : integer;
  Temperature : Double ;
  Min_Temperature : Double ;
  relax : Double ;
  Alpha : double ;

implementation


Function SommeLigne(ligne: integer):integer;
var i,somme : integer;
begin
    somme := 0;
   for I := 0 to NombreClient - 1 do
   Somme:= Somme + MatriceCout[ligne,i];

   SommeLigne:=somme;

end;

Function NextClient(depot,Client,NbrClient:integer;var used:vecteur): integer ;
 var Nclient,Temps,BestTime:integer;
  I: Integer;
begin
  BestTime:=SommeLigne(MatriceClientDepot[depot,Client]);
     for I := 0 to NbrClient - 1 do
        if used[i]=0 then
          begin
            Temps:= MatriceCout[MatriceClientDepot[depot,Client],NombreDepot+i];
            if Temps<BestTime then
            begin
              BestTime:=Temps;
              Nclient:=i;
            end;
          end;
     NextClient:=NClient;
end;

Procedure PartitionnerClient();
Var i,j,temps,BestTime,BestDepot:integer;
begin

for I := NombreDepot to nombreClient - 1 do
begin
  BestTime := SommeLigne(i);
  for j := 0 to NombreDepot - 1 do
    begin
      Temps:=MatriceCout[j,i]+MatriceCout[i,j];
        if temps < BestTime then
            begin
              bestTime := temps;
              BestDepot := j;
            end;
    end;
SetLength(MatriceClientDepot,NombreDepot,VecteurNbrClientDepot[BestDepot]+1);//faire de la place
MatriceClientDepot[BestDepot,VecteurNbrClientDepot[BestDepot]]:=i;// Ajouter le client
VecteurNbrClientDepot[BestDepot]:=VecteurNbrClientDepot[BestDepot]+1;//
end;
end;

Procedure ConstruireTournee(depot,NbrClient:integer);
Var Client,NClient,DureeTournee: integer;
  I,Duree: Integer;
  used:vecteur;
  j: Integer;
begin
SetLength(used,NbrClient);
for j := 0 to NbrClient - 1 do
used[j]:=0;
DureeTournee:=0;
Randomize;

SetLength(VecteurTourneeNN,TailleVectTournee+2);
VecteurTourneeNN[TailleVectTournee]:=depot;
Client := random(NbrClient);
VecteurTourneeNN[TailleVectTournee+1]:=MatriceClientDepot[depot,Client];
TailleVectTournee:=TailleVectTournee+2;
used[Client]:=1;
DureeTournee:=DureeTournee+matriceCout[depot,MatriceClientDepot[depot,Client]];

for I := 0 to NbrClient - 1 do
  if i<>Client then
    begin
      NClient:=NextClient(depot,Client,NbrClient,used);
      Duree:=DureeTournee+matriceCout[MatriceClientDepot[depot,Client],MatriceClientDepot[depot,NClient]]+matriceCout[MatriceClientDepot[depot,NClient],Depot];
       used[NClient]:=1;
      if  duree <= DeadTimeTournee then
        begin
         SetLength(VecteurTourneeNN,TailleVectTournee+1);
         VecteurTourneeNN[TailleVectTournee]:=MatriceClientDepot[depot,NClient];
         TailleVectTournee:=TailleVectTournee+1;
         DureeTournee:=DureeTournee+matriceCout[MatriceClientDepot[depot,Client],MatriceClientDepot[depot,NClient]];
        end
        else
          begin
            SetLength(VecteurTourneeNN,TailleVectTournee+2);
            VecteurTourneeNN[TailleVectTournee]:=depot;
            VecteurTourneeNN[TailleVectTournee+1]:=MatriceClientDepot[depot,NClient];
            TailleVectTournee:=TailleVectTournee+2;
            DureeTournee:=duree+matriceCout[depot,MatriceClientDepot[depot,NClient]];
          end;

    end;
SetLength(VecteurTourneeNN,TailleVectTournee+1);
VecteurTourneeNN[TailleVectTournee]:=depot;
 TailleVectTournee:=TailleVectTournee+1;
end;

procedure NN();
var j: Integer;
begin
//affecter les client aux dépots
PartitionnerClient();
//Construire les tournées
for j := 0 to NombreDepot - 1 do
ConstruireTournee(j,VecteurNbrClientDepot[j]);
end;

Procedure CopierVecteur(Sol : vecteur;var Sol2:vecteur);
var
  I: Integer;
begin
  SetLength(sol2,TailleVectTournee);
  for I := 0 to TailleVectTournee - 1 do
    Sol2[i]:=sol[i];
end;

Procedure TransformSA(var Vect: vecteur);
begin

end;

function GetFonctObjectif(Vect : vecteur):double ;
var
  I: Integer;
  f: double ;
begin
  f:=0;
   for I := 1 to TailleVectTournee - 1 do
      F:=F+MatriceCout[i-1,i];
      GetFonctObjectif:=F;
end;


Procedure SA();
Var palier,P,U : double;
  Vect : vecteur;
  Z,NZ,BestEver:double;
begin
CopierVecteur(VecteurTourneeNN,VecteurTourneeSA);
palier:=0;
randomize;
Z:=GetFonctObjectif(vecteurTourneeSA);
while (Temperature>Min_Temperature) do
begin
 palier:=palier+1;
            CopierVecteur(VecteurTourneeSA,Vect);
            TransformSA(Vect);
            NZ:=GetFonctObjectif(Vect);
        if (NZ<Z) then
        begin
            Z:=NZ;
            CopierVecteur(Vect,VecteurTourneeSA);
            if (Z<=Bestever) then
                  begin
                    Bestever:=Z;
                    CopierVecteur(VecteurTourneeSA,VecteurTourneeBSA);
                  end;
        end
        else
          begin
            P:=random;
            U:=exp(-(NZ-Z)/Temperature);

            if (P<=U) then
            begin
            Z:=NZ;
            CopierVecteur(Vect,VecteurTourneeSA);
            end;
          end;

    if (palier>=relax) then
        begin
            palier:=1;
            Temperature:=Temperature*alpha;
        end;

end;



end;

{$R *.dfm}

end.
