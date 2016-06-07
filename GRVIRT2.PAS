unit GrVirt2;

interface

uses GrVirt,Graph,Bitmaps,Crt,Mouse;

const MaxPocetRiadkov = 128;

type PString = ^string;

type JedenObraz = array [0..65000] of byte;
     PObrazok    = ^JedenObraz;

type TTxtOkno = record
              Name   : string;
              Mess   : string;
              Sposob : byte;
              XX,YY  : byte; {znaky x riadky}
              CelkRiadkov : integer;
              Farba  : byte;
              Backgr : byte;
              Znacenie : boolean;
              Oznaceny : byte;
              end;

type TRoller = record
          Name   : string;
          a,b    : integer;
          d      : integer;
          PP     : word;
          PP1R   : byte;
          AP     : word;
          Mess   :string;  {odkaz pre dialogovy riadok}
          Akt    :boolean; {je pristupny?}
          end;


{objekt}
type Objekt = object(Plocha)
              constructor Init(Name,Mess:string;a,b,c,d:integer);
              destructor Done;virtual;
              end;

type OObjekt = object(Objekt)
             NextObjekt : pointer;
             end;
{roller}
type Roller = object(Plocha)
           PocPol : word;
           PocP1R : byte;
           ActPol : word;
           Vnutro : pointer; {vnutro tlacidla}
           constructor Init(Rolik:TRoller);
           destructor Done;virtual;
           procedure Show;virtual;
           procedure Stlac(a,b,c,d:integer);virtual;
           procedure Pusti(a,b,c,d:integer);virtual;
{          procedure Incrase;
           procedure Decrase;
           procedure IncraseByPage;
           procedure DecraseByPage;}
           end;

type ORoller = object(Roller)
             NextRoller : pointer;
             end;

{Textove okno}
type TxtOkno = object(Plocha)
             PocetRiadkov : integer;
             PocetZnakov  : byte;
             Poloha       : integer;
             SposobPisania: byte;
             SpoluRiadkov : integer;
             FarbaPisma   : byte;
             FarbaPozadia : byte;
             Inserting : boolean;
             Inserted : byte;
             PrvyRiadok : byte;
             Textik       : array[1..MaxPocetRiadkov] of string;
             constructor Init(x,y:integer;TTO:TTxtOkno;Buffer:array of string);
             destructor Done;virtual;
             procedure NakresliPlochu;virtual;
             procedure ShowText(AktualPoloha:integer;Ins:byte);virtual;
             procedure ZmenaVTexte(riadok:integer;TxT:string);virtual;
             procedure ZobrazRiadok(riadok:integer);virtual;
             function GetTextX(x:integer):byte;virtual;
             function GetTextY(y:integer):byte;virtual;
             procedure GetText(y:integer;var Buffer:string);virtual;
             end;

type OTxtOkno = object(TxtOkno)
                NextTxtOkno : pointer;
                end;

type TxtOknoR = object(TxtOkno)
             TRolik : Troller;
             Rolik : ^Roller;
             constructor Init(x,y:integer;TTO:TTxtOkno;Buffer:array of string);
             destructor Done;virtual;
             procedure PutRoller;
             end;

type OTxtOknoR = object(TxtOknoR)
                NextTxtOknoR : pointer;
                end;


{plocha s prvkami (buttony, riadky na pisanie, ...)}
type oOkno = object(Plocha)
            {tlacidla}
            Pocet_buttonov : word;
            First_Button   : pointer;
            {zapinace}
            Pocet_Zapinacov : word;
            First_Zapinac   : pointer;
            {obrazkove buttony}
            Pocet_BitButtonov : word;
            First_BitButton   : pointer;
            {radio buttony}
            Pocet_RButtonov : word;
            First_RButton   : pointer;
            {sprajty}
            Pocet_Sprajtov : word;
            First_Sprajt   : pointer;
            {prepinace}
            Pocet_Prepinacov : word;
            First_Prepinac   : pointer;
            {prepinace}
            Pocet_GrZapinacov : word;
            First_GrZapinac   : pointer;
            {potenciometre}
            Pocet_Potikov : word;
            First_Potik   : pointer;
            {bezce}
            Pocet_Bezcov : word;
            First_Bezec  : pointer;
            {graficke prepinace}
            Pocet_GrPrepinacov : word;
            First_GrPrepinac  : pointer;
            {rollery}
            Pocet_Rollerov : word;
            First_Roller   : pointer;
            {Textove okna}
            Pocet_TxtOkien : word;
            First_TxtOkno  : pointer;
            {Textove okna + rolery}
            Pocet_TxtOkienR : word;
            First_TxtOknoR  : pointer;
            {Riadky na pisanie}
            Pocet_RNapi : word;
            First_RNapi : pointer;
            {Objekty}
            Pocet_Objektov : word;
            First_Objekt : pointer;
            {////////////////////////}
            constructor Init(Name:string;Vid:boolean;a,b,c,d:integer;Mess:string);
            destructor Done;virtual;
end;

var  Ploska : array[1..256] of ^oOkno;

implementation

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Roller                                                                    }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

