unit Objekty; {Vytvaranie a Kontrola objektov}

interface
uses GrVirt,Mouse,SynMouse,Crt,Grvirt2,Special,PII,OPL3;

var  Event : record
         Typ : byte; {0 : nic, 1 : keyboard, 2 : mouse}
         case byte of
              1 :  (CharCode : char;
                    ScanCode : byte);
              2 :  (LeftButton  : boolean;
                    RightButton : boolean;
                    DoubleClick : boolean);
         end;

type AktType = record
               Typ    : byte;
               Plocha : string;
               Meno   : string;
               Value  : integer;
               end;

var Akcia : AktType;

var   PlochKolko : integer; {PocetPloch}
      NajdenaPolozka    : Polozka;
      AktualnaPolozka   : Polozka;
      StlacenaPolozka   : Polozka;
      Pricina      : boolean;
      SmeNaPloche  : boolean;
      PB   : ^Obutton;
      Pbit : ^OBitmapButton;
      PZ   : ^OZapinac;
      PRB  : ^ORadioButton;
      PSP  : ^OSprajt;
      PBZ  : ^OBezec;
      PP   : ^OPrepinac;
      PGZ  : ^OGrZapinac;
      PO   : ^OPotenciometer;
      PGP  : ^OGrPrepinac;
      PR   : ^ORoller;
      PTX  : ^OTxtOkno;
      PTXr : ^OTxtOknoR;
      PrP  : ^OriadokNaPisanie;
      Pob  : ^OObjekt;

procedure DeskTopCreate(Mess:string;col:byte;styl:byte);
procedure Koniec;

procedure Okno(Name:string;Vid:boolean;a,b,c,d:integer;Mess:string);
procedure ZrusOkno(Name:string);
function GetPlochaNum(Meno:string):integer;

procedure UrobTlacidlo(Butt:TButton);
procedure UrobBitmapTlacidlo(Butt:TButton;x1,y1,xx,yy:integer;nf:byte;Obrazok:Pobrazok);
procedure UrobObjekt(Name,Mess:string;a,b,c,d:integer);

procedure UrobZapinac(Butt:TButton;Stav:boolean);
procedure SetZapinac(Okn,Name:string;Hod:boolean);
function  GHZapinac (Okn,Name:string):boolean;

procedure UrobGrZapinac(Name:string;x,y:integer;St:byte;Mess:string);
procedure SetGrZapinac(Okn,Name:string;Hod:byte);
function GHGrZapinac(Okn,Name:string):byte;
procedure UrobPrepinac(Name:string;x,y:integer;Pocet,Aky:byte;Vid:boolean;Mess:string);
procedure SetPrepinac(Okn,Name:string;Ktory:byte);
function GHPrepinac(Okn,Name:string):byte;
procedure UrobGrPrepinac(Name:string;x,y:integer;St:byte;Mess:string);
procedure SetGrPrepinac(Okn,Name:string;Ktor:byte);
function GHGrPrepinac(Okn,Name:string):byte;
procedure UrobPotik(Name:string;x,y:integer;Mess:string;St:boolean;Hod:byte);
procedure SetPotik(Okn,Name:string;Hod:byte);
function  GHPotik(Okn,Name:string):byte;
procedure UrobBezec(Name:string;x,y:integer;HH,DH,Nas:integer;Mess:string;St:boolean;Hod:Integer);
procedure SetBezec(Okn,Name:string;Hod:integer);
function GHBezec(Okn,Name:string):integer;
procedure UrobTxtOkno(x,y:integer;TTO:TTxtOkno;Buffer:array of string;Poloha:integer);
procedure UrobTxtOknoR(x,y:integer;TTO:TTxtOkno;Buffer:array of string;Poloha:integer);
procedure UrobRNapi(Riadok:TRiadokNaPisanie);
{function  GetStav_Zap(Okno:string;Meno:string);}
procedure RewriteTxtOkno(Okienko,Meno:string;Buffer:array of string);
procedure UrobRadioBox(Nejm:string;Buttons: array of TButton;Ktory,Pocet:byte);
Procedure SetRadioBox(Okn,Name:string;Hod:byte);
function GHRadioBox(Okn,Name:string):byte;
{procedure UrobRiadok(RnaPi:TRiadokNaPisanie);}

procedure ControlInit; {Inicializuje premenne}
procedure ConTRoL;
procedure PracujSnim;
function Rovnake(P1,P2:Polozka):boolean;
function RovnakeRBP(B1:TButton;P2:Polozka):boolean;
procedure  GetAction(var Akcijka : AktType);

implementation

var
    Desk   : Desktop;
    prem   : integer;
{    LastClick : record;}
    Casovac:LongInt Absolute $0:$046C;  { Interny casovac pre INTEL 80x86 }

procedure DeskTopCreate(Mess:string;col:byte;styl:byte);
          begin
               AktualneOkno := 0;
               Desk.Init(Mess,col,styl);
{               Desk.CisloPlochy := 0;}
          end;

procedure Koniec;
          begin
               for prem := 1 to 256 do
                   if Ploska[prem] <> nil then
                      Dispose(Ploska[prem],Done);
               Desk.Done;
          end;

procedure Okno(Name:string;Vid:boolean;a,b,c,d:integer;Mess:string);
          begin
               PlochKolko:=PlochKolko+1;
               AktualneOkno := PlochKolko;
               New(Ploska[PlochKolko],Init(Name,Vid,a,b,c,d,Mess));
               Ploska[PlochKolko]^.SaveBack;
               Ploska[PlochKolko]^.Show;
{               Ploska[PlochKolko]^.CisloPlochy := PlochKolko;}
          end;

function GetPlochaNum(Meno:string):integer;
         begin
              for prem := 1 to 256 do
                  if Ploska[prem]^.Item.Meno = Meno then break;
              GetPlochaNum := prem;
         end;

procedure ZrusOkno(Name:string);
          var PB : ^Obutton;
              OP : pointer;
          begin
             for prem := 256 downto 1 do begin
                  if (Ploska[prem]<>nil) and
                     (Ploska[prem]^.Item.Meno=Name) then
                  begin
                     HideMouse;
                     Dispose(Ploska[prem],Done);
                     Ploska[prem]:=nil;
                     ShowMouse;
                     exit;
                  end;
              end;
              end;


procedure UrobTlacidlo(Butt:TButton);
          var PB : ^Obutton;
              OP : ^Obutton;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Buttonov = 0 then begin
                  New(PB,Init(Butt));
                  First_Button:=PB;
                  end
               else begin
                  OP:=First_Button;
                  for prem := 1 to Pocet_Buttonov - 1 do
                      OP := OP^.NextButton;
                  New(PB,Init(Butt));
                  OP^.NextButton := PB;
               end;
               Pocet_Buttonov:=Pocet_Buttonov+1;
               PB^.Show;
             end;
          end;

procedure UrobObjekt(Name,Mess:string;a,b,c,d:integer);
          var PB : ^OObjekt;
              OP : ^OObjekt;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Objektov = 0 then begin
                  New(PB,Init(Name,Mess,a,b,c,d));
                  First_Objekt:=PB;
                  end
               else begin
                  OP:=First_Objekt;
                  for prem := 1 to Pocet_Objektov - 1 do
                      OP := OP^.NextObjekt;
                  New(PB,Init(Name,Mess,a,b,c,d));
                  OP^.NextObjekt := PB;
               end;
               Pocet_Objektov:=Pocet_Objektov+1;
             end;
          end;

procedure UrobBitmapTlacidlo(Butt:TButton;x1,y1,xx,yy:integer;nf:byte;Obrazok:Pobrazok);
          var PB : ^OBitmapButton;
              OP : ^OBitmapbutton;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_BitButtonov = 0 then begin
                  New(PB,Init(Butt,x1,y1,xx,yy,nf,@Obrazok));
                  First_BitButton:=PB;
                  end
               else begin
                  OP:=First_BitButton;
                  for prem := 1 to Pocet_BitButtonov - 1 do
                      OP := OP^.NextBitButton;
                  New(PB,Init(Butt,x1,y1,xx,yy,nf,@Obrazok));
                  OP^.NextBitButton := PB;
               end;
               Pocet_BitButtonov:=Pocet_BitButtonov+1;
               PB^.Show;
             end;
          end;

procedure UrobZapinac(Butt:TButton;Stav:boolean);
          var PB : ^OZapinac;
              OP : ^OZapinac;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Zapinacov = 0 then begin
                  New(PB,Init(Butt,Stav));
                  First_Zapinac:=PB;
                  end
               else begin
                  OP:=First_Zapinac;
                  for prem := 1 to Pocet_Zapinacov - 1 do
                      OP := OP^.NextZapinac;
                  New(PB,Init(Butt,Stav));
                  OP^.NextZapinac := PB;
               end;
               Pocet_Zapinacov:=Pocet_Zapinacov+1;
               PB^.Show;
             end;
          end;

procedure SetZapinac(Okn,Name:string;Hod:boolean);
          var OP : ^OZapinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Zapinacov = 0 then
                  OP := First_Zapinac
               else begin
                  OP:=First_Zapinac;
                  for prem := 1 to Pocet_Zapinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextZapinac;
                  end;
               end;
               if OP^.value <> Hod then begin
                  OP^.value := Hod;
                  OP^.ShowIt;
               end;
              end;
          end;

function  GHZapinac (Okn,Name:string):boolean;
          var OP : ^OZapinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Zapinacov = 0 then
                  OP := First_Zapinac
               else begin
                  OP:=First_Zapinac;
                  for prem := 1 to Pocet_Zapinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextZapinac;
                  end;
               end;
               GHZapinac:= OP^.value;
              end;
          end;


procedure UrobGrZapinac(Name:string;x,y:integer;St:byte;Mess:string);
          var PB : ^OGrZapinac;
              OP : ^OGrZapinac;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_GrZapinacov = 0 then begin
                  New(PB,Init(Name,x,y,St,Mess));
                  First_GrZapinac:=PB;
                  end
               else begin
                  OP:=First_GrZapinac;
                  for prem := 1 to Pocet_GrZapinacov - 1 do
                      OP := OP^.NextGrZapinac;
                  New(PB,Init(Name,x,y,St,Mess));
                  OP^.NextGrZapinac := PB;
               end;
               Pocet_GrZapinacov:=Pocet_GrZapinacov+1;
               PB^.Show;
             end;
          end;

procedure SetGrZapinac(Okn,Name:string;Hod:byte);
          var OP : ^OGrZapinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_GrZapinacov = 1 then
                  OP := First_GrZapinac
               else begin
                  OP:=First_GrZapinac;
                  for prem := 1 to Pocet_GrZapinacov -1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextGrZapinac;
                  end;
               end;
               if OP^.value <> Hod then begin
                  OP^.value := Hod;
                  OP^.Show;
               end;
              end;
          end;

function GHGrZapinac(Okn,Name:string):byte;
          var OP : ^OGrZapinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_GrZapinacov = 0 then
                  OP := First_GrZapinac
               else begin
                  OP:=First_GrZapinac;
                  for prem := 1 to Pocet_GrZapinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextGrZapinac;
                  end;
               end;
                  GHGrZapinac:=OP^.value;
              end;
          end;

procedure UrobGrPrepinac(Name:string;x,y:integer;St:byte;Mess:string);
          var PB : ^OGrPrepinac;
              OP : ^OGrPrepinac;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_GrPrepinacov = 0 then begin
                  New(PB,Init(Name,x,y,St,Mess));
                  First_GrPrepinac:=PB;
                  end
               else begin
                  OP:=First_GrPrepinac;
                  for prem := 1 to Pocet_GrPrepinacov - 1 do
                      OP := OP^.NextGrPrepinac;
                  New(PB,Init(Name,x,y,St,Mess));
                  OP^.NextGrPrepinac := PB;
               end;
               Pocet_GrPrepinacov:=Pocet_GrPrepinacov+1;
               PB^.Show;
               PB^.ShowMeno;
             end;
          end;

procedure SetGrPrepinac(Okn,Name:string;Ktor:byte);
          var OP : ^OGrPrepinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_GrPrepinacov = 0 then
                  OP := First_GrPrepinac
               else begin
                  OP:=First_GrPrepinac;
                  for prem := 1 to Pocet_GrPrepinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextGrPrepinac;
                  end;
               end;
               if OP^.Ktory <> Ktor then begin
                  OP^.Ktory := Ktor;
                  OP^.Show;
               end;
              end;
          end;

function GHGrPrepinac(Okn,Name:string):byte;
          var OP : ^OGrPrepinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_GrPrepinacov = 0 then
                  OP := First_GrPrepinac
               else begin
                  OP:=First_GrPrepinac;
                  for prem := 1 to Pocet_GrPrepinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextGrPrepinac;
                  end;
               end;
                  GHGrPrepinac:=OP^.Ktory;
              end;
          end;