procedure UrobBT(Butt:TButton;x1,y1,xx,yy:integer;nf:byte;Obrazok:pointer);
          var PB : ^OBitmapButton;
              OP : ^OBitmapbutton;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_BitButtonov = 0 then begin
                  New(PB,Init(Butt,x1,y1,xx,yy,nf,Obrazok));
                  First_BitButton:=PB;
                  end
               else begin
                  OP:=First_BitButton;
                  for prem := 1 to Pocet_BitButtonov - 1 do
                      OP := OP^.NextBitButton;
                  New(PB,Init(Butt,x1,y1,xx,yy,nf,Obrazok));
                  OP^.NextBitButton := PB;
               end;
               Pocet_BitButtonov:=Pocet_BitButtonov+1;
               PB^.Show;
             end;
          end;


procedure UrobSP(S:TSprite; P,Pb:pointer;xx,yy:integer);
          var PS : ^OSprajt;
              OPS : ^OSprajt;
              prem : word;
          begin
             with Ploska[AktualneOkno]^ do begin
               if Pocet_Sprajtov = 0 then begin
                  New(PS,Init(S,P,Pb));
                  First_Sprajt:=PS;
                  end
               else begin
                  OPS:=First_Sprajt;
                  for prem := 1 to Pocet_Sprajtov - 1 do
                      OPS := OPS^.NextSprajt;
                  New(PS,Init(S,P,Pb));
                  OPS^.NextSprajt := PS;
               end;
               Pocet_Sprajtov:=Pocet_Sprajtov+1;
               PS^.SetToXY(xx,yy);
             end;
          end;

constructor Roller.Init(Rolik:TRoller);
          var Butto   : Tbutton;
          begin
               with Rolik do begin
                     Item.Meno := Name;
                     Item.x1 := a; Item.y1 := b+15;
                     Item.x2 := a+16 ;Item.y2 := b+d-15;
                     Item.typek := 'o';
                     Item.Message := Mess;
                     Aktivita := Akt;
                     PocPol := PP;
                     PocP1R := PP1R;
                     ActPol := AP;
               end;
               Front.Init;
               with Item do begin
                     Butto.Name :=Meno+'~UP';
                     Butto.a := x1 ; Butto.b := y1 -15;
                     Butto.c := 16  ; Butto.d := 15;
                     Butto.Mess := Message;
                     Butto.Akt:=Aktivita;
               end;
               UrobBT(Butto,3,3,10,10,1,@UPbutt);
               with Item do begin
                     Butto.Name :=Meno+'~DN';
                     Butto.a := x1 ; Butto.b := y2 ;
                     Butto.c := 16  ; Butto.d :=15;
                     Butto.Mess := Message;
                     Butto.Akt:=Aktivita;
               end;
               UrobBT(Butto,3,2,10,10,1,@Downbutt);

          end;