procedure UrobPotik(Name:string;x,y:integer;Mess:string;St:boolean;Hod:byte);
          var PB : ^OPotenciometer;
              OP : ^OPotenciometer;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Potikov = 0 then begin
                  New(PB,Init(Name,x,y,Mess,St));
                  First_Potik:=PB;
                  end
               else begin
                  OP:=First_Potik;
                  for prem := 1 to Pocet_Potikov - 1 do
                      OP := OP^.NextPotenciometer;
                  New(PB,Init(Name,x,y,Mess,St));
                  OP^.NextPotenciometer := PB;
               end;
               Pocet_Potikov:=Pocet_Potikov+1;
               PB^.NakresliHo(Hod);
             end;
          end;

procedure SetPotik(Okn,Name:string;Hod:byte);
          var OP : ^OPotenciometer;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Potikov = 0 then
                  OP := First_Potik
               else begin
                  OP:=First_Potik;
                  for prem := 1 to Pocet_Potikov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextPotenciometer;
                  end;
               end;
               if OP^.Value <> Hod then begin
                  OP^.Setto(Hod);
               end;
              end;
          end;

function GHPotik(Okn,Name:string):byte;
          var OP : ^OPotenciometer;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Potikov = 0 then
                  OP := First_Potik
               else begin
                  OP:=First_Potik;
                  for prem := 1 to Pocet_Potikov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextPotenciometer;
                  end;
               end;
               GHPotik:=OP^.Value;
              end;
          end;

procedure UrobBezec(Name:string;x,y:integer;HH,DH,Nas:integer;Mess:string;St:boolean;Hod:Integer);
          var PB : ^OBezec;
              OP : ^OBezec;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Bezcov = 0 then begin
                  New(PB,Init(Name,x,y,HH,DH,Nas,Mess,St));
                  First_Bezec:=PB;
                  end
               else begin
                  OP:=First_Bezec;
                  for prem := 1 to Pocet_Bezcov - 1 do
                      OP := OP^.NextBezec;
                  New(PB,Init(Name,x,y,HH,DH,Nas,Mess,St));
                  OP^.NextBezec := PB;
               end;
               Pocet_Bezcov:=Pocet_Bezcov+1;
               PB^.NakresliHo(Hod);
             end;
          end;

procedure SetBezec(Okn,Name:string;Hod:integer);
          var OP : ^OBezec;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Bezcov = 0 then
                  OP := First_Bezec
               else begin
                  OP:=First_Bezec;
                  for prem := 1 to Pocet_Bezcov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextBezec;
                  end;
               end;
               if OP^.Value <> Hod then begin
                  OP^.SetTo(Hod);
               end;
              end;
          end;

function GHBezec(Okn,Name:string):integer;
          var OP : ^OBezec;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Bezcov = 0 then
                  OP := First_Bezec
               else begin
                  OP:=First_Bezec;
                  for prem := 1 to Pocet_Bezcov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextBezec;
                  end;
               end;
               GHBezec:=OP^.Value;
              end;
          end;

procedure UrobPrepinac(Name:string;x,y:integer;Pocet,Aky:byte;Vid:boolean;Mess:string);
          var PB : ^OPrepinac;
              OP : ^OPrepinac;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Prepinacov = 0 then begin
                  New(PB,Init(Name,x,y,Pocet,Aky,Vid,Mess));
                  First_Prepinac:=PB;
                  end
               else begin
                  OP:=First_Prepinac;
                  for prem := 1 to Pocet_Prepinacov - 1 do
                      OP := OP^.NextPrepinac;
                  New(PB,Init(Name,x,y,Pocet,Aky,Vid,Mess));
                  OP^.NextPrepinac := PB;
               end;
               Pocet_Prepinacov:=Pocet_Prepinacov+1;
               PB^.Show;
             end;
          end;

procedure SetPrepinac(Okn,Name:string;Ktory:byte);
          var OP : ^OPrepinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Prepinacov = 0 then
                  OP := First_Prepinac
               else begin
                  OP:=First_Prepinac;
                  for prem := 1 to Pocet_Prepinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextPrepinac;
                  end;
               end;
               if OP^.value <> Ktory then begin
                  OP^.SetIt(OP^.Item.x1+Ktory*5);
               end;
              end;
          end;


function GHPrepinac(Okn,Name:string):byte;
          var OP : ^OPrepinac;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_Prepinacov = 0 then
                  OP := First_Prepinac
               else begin
                  OP:=First_Prepinac;
                  for prem := 1 to Pocet_Prepinacov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextPrepinac;
                  end;
               end;
                  GHPrepinac:=OP^.value;
              end;
          end;


procedure UrobRadioBox(Nejm:string;Buttons: array of TButton;Ktory,Pocet:byte);
          var PB : ^ORadioButton;
              OP : ^ORadioButton;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_RButtonov = 0 then begin
                  New(PB,Init(Nejm,Buttons,Ktory,Pocet));
                  First_RButton:=PB;
                  end
               else begin
                  OP:=First_RButton;
                  for prem := 1 to Pocet_RButtonov - 1 do
                      OP := OP^.NextRButton;
                  New(PB,Init(Nejm,Buttons,Ktory,Pocet));
                  OP^.NextRButton := PB;
               end;
               Pocet_RButtonov:=Pocet_RButtonov+1;
               PB^.Show;
             end;
          end;

Procedure SetRadioBox(Okn,Name:string;Hod:byte);
          var OP : ^ORadioButton;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_RButtonov = 0 then
                  OP := First_RButton
               else begin
                  OP:=First_RButton;
                  for prem := 1 to Pocet_RButtonov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextRButton;
                  end;
               end;
               if OP^.value <> Hod then begin
                  OP^.value := Hod;
                  OP^.SetIt;
               end;
              end;
          end;

function GHRadioBox(Okn,Name:string):byte;
          var OP : ^ORadioButton;
          begin
              with Ploska[GetPlochaNum(Okn)]^ do begin
               if Pocet_RButtonov = 0 then
                  OP := First_RButton
               else begin
                  OP:=First_RButton;
                  for prem := 1 to Pocet_RButtonov - 1 do begin
                      if OP^.Item.Meno = Name then break;
                      OP := OP^.NextRButton;
                  end;
               end;
                  GHRadioBox:=OP^.value;
              end;
          end;