procedure Roller.Show;
          var Vel,Posuv:integer;
              Sprajto : TSprite;
              ZaNim   : Pointer;
              On      : pointer;
          begin
          with Item do begin
                    setfillstyle(1,8);
                    Bar(x1,y1,x2,y2);
                    setcolor(0);
                    line(x1,y1,x2,y1);
                    line(x1,y1,x1,y2);
                    setcolor(0);
                    line(x2,y1+1,x2,y2);
                    line(x1+1,y2,x2,y2);
{rolovaci pas}
                    SetColor(15);
                    Vel:=(y2-y1-2)-trunc(PocPol/PocP1R)-1;
                    Posuv:=trunc(ActPol/PocP1R)+2;
                    GetMem(ZaNim,ImageSize(x1+2,y1+Posuv,x2-1,y1+Posuv+Vel));
                    GetImage(x1+2,y1+Posuv,x2-1,y1+Posuv+Vel,ZaNim^);
                    SetFillstyle(1,7);
                    Bar(x1+2,y1+Posuv,x2-1,y1+Posuv+Vel);
                    SetColor(15);
                    Line(x1+2,y1+Posuv,x1+2,y1+Vel+Posuv);
                    Line(x1+2,y1+Posuv,x2-1,y1+Posuv);
                    SetColor(8);
                    Line(x1+2,y1+Vel+Posuv,x2-1,y1+Vel+Posuv);
                    Line(x2-1,y1+Posuv,x2-1,y1+Vel+Posuv);
                    GetMem(On,ImageSize(x1+2,y1+Posuv,x2-1,y1+Posuv+Vel));
                    GetIMage(x1+2,y1+Posuv,x2-1,y1+Posuv+Vel,On^);
                    with Sprajto do begin
                         Name := Item.Meno+'~pasik';
                         a := x1+2;
                         b := y1+Posuv;
                         c := x1+17;
                         d := y1+Posuv+Vel;
                         HX := x1+9;
                         HY := y1+trunc(Vel/2)+Posuv;
                         MiX:=x1+2;
                         MiY:=y1+2;
                         MaX:=x1+2;
                         MaY:=y2-2-Vel;
                         PBP:=1;
                         Mess:=Message;
                         Akt:=Aktivita;
                    end;
               UrobSP(Sprajto, On,Zanim,x1+2,y1+Posuv);
               end;
             end;

procedure Roller.Stlac(a,b,c,d:integer);
          begin
               GetMem(Vnutro,ImageSize(a+1,b+1,c-1,d-1));
               GetImage(a+1,b+1,c-1,d-1,Vnutro^);
               PutImage(a+2,b+2,Vnutro^,NormalPut);
                    setcolor(15);
                    line(a,b,c,a);
                    line(a,b,a,d);
                    setcolor(0);
                    line(c,b+1,c,d);
                    line(a+1,d,c,d);
          end;


procedure Roller.Pusti(a,b,c,d:integer);
          begin
               PutImage(a+1,b+1,Vnutro^,NormalPut);
                    setcolor(0);
                    line(a,b,c,a);
                    line(a,b,a,d);
                    setcolor(15);
                    line(c,b+1,c,d);
                    line(a+1,d,c,d);
               FreeMem(Vnutro,ImageSize(a+1,b+1,c-1,d-1));
          end;

destructor Roller.Done;
           begin
                Front.DeleteFromFront;
           end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{Objekt                                                                     }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Objekt.Init(Name,Mess:string;a,b,c,d:integer);
            begin
                  with Item  do begin
                       x1:=ActualX+a;y1:=ActualY+b;
                       Meno:=Name;
                       Message:=Mess;
                       x2:=x1+c;
                       y2:=y1+d;
                       Typek:='j';
                  end;
                  Front.Init;
             end;

destructor Objekt.Done;
           begin
{                Front.Done;}
           end;
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{Textove okno                                                               }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor  TxtOkno.Init(x,y:integer;TTO:TTxtOkno;Buffer:array of string);
             var prem : integer;
             begin
                  with Item  do begin
                       x1:=ActualX+x+4;y1:=ActualY+y+4;
                       Meno:=TTO.Name;
                       Message:=TTO.Mess;
                       x2:=x1+(8*TTO.XX);
                       y2:=y1+(4*TTO.YY-4)+(8*TTO.YY);
                       Typek:='t';
                       SposobPisania:=TTO.Sposob;
                       PocetZnakov:=TTO.XX;
                       PocetRiadkov:=TTO.YY;
                       Poloha:=1;
                       PrvyRiadok:=poloha;
                       SpoluRiadkov:=TTO.CelkRiadkov;
                       FarbaPisma:=TTO.Farba;
                       FarbaPozadia:=TTO.Backgr;
                       Inserting := TTO.Znacenie;
                       Inserted := TTO.Oznaceny;
                  end;
                  Front.Init;
                  For prem := 1 to SpoluRiadkov do
{                      new(Textik[prem]);}
                      Textik[prem]:=Buffer[prem-1];
             end;

destructor TxtOkno.Done;
           begin
                Front.DeleteFromFront;
           end;

procedure TxtOkno.NakresliPlochu;
          begin
               with Item do begin;
                    SetfillStyle(1,FarbaPozadia);
                    bar(x1-4,y1-4,x2+4,y2+4);
                    SetColor(8);
                    Line(x1-4,y1-4,x2+4,y1-4);
                    Line(x1-4,y1-4,x1-4,y2+4);
                    SetColor(15);
                    Line(x1-4,y2+4,x2+4,y2+4);
                    Line(x2+4,y1-4,x2+4,y2+4);
               end;
          end;

procedure TxtOkno.ShowText(AktualPoloha:integer;Ins:byte);
          var a,b : integer;
              Retazec : string;
              PX:Integer;
          begin
{               if AktualPoloha <= (SpoluRiadkov-PocetRiadkov) then}
               if (Poloha <> AktualPoloha) or (Ins <> Inserted) then begin
               Inserted:=Ins;
               Poloha := AktualPoloha;
               SetColor(FarbaPisma);
               SetTextStyle(0,0,1);
               SetTextJustify(SposobPisania,2);
               PX:=Item.x1;
               if SposobPisania = 1 then PX := Item.x1 + trunc((Item.x2-Item.x1)/2);
               with Item do begin
                    b:=Poloha;
                    if SpoluRiadkov-AktualPoloha < PocetRiadkov then
                    b:=Poloha-PocetRiadkov+(SpoluRiadkov-Poloha)+1;
                    PrvyRiadok:=b;
                    for a:=1 to PocetRiadkov do begin
                         Retazec := Textik[b];
                        if length(Textik[b]) > PocetZnakov then
                         Retazec := copy(Textik[b],0,PocetZnakov);
                         setfillstyle(1,FarbaPozadia);
                         SetColor(FarbaPisma);
                         if Inserting and( b= Inserted) then begin
                            SetColor(0);
                            SetFillStyle(1,15);
                         end;
                         bar(x1,y1+a*4-4+(a*8-8)-1,x2,y1+a*4-4+(a*8));
                         OutTextXY(PX,y1+a*4-4+(a*8-8),Retazec);
                         b:=b+1;
                    end;
               end;
               end;
          end;

procedure TxtOkno.ZmenaVTexte(riadok:integer;TxT:string);
          begin
               Textik[riadok]:=Txt;
               ZobrazRiadok(riadok);
          end;

procedure TxtOkno.ZobrazRiadok(riadok:integer);
          var  PX:integer;
               Retazec : string;
               VirtRiadok   : byte;
          begin
             if (riadok >= Poloha) and (riadok <= (Poloha + PocetRiadkov)) then
             begin
               VirtRiadok:=Riadok;
               if Riadok > PocetRiadkov then
                  VirtRiadok := (Riadok mod PocetRiadkov);
                  if VirtRiadok =0 then VirtRiadok:=4;
               with Item do begin
{                    SetFillStyle(0,1);
                    bar(x1+4,y1+(riadok*4-4)+(riadok*8-8),x2,y1+(riadok*4-4)+(riadok*8));}
                    SetTextJustify(SposobPisania,2);
                    PX:=Item.x1;
                    SetColor(FarbaPisma);
                    SetTextStyle(0,0,1);
                         if Inserting and(Riadok = Inserted) then begin
                            SetColor(0);
                            SetFillStyle(1,15);
                         end;
                    if SposobPisania = 1 then PX := trunc((Item.x2-Item.x1)/2);
                        if length(Textik[Riadok]) > PocetZnakov then
                           Retazec := Textik[Riadok];
                         Retazec := copy(Textik[Riadok],0,PocetZnakov);
                         bar(x1,y1+VirtRiadok*4-4+(VirtRiadok*8-8)-1,x2,y1+VirtRiadok*4-4+(VirtRiadok*8));
                         OutTextXY(PX,y1+VirtRiadok*4-4+(VirtRiadok*8-8),Retazec);
               end;
             end;
          end;
function TxtOkno.GetTextX(x:integer):byte;
         begin
              GetTextX := trunc((x - Item.x1) / 8)+1;
         end;