procedure UrobTxtOkno(x,y:integer;TTO:TTxtOkno;Buffer:array of string;Poloha:integer);
          var PB : ^OTxtOkno;
              OP : ^OTxtOkno;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_TxtOkien = 0 then begin
                  New(PB,Init(x,y,TTO,Buffer));
                  First_TxtOkno:=PB;
                  end
               else begin
                  OP:=First_TxtOkno;
                  for prem := 1 to Pocet_TxtOkien - 1 do
                      OP := OP^.NextTxtOkno;
                  New(PB,Init(x,y,TTO,Buffer));
                  OP^.NextTxtOkno := PB;
               end;
               Pocet_TxtOkien:=Pocet_TxtOkien+1;
               PB^.NakresliPlochu;
               PB^.ShowText(Poloha,0);
               PB^.ShowText(Poloha,TTO.Oznaceny);
             end;
          end;

procedure RewriteTxtOkno(Okienko,Meno:string;Buffer:array of string);
          var Najdene : boolean;
          begin
               with Ploska[GetPlochaNum(Okienko)]^ do begin
                                Najdene := false;
                                if Pocet_TxTokien = 1 then begin
                                         PTX:=First_TxTokno;
                                         Najdene := true;
                                         end
                                   else begin
                                             PTX:=First_TxTokno;
                                             for prem := 1 to Pocet_TxtOkien do begin
                                                 if Rovnake(NajdenaPolozka,PTX^.Item) then
                                                 Najdene := true;
                                                 PTX := PTX^.NextTxTokno;
                                             end;
                                        end;
                                   if Najdene then begin
                                    with PTX^ do begin
                                         For prem := 1 to SpoluRiadkov do
                                             Textik[prem]:=Buffer[prem-1];
                                         ShowText(Poloha+1,Inserted);
                                         ShowText(Poloha,Inserted);
                                    end;
                                   end
                                   else begin
                                if Pocet_TxTokienR = 1 then
                                         PTXr:=First_TxToknoR
                                   else begin
                                             PTXr:=First_TxToknor;
                                             for prem := 1 to Pocet_TxtOkienr do begin
                                                 if Rovnake(NajdenaPolozka,PTXr^.Item) then
                                                 break;
                                                 PTXr := PTXr^.NextTxToknor;
                                            end;
                                        end;
                                    with PTXr^ do begin
                                         For prem := 1 to SpoluRiadkov do
                                             Textik[prem]:=Buffer[prem-1];
                                                   ShowText(Poloha+1,Inserted);
                                                   ShowText(Poloha,Inserted);
                                              end;
                                    end;
               end;
               end;



procedure UrobTxtOknoR(x,y:integer;TTO:TTxtOkno;Buffer:array of string;Poloha:integer);
          var PB : ^OTxtOknoR;
              OP : ^OTxtOknoR;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_TxtOkienR = 0 then begin
                  New(PB,Init(x,y,TTO,Buffer));
                  First_TxtOknoR:=PB;
                  end
               else begin
                  OP:=First_TxtOknoR;
                  for prem := 1 to Pocet_TxtOkienR - 1 do
                      OP := OP^.NextTxtOknoR;
                  New(PB,Init(x,y,TTO,Buffer));
                  OP^.NextTxtOknoR := PB;
               end;
               Pocet_TxtOkienR:=Pocet_TxtOkienR+1;
               PB^.NakresliPlochu;
               PB^.ShowText(Poloha,0);
               PB^.Rolik^.ActPol:=PB^.Poloha;
               PB^.Rolik^.Show
             end;
          end;

procedure UrobRNapi(Riadok:TRiadokNaPisanie);
          var PB : ^ORiadokNapisanie;
              OP : ^ORiadokNapisanie;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_RNapi = 0 then begin
                  New(PB,Init(Riadok));
                  First_RNapi:=PB;
                  end
               else begin
                  OP:=First_RNapi;
                  for prem := 1 to Pocet_RNapi - 1 do
                      OP := OP^.NextRNapi;
                  New(PB,Init(Riadok));
                  OP^.NextRNapi := PB;
               end;
               Pocet_RNapi:=Pocet_RNapi+1;
               PB^.Show;
               PB^.ShowText;
             end;
          end;

{procedure UrobRoller(Rolik:TRoller);
          var Butto : Tbutton;
          begin
               with Butto do begin
                     Name := 'UP!~'+Item.Meno;
                     a := Item.x1 - ActualX;
                     b := Item.y1-15 - ActualY;
                     c := 16;  d := 15;
                     Mess :=  Item.Message;
                     Akt := true;
               end;
               UrobBT(Butto,3,2,10,10,1,@UpButt);
               with Butto do begin
                    Name := 'DN!~'+Item.Meno;
 Á                 a := Item.x1 - ActualX;
                    b :=  Item.y2 - ActualY;
                    c := 16; d := 15;
                    Mess := Item.Message;
                    Akt := true;
               end;
               UrobBT(Butto,3,2,10,10,1,@DownButt);}

procedure  ControlInit; {Inicializuje premenne}
           begin
                PlochKolko := 0;
           end;

procedure VypisSpravu; {Vypise spravu a zmeni kurzor}
          var prem : word;
              prem2 :byte;
          begin
                 AktualnaPolozka:=NajdenaPolozka;
                 with NajdenaPolozka do begin
                    Dial.WriteMessage(Message);
                    case Typek of
                        {sme na DESKu}
                        'd' : begin
                                 SetGraphicCursor(Sipka.cursor);
                                 ActualPlochaS := 'desktop';
                              end;
                        {sme na ploche}
                        'p' : begin
                                 SetGraphicCursor(Sipka.cursor);
                                 ActualPlochaS:=Meno;
                              end;
                        {Sme na tlacidle}
                        'b' : SetGraphicCursor(Ruka.Cursor);
                        {Sme na sprajte}
                        's' : SetGraphicCursor(Hand.Cursor);
                        {Sme na objekte}
                        'j' : SetGraphicCursor(Ruka.Cursor);
                        {Sme na potenciometri}
                        'x' : SetGraphicCursor(Vytacak.Cursor);
                        {Sme na Bezci}
                        'w' : SetGraphicCursor(Posuv.Cursor);
                        {Sme na GrPrepinaci}
                        'G' : SetGraphicCursor(Ruka.Cursor);
                        {sme na TxtOkne}
                        't' : SetGraphicCursor(Sipka.Cursor);
                        {Sme na tlacidle s obrazkom}
                        'B' : SetGraphicCursor(Ruka.Cursor);
                        {Sme na prepinaci}
                        'q' : SetGraphicCursor(Ruka.Cursor);
                        {Sme na Zapinaci}
                        'z' : SetGraphicCursor(Ruka.Cursor);
                        {Sme na klavese}
                        'N' : SetGraphicCursor(Krizik.Cursor);
                        {Sme na GrZapinaci}
                        'Z' : SetGraphicCursor(Ruka.Cursor);
                        {Sme na Radio_tlacidle}
                        'r' : SetGraphicCursor(Ruka.Cursor);
                        {Riadok na pisanie}
                        'l' : SetGraphicCursor(Pero.Cursor);
                        {Roller}
                        'o' : SetGraphicCursor(Ruka.Cursor);
                        {Dialogovy riadok}
                        'g' : begin
                                   HideMouse;
                                   Dial.WriteMessage(Message);
                                   ActualPlochaS:='dialog line';
                                   ShowMouse;
                              end;
                    end;
                 end;
          end;