function TxtOkno.GetTextY(y:integer):byte;
         begin
              GetTextY := trunc((y - Item.y1+11) div 12)+PrvyRiadok-1;
         end;

procedure TxtOkno.GetText(y:integer;var Buffer:string);
          begin
               Buffer := Textik[GetTextY(y)];
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{TxtOknoR                                                                   }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor TxtOknoR.Init(x,y:integer;TTO:TTxtOkno;Buffer:array of string);
            var prem : integer;
            begin
                 TxtOkno.Init(x,y,TTO,Buffer);
{                  For prem := 1 to SpoluRiadkov do
                      Textik[prem]:=Buffer[prem-1];}

                 with Trolik do begin
                      Name := Item.Meno + '~roller' ;
                      a:= Item.x2 + 5 ; b:= Item.y1 -4 ;
                      d:=Item.y2-Item.y1+8;
                      PP:= SpoluRiadkov;
                      PP1R := PocetRiadkov;
                      AP := Poloha;
                      Mess := Item.Message;
                      Akt := true;
                 end;
                 New(Rolik,Init(Trolik));
            end;

destructor TxtOknoR.Done;
           begin
                Rolik^.Done;
                TxtOkno.Done;
           end;

procedure  TxtOknoR.PutRoller;
           begin
                Rolik^.Show;
           end;