Procedure ConTRoL; {Naplni premennu NajdenaPolozka}
         var prem : word;
             CH   : char;
             prem2 : integer;
         begin
            EVENT.Typ := 0;
            ReadMouse;
            if keypressed then begin
                 EVENT.Typ := 1;
                 EVENT.CharCode := readkey;
                 if ord(EVENT.CharCode) = 0 then begin
                    EVENT.ScanCode :=ord(readkey);
                end;
             end
             else if (LeftButtonPressed) or (RightButtonPressed) then begin
                  EVENT.Typ:=2;
                  EVENT.LeftButton := false;
                  EVENT.RightButton := false;
                  if LeftButtonPressed then EVENT.LeftButton := true;
                  if RightButtonPressed then EVENT.RightButton := true;
             end;

              for prem := PocetPoloziek downto 1 do begin
                  with Polozky[prem]^ do begin
                       if ((MouseX >= x1) and (MouseX <=x2)) and
                          ((MouseY >= y1) and (MouseY <=y2)) then
                          begin
                                NajdenaPolozka := Polozky[prem]^;
                                   for Prem2 := 1 to 256 do
                                      if Ploska[prem2]<>nil then begin
                                      with Ploska[prem2]^.Item do begin
                                      if ((MouseX >= x1) and (MouseX <=x2)) and
                                         ((MouseY >= y1) and (MouseY <=y2)) then begin
                                         AktualneOkno := prem2;
                                         ActualPlochaS := Ploska[prem2]^.Item.Meno;
{                                         break;}
                                      end;
                                      end;
                                if not Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                   VypisSpravu;
                                if NajdenaPolozka.Typek = 'd' then AktualneOkno := 0;
                          end;
                           break;
                          end;
                  end;
              end;
         end;

Function Rovnake(P1,P2:Polozka):boolean; {porovna dve polozky}
         var Rov : boolean;
         begin
              Rov := false;
              with P1 do begin
                   if ((((x1 = P2.x1) and (y1 = P2.y1)) and
                     ((x2 = P2.x2) and (y2 = P2.y2))) and
                      ((Meno = P2.Meno) and (Message = P2.Message))) and
                      (Typek = P2.Typek) then Rov := true;
              end;
              Rovnake := Rov;
         end;

Function RovnakeRBP(B1:TButton;P2:Polozka):boolean;
         var NavX : integer;
         begin
              RovnakeRBP:=false;
              with B1 do  begin
                   NavX := length(Name)*6;
                   if (((a = P2.x1) and (b = P2.y1)) and
                      ((c+NavX = P2.x2) and (d = P2.y2))) and
                      ((Name = P2.Meno) and (Mess = P2.Message))
                      then RovnakeRBP := true;
                   end;
         end;