{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{Okno                                                                       }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor oOkno.Init(Name:string;Vid:boolean;a,b,c,d:integer;Mess:string);
            begin
                 Plocha.Init(Name,Vid,a,b,c,d,Mess);
                 Pocet_Buttonov:=0;
                 Pocet_Zapinacov:=0;
                 Pocet_RButtonov:=0;
                 Pocet_BitButtonov:=0;
                 Pocet_Sprajtov:=0;
                 Pocet_Prepinacov:=0;
                 Pocet_GrZapinacov:=0;
                 Pocet_Potikov:= 0;
                 Pocet_Bezcov :=0;
                 Pocet_GrPrepinacov :=0;
                 Pocet_Rollerov :=0;
                 Pocet_TxtOkien :=0;
                 Pocet_TxtOkienR :=0;
                 Pocet_RNaPi := 0;
                 Pocet_Objektov:=0;
            end;

destructor oOkno.Done;
          var PB  : ^Obutton;
              PBit: ^OBitmapButton;
              PZ  : ^OZapinac;
              PRB : ^ORadioButton;
              PSP : ^OSprajt;
              PP  : ^OPrepinac;
              PGZ : ^OGrZapinac;
              PO  : ^OPotenciometer;
              PBZ : ^OBezec;
              PGP : ^OGrPrepinac;
              PR  : ^ORoller;
              PTX : ^OTxtOkno;
              PTXr: ^OTxtOknoR;
              PrP : ^ORiadokNaPisanie;
              Pob : ^OObjekt;
              OP  : pointer;
              prem : integer;
           begin

                     {Zrus buttony}
                     if Pocet_Buttonov > 0 then begin
                        if Pocet_Buttonov = 1 then begin
                             PB:=First_Button;
                             PB^.DeleteFromFront;
                             end
                        else begin
                             PB:=First_Button;
                             OP := PB^.NextButton;
                             PB^.DeleteFromFront;
                             PB:=OP;
                             for prem := 2 to Pocet_Buttonov do
                                 begin
                                      OP:=PB^.NextButton;
                                      PB^.DeleteFromFront;
                                      PB:=OP;
                                 end;
                             end;
                        end;
                     {}
                     {Zrus BitmapButtony}
                     if Pocet_BitButtonov > 0 then begin
                        if Pocet_BitButtonov = 1 then begin
                             PBit:=First_BitButton;
                             PBit^.DeleteFromFront;
                             end
                        else begin
                             PBit:=First_BitButton;
                             OP := PBit^.NextBitButton;
                             PBit^.DeleteFromFront;
                             PBit:=OP;
                             for prem := 2 to Pocet_BitButtonov do
                                 begin
                                      OP:=PBit^.NextBitButton;
                                      PBit^.DeleteFromFront;
                                      PBit:=OP;
                                 end;
                             end;
                        end;
                     {}

                     {Zrus zapinace}
                     if Pocet_Zapinacov > 0 then begin
                        if Pocet_Zapinacov = 1 then begin
                             PZ:=First_Zapinac;
                             PZ^.DeleteFromFront;
                             end
                        else begin
                             PZ:=First_Zapinac;
                             OP := PZ^.NextZapinac;
                             PZ^.DeleteFromFront;
                             PZ:=OP;
                             for prem := 2 to Pocet_Zapinacov do
                                 begin
                                      OP:=PZ^.NextZapinac;
                                      PZ^.DeleteFromFront;
                                      PZ:=OP;
                                 end;
                             end;
                        end;

                     {Zrus GrPrepinace}
                     if Pocet_GrPrepinacov > 0 then begin
                        if Pocet_GrPrepinacov = 1 then begin
                             PGP:=First_GrPrepinac;
                             PGP^.DeleteFromFront;
                             end
                        else begin
                             PGP:=First_GrPrepinac;
                             OP := PGP^.NextGrPrepinac;
                             PGP^.DeleteFromFront;
                             PGP:=OP;
                             for prem := 2 to Pocet_GrPrepinacov do
                                 begin
                                      OP:=PGP^.NextGrPrepinac;
                                      PGP^.DeleteFromFront;
                                      PGP:=OP;
                                 end;
                             end;
                        end;

                        {}
                     {Zrus RBoxy}
                     if Pocet_RButtonov > 0 then begin
                        if Pocet_RButtonov = 1 then begin
                             PRB:=First_RButton;
                             PRB^.Done {DeleteFromFront};
                             end
                        else begin
                             PRB:=First_RButton;
                             OP := PRB^.NextRButton;
                             PRB^.Done {DeleteFromFront};
                             PRB:=OP;
                             for prem := 2 to Pocet_RButtonov do
                                 begin
                                      OP:=PRB^.NextRButton;
                                      PRB^.Done {DeleteFromFront};
                                      PRB:=OP;
                                 end;
                             end;
                        end;
                     {Zrus Sprajty}
                     if Pocet_Sprajtov > 0 then begin
                        if Pocet_Sprajtov = 1 then begin
                             PSP:=First_Sprajt;
                             PSP^.Done {DeleteFromFront};
                             end
                        else begin
                             PSP:=First_Sprajt;
                             OP := PSP^.NextSprajt;
                             PSP^.Done {DeleteFromFront};
                             PSP:=OP;
                             for prem := 2 to Pocet_Sprajtov do
                                 begin
                                      OP:=PSP^.NextSprajt;
                                      PSP^.Done {DeleteFromFront};
                                      PSP:=OP;
                                 end;
                             end;
                        end;
                     {Zrus prepinace}
                     if Pocet_Prepinacov > 0 then begin
                        if Pocet_Prepinacov = 1 then begin
                             PP:=First_Prepinac;
                             PP^.Done {DeleteFromFront};
                             end
                        else begin
                             PP:=First_Prepinac;
                             OP := PP^.NextPrepinac;
                             PP^.Done {DeleteFromFront};
                             PP:=OP;
                             for prem := 2 to Pocet_Prepinacov do
                                 begin
                                      OP:=PP^.NextPrepinac;
                                      PP^.Done {DeleteFromFront};
                                      PP:=OP;
                                 end;
                             end;
                        end;
                     {Zrus GrZapinace}
                     if Pocet_GrZapinacov > 0 then begin
                        if Pocet_GrZapinacov = 1 then begin
                             PGZ:=First_GrZapinac;
                             PGZ^.DeleteFromFront;
                             end
                        else begin
                             PGZ:=First_GrZapinac;
                             OP := PGZ^.NextGrZapinac;
                             PGZ^.DeleteFromFront;
                             PGZ:=OP;
                             for prem := 2 to Pocet_GrZapinacov do
                                 begin
                                      OP:=PGZ^.NextGrZapinac;
                                      PGZ^.DeleteFromFront;
                                      PGZ:=OP;
                                 end;
                             end;
                        end;
                     {Zrus potenciometre}
                     if Pocet_Potikov > 0 then begin
                        if Pocet_Potikov = 1 then begin
                             PO:=First_Potik;
                             PO^.DeleteFromFront;
                             end
                        else begin
                             PO:=First_Potik;
                             OP := PO^.NextPotenciometer;
                             PO^.DeleteFromFront;
                             PO:=OP;
                             for prem := 2 to Pocet_Potikov do
                                 begin
                                      OP:=PO^.NextPotenciometer;
                                      PO^.DeleteFromFront;
                                      PO:=OP;
                                 end;
                             end;
                        end;
                     {Zrus riadky na pisanie}
                     if Pocet_RNaPi > 0 then begin
                        if Pocet_RNaPi = 1 then begin
                             PrP:=First_RnaPI;
                             PrP^.DeleteFromFront;
                             end
                        else begin
                             PrP:=First_RnaPi;
                             OP := PrP^.NextRNaPi;
                             PrP^.DeleteFromFront;
                             PrP:=OP;
                             for prem := 2 to Pocet_RNaPi do
                                 begin
                                      OP:=PrP^.NextRNaPi;
                                      PrP^.DeleteFromFront;
                                      PrP:=OP;
                                 end;
                             end;
                        end;

                     {Zrus Bezce}
                     if Pocet_Bezcov > 0 then begin
                        if Pocet_Bezcov = 1 then begin
                             PBZ:=First_Bezec;
                             PBZ^.DeleteFromFront;
                             end
                        else begin
                             PBZ:=First_Bezec;
                             OP := PBZ^.NextBezec;
                             PBZ^.DeleteFromFront;
                             PBZ:=OP;
                             for prem := 2 to Pocet_Bezcov do
                                 begin
                                      OP:=PBZ^.NextBezec;
                                      PBZ^.DeleteFromFront;
                                      PBZ:=OP;
                                 end;
                             end;
                        end;
                     {Zrus rolery}
                     if Pocet_Rollerov > 0 then begin
                        if Pocet_Rollerov = 1 then begin
                             PR:=First_Roller;
                             PR^.DeleteFromFront;
                             end
                        else begin
                             PR:=First_Roller;
                             OP := PR^.NextRoller;
                             PR^.DeleteFromFront;
                             PR:=OP;
                             for prem := 2 to Pocet_Rollerov do
                                 begin
                                      OP:=PR^.NextRoller;
                                      PR^.DeleteFromFront;
                                      PR:=OP;
                                 end;
                             end;
                        end;
                     {Zrus TxTokna}
                     if Pocet_TxtOkien > 0 then begin
                        if Pocet_TxtOkien = 1 then begin
                             PTX:=First_TxtOkno;
                             PTX^.DeleteFromFront;
                             end
                        else begin
                             PTX:=First_TxtOkno;
                             OP := PTX^.NextTxtOkno;
                             PTX^.DeleteFromFront;
                             PTX:=OP;
                             for prem := 2 to Pocet_TxtOkien do
                                 begin
                                      OP:=PTX^.NextTxtOkno;
                                      PTX^.DeleteFromFront;
                                      PTX:=OP;
                                 end;
                             end;
                        end;
                     {Zrus Objekty}
                     if Pocet_Objektov > 0 then begin
                        if Pocet_Objektov = 1 then begin
                             Pob:=First_Objekt;
                             Pob^.Done {DeleteFromFront};
                             end
                        else begin
                             Pob:=First_Objekt;
                             OP := Pob^.NextObjekt;
                             Pob^.Done {DeleteFromFront};
                             Pob:=OP;
                             for prem := 2 to Pocet_Objektov do
                                 begin
                                      OP:=Pob^.NextObjekt;
                                      Pob^.Done {DeleteFromFront};
                                      Pob:=OP;
                                 end;
                             end;
                        end;

                     {Zrus TxTokna}
                     if Pocet_TxtOkienR > 0 then begin
                        if Pocet_TxtOkien = 1 then begin
                             PTXr:=First_TxtOknoR;
                             PTXr^.DeleteFromFront;
                             end
                        else begin
                             PTXr:=First_TxtOknoR;
                             OP := PTXr^.NextTxtOknoR;
                             PTXr^.DeleteFromFront;
                             PTXr:=OP;
                             for prem := 2 to Pocet_TxtOkienR do
                                 begin
                                      OP:=PTXr^.NextTxtOknoR;
                                      PTXr^.DeleteFromFront;
                                      PTXr:=OP;
                                 end;
                             end;
                        end;
                     {}

                Plocha.Done;
           end;


end.