procedure PracujSnim;
              var prem:word;
                  prem2:byte;
                  Boolka : boolean;
                  OldY,dY : integer;
                  NewValue : integer;
                  Najdene : boolean;
                  MenoTxtPlochy : string;
                  PomPoloha : integer;
              label dalej,RBdalej,BezVypisu;
              begin
{                  Control;}
                  with Ploska[AktualneOkno]^ do begin
                   case NajdenaPolozka.Typek of
                         {DeskTop}
                         'd' : begin
{                                    Sound(20);delay(30);Nosound;}
{                                          while LeftButtonPressed do begin
{                                               readMouse;}
{                                                Control;}
                                                {ak sme inde ako sme boli...potom zmen kurzor a vypis spravu}
{                                                if not Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                                break;}
{                                          end;}
                               end;
                         {Tlacidlo}
                         'b' : begin
                                if Pocet_Buttonov = 1 then PB:=First_Button
                                   else begin
                                             PB:=First_Button;
                                             for Prem := 1 to Pocet_Buttonov do
                                                 begin
                                                    if Rovnake(NajdenaPolozka,PB^.Item) then break;
                                                    PB := PB^.NextButton;
                                                 end;
                                        end;
                                    with PB^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          HideMouse;
                                          Stav := Stlaceny;
                                          Show;
                                          ShowMouse;
                                          while LeftButtonPressed do begin
                                               Control;
                                               if (Rovnake(NajdenaPolozka,StlacenaPolozka)
                                                  and (not Stav)) then
                                                  begin
                                                       HideMouse;
                                                       Stav := Stlaceny;
                                                       Show;
                                                       ShowMouse;
                                                  end
                                               else if (not (Rovnake(NajdenaPolozka,StlacenaPolozka)))
                                                  and Stav then
                                                    begin
                                                       HideMouse;
                                                       Stav := NeStlaceny;
                                                       Show;
                                                       ShowMouse;
                                                   end;
                                               {VypisSpravu;}
                                          end;
                                          if Rovnake(NajdenaPolozka,StlacenaPolozka) then begin
                                             AKCIA.typ := 1;
                                             AKCIA.plocha := ActualPlochaS;
                                             AKCIA.meno := StlacenaPolozka.Meno;
                                          end;
                                          HideMouse;
                                          Stav := Nestlaceny;
                                          Show;
                                          ShowMouse;
{                                          Control;}
{                                         if Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                          Konaj}
                                    end;
                                end;
                         {Objekt}
                         'j' : begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          while LeftButtonPressed do begin
                                          readmouse;
                                          end;
                                          Control;
                                          if Rovnake(NajdenaPolozka,StlacenaPolozka) then begin
                                             AKCIA.typ := 10;
                                             AKCIA.plocha := ActualPlochaS;
                                             AKCIA.meno := StlacenaPolozka.Meno;
                                          end;
                                end;

                         {Textove okno}
                         't' : begin
                                Najdene := false;
                                if Pocet_TxTokien = 1 then begin
                                         PTX:=First_TxTokno;
                                         Najdene := true;
                                         end
                                   else begin
                                             PTX:=First_TxTokno;
                                             for prem := 1 to Pocet_TxtOkien do begin
                                                 if Rovnake(NajdenaPolozka,PTX^.Item) then
                                                 Najdene := true;
                                                 PTX := PTX^.NextTxTokno;
                                             end;
                                        end;
                                   if Najdene then begin
                                    with PTX^ do begin
                                                   AKCIA.typ := 3;
                                                   AKCIA.plocha := ActualPlochaS;
                                                   GetText(MouseY,AKCIA.meno);
                                                   Akcia.Value := GetTextY(MouseY);
                                          if Inserting then
                                              if Inserted <> GetTextY(MouseY) then
                                              begin
                                                   HideMouse;
                                                   prem := GetTextY(MouseY);
                                                   ShowText(Poloha,prem);
{                                                   ZobrazRiadok(Inserted);}
                                                   ShowMouse;
                                              end;
                                    end;
                                   end
                                   else begin
                                if Pocet_TxTokienR = 1 then
                                         PTXr:=First_TxToknoR
                                   else begin
                                             PTXr:=First_TxToknor;
                                             for prem := 1 to Pocet_TxtOkienr do begin
                                                 if Rovnake(NajdenaPolozka,PTXr^.Item) then
                                                 break;
                                                 PTXr := PTXr^.NextTxToknor;
                                            end;
                                        end;
                                    with PTXr^ do begin
                                                   AKCIA.typ := 3;
                                                   AKCIA.plocha := ActualPlochaS;
                                                   GetText(MouseY,AKCIA.meno);
                                                   Akcia.Value := GetTextY(MouseY);

                                          if Inserting then
                                              if Inserted <> GetTextY(MouseY) then
                                              begin
                                                   HideMouse;
                                                   prem := GetTextY(MouseY);
                                                   ShowText(Poloha,prem);
{                                                   ZobrazRiadok(Inserted);}
                                                   ShowMouse;
                                              end;
                                    end;
                         end;
                         end;
{                         end;}


                         {Prepinac}
                         'q' : begin
                                if Pocet_Prepinacov = 1 then PP:=First_Prepinac
                                   else begin
                                             PP:=First_Prepinac;
                                             for prem := 1 to Pocet_Prepinacov do begin
                                               if Rovnake(NajdenaPolozka,PP^.Item) then break;
                                               PP := PP^.NextPrepinac;
                                             end;
                                        end;
                                    with PP^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          while LeftButtonPressed do begin
                                               readMouse;
                                               SetIt(MouseX);
                                          end;

{                               Control;}
{                                         if Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                          Konaj}
                                    end;
                                end;
                         {GrPrepinac}
                         'G' : begin
                                if Pocet_GrPrepinacov = 1 then PGP:=First_GrPrepinac
                                   else begin
                                             PGP:=First_GrPrepinac;
                                             for prem := 1 to Pocet_GrPrepinacov do begin
                                               if Rovnake(NajdenaPolozka,PGP^.Item) then break;
                                               PGP := PGP^.NextGrPrepinac;
                                             end;
                                        end;
                                    with PGP^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
{                                          while LeftButtonPressed do begin}
                                               ReadMOuse;
                                               SetIt(MouseX);
{                                           end;}
{      Á                                Control;}
{                                         if Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                          Konaj}
                                    end;
                                end;
                          {klavesa}
                         'N' : begin
                                   AKCIA.typ := 15;
                                   AKCIA.plocha := ActualPlochaS;
                                   AKCIA.meno := StlacenaPolozka.Meno;
                              end;

                         {Potenciometer}
                         'x' : begin
                                if Pocet_Potikov = 1 then PO:=First_Potik
                                   else begin
                                             PO:=First_Potik;
                                             for prem := 1 to Pocet_Potikov do begin
                                                 if Rovnake(NajdenaPolozka,PO^.Item) then break;
                                                 PO := PO^.NextPotenciometer;
                                             end;
                                        end;
                                    with PO^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          OldY:=MouseY;
                                          NewValue:=Value;
                                          while LeftButtonPressed do begin
                                               readMouse;
                                               dY:=OldY-MouseY;
                                               if abs(dY) > 3 then begin
                                               OldY:=MouseY;
                                               if dy <> 0 then begin
                                                  if dy > 0 then NewValue := NewValue + 1
                                                  else NewValue := NewValue - 1;
                                                  HideMouse;
                                                  SetTo(NewValue);
                                                  ShowMouse;
                                               end;
                                               end;
                                          end;
{                                          Control;}
{                                         if Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                          Konaj}
                                    end;
                                end;

                         {Sprajt}
                         's' : begin
                                if Pocet_Sprajtov = 1 then PSP:=First_Sprajt
                                   else begin
                                             PSP:=First_Sprajt;
                                             for prem := 1 to Pocet_Sprajtov do begin
                                                 if Rovnake(NajdenaPolozka,PSP^.Item) then break;
                                                 PSP := PSP^.NextSprajt;
                                             end;
                                        end;
                                    with PSP^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          HideMouse;
                                          MouseTo(HotX,HotY);
                                          while LeftButtonPressed do begin
                                               readmouse;
                                               SetToXY(MouseX-abs(HotX-Item.x1),
                                                      MouseY-abs(HotY-Item.y1));
                                               if pos(PSP^.Item.Meno,'~pasik') = 0 then begin
                                               if Pocet_TxtOkienR = 1 then PTxr:=First_TxtOknoR
                                               else begin
                                               PTXr:=First_TxtOknoR;
                                               MenoTXTPlochy := copy(PSP^.Item.Meno,0,length(Item.Meno)-13);
                                               while PTXr^.Item.Meno <> MenoTxtPlochy do
                                                     PTXr := PTXr^.NextTxtOknoR;
                                               end;
                                               PomPoloha := (((PSP^.Item.y1 - PTXr^.Rolik^.Item.y1)-2)*
                                                         PTXr^.Rolik^.PocP1R)+1;
                                               PTXr^.Rolik^.ActPol:=PomPoloha;
{                                               PTxR^.Poloha:=PTxR^.Rolik^.ActPol;}
                                               PTXr^.ShowText(PomPoloha,PTXr^.Inserted);
                                               end;
                                          end;
                                          ShowMouse;
                                    end;
                                end;
                          {Bezec}
                         'w' : begin
                                if Pocet_Bezcov = 1 then PBZ:=First_Bezec
                                   else begin
                                             PBZ:=First_Bezec;
                                             for prem := 1 to Pocet_Bezcov do begin
                                                 if Rovnake(NajdenaPolozka,PBZ^.Item) then break;
                                                 PBZ := PBZ^.NextBezec;
                                             end;
                                        end;
                                    with PBZ^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          HideMouse;
                                          while LeftButtonPressed do begin
                                               readmouse;
                                               SetToY(MouseY);
                                          end;
                                          ShowMouse;
                                    end;
                                end;

                         {Tlacidlo s bitmapou}
                         'B' : begin
                                if Pocet_BitButtonov = 1 then PBit:=First_BitButton
                                   else begin
                                             PBit:=First_BitButton;
                                             for prem := 1 to Pocet_BitButtonov do begin
                                                 if Rovnake(NajdenaPolozka,PBit^.Item) then break;
                                                 PBit := PBit^.NextBitButton;
                                             end;
                                        end;
                                    with PBit^ do begin
                                          StlacenaPolozka:=NajdenaPolozka;
                                          HideMouse;
                                          Stav := Stlaceny;
                                          Show;
                                          ShowMouse;
                                          while LeftButtonPressed do begin
                                               Control;
                                               if (Rovnake(NajdenaPolozka,StlacenaPolozka)
                                                  and (not Stav)) then
                                                  begin
                                                       HideMouse;
                                                       Stav := Stlaceny;
                                                       Show;
                                                       ShowMouse;
                                                  end
                                               else if (not (Rovnake(NajdenaPolozka,StlacenaPolozka)))
                                                  and Stav then
                                                    begin
                                                       HideMouse;
                                                       Stav := NeStlaceny;
                                                       Show;
                                                       ShowMouse;
                                                   end;
                                               if (Rovnake(NajdenaPolozka,StlacenaPolozka)
                                                  and (Stav)) then
                                               if (pos('roller~UP',Item.Meno) <> 0) or
                                                  (pos('roller~DN',Item.Meno) <> 0) then
                                begin
                                if Pocet_TxtOkienR = 1 then PTxr:=First_TxtOknoR
                                   else begin
                                         PTXr:=First_TxtOknoR;
                                         MenoTXTPlochy := copy(Item.Meno,0,length(Item.Meno)-10);
                                             for prem := 1 to Pocet_TxtOkienR do begin
                                                 if PTXr^.Item.Meno = MenoTxtPlochy then break;
                                                 PTXr := PTXr^.NextTxtOknor;
                                             end;
                                       end;
                                         if pos('~UP',Item.Meno) <> 0 then PTxR^.Rolik^.ActPol := PTxR^.Rolik^.ActPol -1;
                                         if PTxR^.Rolik^.ActPol = 0 then
                                                PTxR^.Rolik^.ActPol:=1;
{                                                goto BezVypisu;
                                         end;}
                                         if pos('~DN',Item.Meno) <> 0 then PTxR^.Rolik^.ActPol := PTxR^.Rolik^.ActPol +1;
                                         if PTxR^.Rolik^.ActPol > PTxR^.Rolik^.PocPol then
                                            PTxR^.Rolik^.ActPol := PTxR^.Rolik^.PocPol;
{                                            goto BezVypisu;}
{                                         end;}
{                                            if PtxR^.Poloha > PtxR^.SpoluRiadkov then begin
                                               PTxR^.Poloha := PTxR^.SpoluRiadkov;

                                            end;                                  }
{                                            PTxR^>Poloha:=PTxR^.Rolik^.ActPol;}
                                            PTXr^.ShowText(PTxr^.Rolik^.ActPol,PTXr^.Inserted);
                                            BezVypisu:
                                            if Pocet_Sprajtov = 1 then PSP:=First_Sprajt
                                         else begin
                                                 PSP:=First_Sprajt;
                                                 while  pos(Ptxr^.Item.Meno,PSP^.Item.Meno) =0 do
                                                        PSP := PSP^.NextSprajt
                                              end;
                                                 HideMouse;
                                                 PSP^.SetToXY(PSP^.Item.x1,PTxR^.Rolik^.Item.y1+
                                                              trunc(PTxR^.Rolik^.ActPol/PTxR^.Rolik^.PocP1R)+2);
                                                 ShowMouse;
{                                                 HideMOuse;
                                                 ShowMouse; }
                                                 Delay(40);
                                              end;
                                         end;
                                         end;

                                          if Rovnake(NajdenaPolozka,StlacenaPolozka) then begin
                                             AKCIA.typ := 1;
                                             AKCIA.plocha := ActualPlochaS;
                                             AKCIA.meno := StlacenaPolozka.Meno;
                                          end;
                                          HideMouse;
                                          PBit^.Stav := Nestlaceny;
                                          PBit^.Show;
                                          ShowMouse;
{                                          Control;}
{                                         if Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                          Konaj}

                                end;

                         {zapinac}
                         'z' : begin
                                if Pocet_Zapinacov = 1 then PZ:=First_Zapinac
                                   else begin
                                             PZ:=First_Zapinac;
                                             for prem := 1 to Pocet_Zapinacov do begin
                                                 if Rovnake(NajdenaPolozka,PZ^.Item) then break;

                                                  PZ := PZ^.NextZapinac;
                                             end;
                                        end;
                                    with PZ^ do begin
                                          StlacenaPolozka:=AktualnaPolozka;
                                          HideMouse;
                                          PZ^.Stav := Stlaceny;
                                          PZ^.ShowIT;
                                          ShowMouse;
                                          while LeftButtonPressed do begin
                                               Control;
                                               if (Rovnake(NajdenaPolozka,StlacenaPolozka)
                                                  and (not Stav)) then
                                                  begin
                                                       HideMouse;
                                                       Stav := Stlaceny;
                                                       Show;
                                                       ShowMouse;
                                                  end
                                               else if (not (Rovnake(NajdenaPolozka,StlacenaPolozka)))
                                                  and Stav then
                                                    begin
                                                       HideMouse;
                                                       Stav := NeStlaceny;
                                                       Show;
                                                       ShowMouse;
                                                   end;
                                          end;
                                          HideMouse;
                                          PZ^.Stav:=Nestlaceny;
                                          Control;
                                          if Rovnake(StlacenaPolozka,NajdenaPolozka) then
                                          begin
                                             AKCIA.typ := 2;
                                             AKCIA.plocha := ActualPlochaS;
                                             AKCIA.meno := StlacenaPolozka.Meno;
                                             PZ^.Prepni;
                                          end;
                                          PZ^.ShowIt;
{                                          Zapi[prem].Show;}
                                          ShowMouse;
                                          {Konaj}
                                     end;
                                  end;
{                                  end;}

                         {graficky GrZapinac}
                         'Z' : begin
                                if Pocet_GrZapinacov = 1 then PGZ:=First_GrZapinac
                                   else begin
                                             PGZ:=First_GrZapinac;
                                             for prem := 1 to Pocet_GrZapinacov do begin
                                                 if Rovnake(NajdenaPolozka,PGZ^.Item) then break;
                                                  PGZ := PGZ^.NextGrZapinac;
                                             end;
                                       end;
                                    with PGZ^ do begin
                                          StlacenaPolozka:=AktualnaPolozka;
                                          HideMouse;
                                          PGZ^.Stav := Stlaceny;
                                          PGZ^.ShowIT;
                                          ShowMouse;
                                          while LeftButtonPressed do begin
                                               Control;
                                               if (Rovnake(NajdenaPolozka,StlacenaPolozka)
                                                  and (not Stav)) then
                                                  begin
                                                       HideMouse;
                                                       Stav := Stlaceny;
                                                       ShowIt;
                                                       ShowMouse;
                                                  end
                                               else if (not (Rovnake(NajdenaPolozka,StlacenaPolozka)))
                                                  and Stav then
                                                    begin
                                                       HideMouse;
                                                       Stav := NeStlaceny;
                                                       ShowIt;
                                                       ShowMouse;
                                                   end;
                                          end;
                                          HideMouse;
                                          PGZ^.Stav:=Nestlaceny;
                                          Control;
                                          if  Rovnake(StlacenaPolozka,NajdenaPolozka) then
                                          begin
                                             AKCIA.typ := 2;
                                             AKCIA.plocha := ActualPlochaS;
                                             AKCIA.meno := StlacenaPolozka.Meno;
                                             PGZ^.Prepni;
                                          end;
                                          PGZ^.ShowIt;
{                                          Zapi[prem].Show;}
                                          ShowMouse;
                                          {Konaj}
                                     end;
                                  end;

                         {Roller}
{                         'o' : begin
                                for prem := RolKolko downto 1 do
                                begin
                                     if Rovnake(NajdenaPolozka,Rol[prem]^.Item) then
                                     begin
                                          StlacenaPolozka:=AktualnaPolozka;
                                          HideMouse;
                                          while LeftButtonPressed do begin
                                               readMouse;
                                               Control;
                                               Rol[prem]^.Roleruj(Mousex,MouseY);
                                               ShowMouse;
                                               if not Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                               VypisSpravu;
                                          end;
                                          HideMouse;
                                          Zapi[prem]^.Stav := Nestlaceny;
                                          Control;
                                          if Rovnake(StlacenaPolozka,NajdenaPolozka) then
                                          Zapi[prem]^.Prepni;
                                          Zapi[prem]^.ShowIt;
{                                          Zapi[prem].Show;}
{                                          ShowMouse;}
                                          {Konaj}
{                                          break;
                                     end;
                                end;
                               e9nd;      }

                         {riadok na pisanie}
                         'l' : begin
                                if Pocet_RnaPi = 1 then PRP := First_Rnapi
                                else begin
                                     PRP := First_RnaPi;
                                     for prem := 1 to Pocet_Rnapi do begin
                                            if Rovnake(NajdenaPolozka,PRP^.Item) then
                                               break;
                                            PRP := PRP^.NextRnaPi;
                                     end;
                                     end;
                                     with PRP^ do begin
                                          HideMouse;
                                          Edit(MouseX,MouseY);
                                          while LeftButtonPressed do begin
                                               readMouse;
                                          end;
                                          ShowMouse;
                                     end;
                         end;
{}
                         'r' : begin

{                                if Pocet_RButtonov = 1 then PRB:=First_RButton
                                   else begin}
                                             PRB:=First_RButton;
                                             repeat
                                              with PRB^ do begin
                                               for prem := 0 to Kolko -1 do
                                                   if RovnakeRBP(RadioItem[prem]^,NajdenaPolozka) then
                                                   goto RBdalej;
                                               end;
                                               PRB := PRB^.NextRButton
                                             until RovnakeRBP(PRB^.RadioItem[prem]^,NajdenaPolozka);
{                                        end;}
                                    RBdalej:
                                    with PRB^ do begin
{                                          StlacenaPolozka:=AktualnaPolozka;}
                                          if Value <> prem then begin
                                                HideMouse;
                                                Value := prem;
                                                SetIT;
                                                ShowMouse;
                                                AKCIA.typ := 4;
                                                AKCIA.plocha := ActualPlochaS;
                                                AKCIA.meno := StlacenaPolozka.Meno;
                                         end;

{                                          while LeftButtonPressed do begin
                                               readMouse;
                                               Control;
                                               if not Rovnake(StlacenaPolozka,NajdenaPolozka) then
                                               break;
                                          end;
                                          HideMouse;
                                          PRB^.Stav := Nestlaceny;
                                          Control;
                                          if Rovnake(StlacenaPolozka,NajdenaPolozka) then
                                          begin                                          }
{                                             PRB^.Prepni;}
                                          end;
{                                          PRB^.ShowIt;}
{                                          Zapi[prem].Show;}
{                                          ShowMouse;}
                                          {Konaj}
                                     end;
                                  end;

{                        'r' : begin
                                for prem := RButtKolko downto 1 do
                                begin
                                     with RButko[prem]^ do begin
                                          for prem2 := 0 to Kolko -1 do
                                          begin
                                              If RovnakeRBP(RadioItem[prem2]^,NajdenaPolozka) then
                                              begin
                                                HideMouse;
                                                RButko[prem]^.Value := prem2;
                                                RBUtko[prem]^.SetIt;
                                                ShowMouse;
                                                while LeftButtonPressed do begin
                                                      readMouse;
                                                Control;
                                                {ak sme inde ako sme boli...potom zmen kurzor a vypis spravu}
{                                                if not Rovnake(AktualnaPolozka,NajdenaPolozka) then
                                                break;

                                                end;
                                                break;
                                              end;}
{                                          end;
                                     end;
                                end;
                             end;}
                    end;

            end;
{            end;}

procedure  GetAction(var Akcijka : AktType);
           begin
                Akcijka := Akcia;
                Akcia.Typ := 0;
           end;



end.