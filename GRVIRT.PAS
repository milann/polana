unit Grvirt;

interface
uses Graph,Bitmaps,Pii,Crt,Mouse;

const Visible = true;
      Unvisible = false;
      MColor    = 7;
      Stlaceny = true;
      Nestlaceny = false;
      Zapnuty = true;
      Vypnuty = false;

{polohy potenciometra}
const Polohy : array[0..15,1..2] of integer =(
      (16,26),(13,24),(11,21),(10,18),(11,15),(12,12),(15,10),(18,9),
      (21,9),(24,10),(27,12),(28,15),(29,18),(28,21),(26,24),(23,26));



type TButton = record
             Name    :string;
             a,b,c,d :integer;
             Mess    :string;  {odkaz pre dialogovy riadok}
             Akt     :boolean; {je pristupny?}
             end;

     PButton = ^TButton;

{type TRadioButton = record
          Butto : array [1..6] of TButton;
          Ktory: byte; {ktory je stlaceny}
{          Pocet: byte;
          end;}


{polozka do frontu grafickych objektov}
type Polozka = record
               x1,y1,x2,y2:integer;
               Meno       :string;
               Typek      :char;   {typ objektu}
               Message    :string; {odkaz do dialogoveho riadka}
               end;

type TRiadokNaPisanie = record
                      RName   : string;
                      xx,yy   : integer;
                      VidMena : boolean;
                      PocetM  : byte;    {pocet miest na pisanie}
                      Txt     : string;  {text v riadku}
                      Akt     : boolean;
                      Mess    : string;
                      end;

type TSprite = record
               Name     : string;
               a,b,c,d  : integer;
               HX, HY   : integer;
               MiX, MiY : integer; {Hranice pohybu vzhladom}
               MaX, MaY : integer; {k HotSpot bodom}
               PBP      : integer; {pocet bodov na posuv}
               Mess     : string;
               Akt      : boolean;
               end;


{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Objekty                                                                   }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}


{Eviduje graficke objekty (pre mysku)}
type Front = object
                Item : Polozka;
                constructor Init;
                destructor Done;virtual;
                procedure DeleteFromFront;virtual;
                procedure ZmenavoFronte(Itemik:Polozka);
              end;

{dialogovy riadok}
type  Dialog = object(Front)
           constructor Init;
           destructor Done;virtual;
           procedure WriteMessage(Mess:string);
           procedure Ramik;
    end;

{Hlavna plocha; inicializujeme na zaciatku programu}
type DeskTop = object(Front)
{            CisloPlochy : integer;}
            constructor Init(Mess:string;col:byte;styl:byte);
            destructor Done;virtual;
            procedure Ramik;
            end;

{jedno "okno"}
type Plocha = object(DeskTop)
            Aktivita  : boolean; {je aktivne? ak ano, zobrazi sa}
            Back      : pointer;
            Vidi      : boolean;
            constructor Init(Name:string;Vid:boolean;a,b,c,d:integer;Mess:string);
            procedure Show;virtual;
            destructor Done;virtual;
            procedure SaveBack;
            procedure PutBack;
end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Mozne prvky plochy                                                        }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

{okienko s textikom}
type  RiadokNaPisanie = object(Plocha)
           Textik : string;
           Dlzka  : byte;
           constructor Init(Riadok:TRiadokNaPisanie);
           destructor Done;virtual;
           procedure SetText(Txt:string);
           procedure Edit(x,y:integer);virtual;
           procedure PutKurzor(OldPoz,NewPoz:integer);virtual;
           procedure PridajPismeno(Key:char);virtual;
           procedure Show;virtual;
           procedure ShowText;virtual;
           end;

type OriadokNaPisanie = object(RiadokNaPisanie)
                      NextRNaPI : pointer;
                      end;

{pohyblive plochy}
type Sprajt = object(Plocha)
            PSprajt      : pointer;
            HotX, HotY   : integer;
            MinX, MinY   : integer; {Hranice pohybu vzhladom}
            MaxX, MaxY   : integer; {k HotSpot bodom}
            PoBoPo       : integer; {pocet bodov na posuv}
            constructor Init(S:TSprite;P,Pb:pointer);
            destructor Done;virtual;
            procedure SetToXY(x,y:integer);virtual;
            procedure Zmena(x,y:integer);virtual;
            function GetX:integer;virtual;
            function GetY:integer;virtual;
            end;

type OSprajt = object(Sprajt)
             NextSprajt:pointer;
             end;

{obycajne tlacidlo}
type  Button = object(Plocha)
           stav     : boolean;
           constructor Init(Butt:TButton);
           destructor Done;virtual;
           procedure Show; virtual;
           end;

type OButton = object(Button)
           NextButton : pointer;
           end;

{button s obrazkom}
type  BitmapButton = object(Plocha)
           Bx,By,Dx,Dy : integer;
           nFF         : byte;
           Bitmapa     : pointer;
           stav        : boolean;
           constructor Init(Butt:TButton;x1,y1,xx,yy:integer;nf:byte;Obrazok:Pobrazok);
           destructor Done;virtual;
           procedure Show; virtual;
           end;

type OBitmapButton = object(BitmapButton)
           NextBitButton : pointer;
           end;

{tlacidla vyberu  (.)}
type RadioButton = object(Plocha)
          RadioItem : array[0..24] of PButton;
          Value: byte; {ktory je stlaceny}
          Kolko: byte; {pocet}
          constructor Init(nejm:string;Buttons: array of TButton;Ktory,Pocet:byte);
          destructor Done;virtual;
          procedure Show;virtual;
          procedure SetIt;virtual;
          procedure WriteMess(xx,yy:integer);virtual;
          end;

type ORadioButton = object(RadioButton)
           NextRButton : pointer;
           end;

{graficky prepinac}
type Prepinac = object(Plocha)
          Value: byte;
          Kolko: byte; {pocet}
          Pozadie : array[0..77] of byte;
          constructor Init(Name:string;x,y:integer;Pocet,Ktory:byte;Vid:boolean;Mess:string);
          destructor Done;virtual;
          procedure Show;virtual;
          procedure SetIt(x:integer);virtual;
          end;

type OPrepinac = object(Prepinac)
               NextPrepinac : pointer;
               end;

{Zapinac   (x)}
type Zapinac = object(Plocha)
           stav     : boolean;
           value    : boolean;
           constructor Init(Butt:TButton;Hod:boolean);
           destructor Done;virtual;
           procedure Show; virtual;
           procedure ShowIT; virtual;
           procedure Prepni;virtual;
           end;

type OZapinac = object(Zapinac)
           NextZapinac : pointer;
           end;

{graficky Zapinac   (x)}
type GrZapinac = object(Plocha)
           stav     : boolean;
           value    : byte;
           constructor Init(Name:string;x,y:integer;St:byte;Mess:string);
           destructor Done;virtual;
           procedure Show; virtual;
           procedure ShowIT; virtual;
           procedure Prepni;virtual;
           end;

type OGrZapinac = object(GrZapinac)
           NextGrZapinac : pointer;
           end;

{Potenciometer}
type Potenciometer = object(Plocha)
                   Value : byte;
                   constructor Init(Name:string;x,y:integer;Mess:string;St:boolean);
                   destructor Done;virtual;
                   procedure NakresliHo(newval:byte);virtual;
                   procedure SetTo(newval:integer);virtual;
                   end;

type OPotenciometer = object(Potenciometer)
           NextPotenciometer : pointer;
           end;

{graficky Prepinac   (x)}
type GrPrepinac = object(Plocha)
           Str1,Str2:string;
           Ktory     : byte;
           constructor Init(Name:string;x,y:integer;St:byte;Mess:string);
           destructor Done;virtual;
           procedure Prepni;virtual;
           procedure Show;virtual;
           procedure SetIt(x:integer);
           procedure ShowMeno;virtual;
           end;

type OGrPrepinac = object(GrPrepinac)
           NextGrPrepinac : pointer;
           end;

{bezec}
type Bezec = object(Plocha)
                   Value : integer;
                   Nasobok : integer;
                   DolH,HorH : integer;
                   ZaNim : array[0..246] of byte;
                   constructor Init(Name:string;x,y:integer;HH,DH,Nas:integer;Mess:string;St:boolean);
                   destructor Done;virtual;
                   procedure NakresliHo(newval:integer);virtual;
                   procedure SetToY(Hod:integer);virtual;
                   procedure SetTo(Hod:integer);virtual;
                   end;

type OBezec = object(Bezec)
           NextBezec : pointer;
           end;

procedure Grafika;

var Dial            : Dialog;                    {dialogovy riadok}
    ActualX,ActualY : integer; {Aktualne suradnice laveho horneho rohu}
    ActualMaxX      : integer;
    ActualMaxY      : integer; {Aktualne suradnice praveho dolneho rohu}
    ActualPlochaS   : string;

var PocetPoloziek   : byte;
    Polozky         : array[1..500] of ^Polozka; {front grafickych objektov}
    Desk   : Desktop;
    AktualneOkno : integer;


implementation

procedure Grafika;
          var gd,gm : integer;
          begin
               gd:=detect;
               Initgraph(gd,gm,'d:\tp7\bgi');
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Front objektov (grafickych)                                               }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Front.Init;
          begin
               PocetPoloziek:=PocetPoloziek+1;
               New(Polozky[PocetPoloziek]);
               Polozky[PocetPoloziek]^:=Item;
          end;

procedure Front.DeleteFromFront;
          var prem : byte;
          begin
                 prem:=PocetPoloziek;
               repeat
                      with Polozky[prem]^ do begin
                      if ((((Meno = Item.Meno) and (Message = Item.Message)) and
                         ((x1 = Item.x1) and (y1 = Item.y1))) and
                         ((y2 = Item.y2) and (x2 = Item.x2))) and
                         (Typek = Item.Typek) then begin
                        while prem <> PocetPoloziek do begin
                            Polozky[prem]^ := Polozky[prem+1]^;
                            prem:=prem+1;
                        end;
                        Dispose(Polozky[Prem]);
                        Polozky[prem]:=NIL;
                        PocetPoloziek := PocetPoloziek - 1;
                        exit;
                     end;
                    end;
                     prem := prem - 1;
               until prem = 0;
          end;

procedure Front.ZmenaVoFronte(Itemik:polozka);
          var prem : integer;
          begin
               prem:=PocetPoloziek;
               repeat
                      with Polozky[prem]^ do begin
                      if ((Meno = Itemik.Meno) and (Message = Itemik.Message)) and
                         (Typek = Itemik.Typek) then begin
                         Polozky[prem]^ :=  Itemik;
                         exit;
                      end;
                      end;
                     prem := prem - 1;
               until prem = 0;
          end;

destructor Front.Done;
          var prem : byte;
          begin
               for prem := 1 to PocetPoloziek do Dispose(Polozky[prem]);
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Dialogove okno                                                            }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Dialog.Init;
          begin
               with  Item do begin
                     x1 := 0; y1 := 455;
                     x2 := 640; y2 := 480;
                     Meno := 'Dialog line';
                     Typek := 'g';
                     Message:='Zmizni!'
               end;
               Front.Init;
               {Nakresli ho}
               SetfillStyle(1,0);
               bar(Item.x1,Item.y1,Item.x2,Item.y2);
               Ramik;
          end;

procedure Dialog.WriteMessage(Mess:string);
          begin
              setfillstyle(1,0);
              bar(3,458,637,477);
              SetColor(15);
              SettextStyle(10, 0, 4);
              SettextJustify(0,1);
              Outtextxy(6,466,Mess);
          end;


procedure Dialog.Ramik;
          begin
               setcolor(15);
               Line(Item.x1,Item.y1,Item.x2,Item.y1); Line(Item.x1,Item.y1,Item.x1,Item.y2);
               Line(Item.x1+2,Item.y2-2,Item.x2-2,Item.y2-2);
               Line(Item.x2-2,Item.y1+2,Item.x2-2,Item.y2-2);

               setcolor(7);{(Mcolor);}
               Line(Item.x1+1,Item.y1+1,Item.x2-1,Item.y1+1);
               Line(Item.x1+1,Item.y1+1,Item.x1+1,Item.y2-1);
               Line(Item.x2-1,Item.y1+1,Item.x2-1,Item.y2-1);
               Line(Item.x1+1,Item.y2-1,Item.x2-1,Item.y2-1);

               setcolor(0);
               Line(Item.x1+2,Item.y1+2,Item.x2-2,Item.y1+2);
               Line(Item.x1+2,Item.y1+2,Item.x1+2,Item.y2-3);
               Line(Item.x1,Item.y2,Item.x2,Item.y2);
               Line(Item.x2,Item.y1,Item.x2,Item.y2);
          end;

destructor Dialog.Done;
           begin
                Front.DeleteFromFront;
           end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ DeskTop                                                                   }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
constructor DeskTop.Init(Mess:string;col,styl:byte);
          begin
               Grafika;
               if InstallUserFont('modn') = 100 then ;
               ActualX:=4;ActualY:=4;
               ActualMaxX:=636;ActualMaxY:=450;
               ActualPlochaS := 'desktop';
               PocetPoloziek:=0;
               with  Item do begin
                     x1 := 0; y1 := 0;
                     x2 := 640; y2 := 454;
                     Meno := 'DeskTop';
                     Typek := 'd';
                     Message:=Mess;
               end;
               {Nakresli ho}
               SetfillStyle(col,styl);
               bar(Item.x1,Item.y1,Item.x2,Item.y2);
               Ramik;
               Front.Init;
               Dial.Init;
          end;


procedure DeskTop.Ramik;
          begin
               with Item do begin

               setcolor(15);
               Line(x1,y1,x2,y1); Line(x1,y1,x1,y2);
               Line(x1+3,y2-3,x2-3,y2-3);
               Line(x2-3,y1+3,x2-3,y2-3);

               setcolor(7);{(Mcolor);}
               Line(x1+1,y1+1,x2-1,y1+1);
               Line(x1+2,y1+2,x2-2,y1+2);
               Line(x1+1,y1+1,x1+1,y2-1);
               Line(x1+2,y1+2,x1+2,y2-2);
               Line(x2-1,y1+1,x2-1,y2-1);
               Line(x2-2,y1+2,x2-2,y2-2);
               Line(x1+1,y2-1,x2-1,y2-1);
               Line(x1+2,y2-2,x2-2,y2-2);

               setcolor(8);
               Line(x1+3,y1+3,x2-3,y1+3);
               Line(x1+3,y1+3,x1+3,y2-4);
               Line(x1,y2,x2,y2);
               Line(x2,y1,x2,y2);

          end;

          end;

destructor DeskTop.Done;
           begin
                Front.Done; {znicime front}
                CloseGraph; {..a zavrieme grafiku}
           end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Plocha                                                                    }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Plocha.Init(Name:string;Vid:boolean;a,b,c,d:integer;Mess:string);
          begin
               Vidi := Vid;
               ActualX:=a+4;ActualY:=b+3;
               ActualMaxX:=a+c-4;ActualMaxY:=b+d-4;
               ActualPlochaS:=Name;
               if Vid=true then ActualY := ActualY+20;
               Aktivita := true;
               with  Item do begin
                     x1 := a; y1 := b;
                     x2 := a+c; y2 := b+d;
                     Meno := Name;
                     Typek := 'p';
                     Message:=Mess;
               end;
               Front.Init;
          end;

procedure Plocha.Show;
          begin
               {Nakresli ju}
               SetfillStyle(1,MColor);
               bar(Item.x1,Item.y1,Item.x2,Item.y2);
               if Vidi = visible then begin
                                SettextStyle(10, 0, 4);
                                SettextJustify(1,0);
                                SetColor(0);
                                outtextxy(Item.x1+trunc((Item.x2-Item.x1)/2)+1,Item.y1+15+1,Item.Meno);
                                Setcolor(15);
                                outtextxy(Item.x1+trunc((Item.x2-Item.x1)/2),Item.y1+15,Item.Meno);
                                setcolor(8);
                                line(Item.x1+4,Item.y1+20,Item.x2-4,Item.y1+20);
                                setcolor(15);
                                line(Item.x1+5,Item.y1+21,Item.x2-5,Item.y1+21);
               end;
               Ramik;
          end;

procedure Plocha.SaveBack;
          begin
               if ImageSize(Item.x1,Item.y1,Item.x2,Item.y2) <> 0 then begin
                              GetMem(Back, ImageSize(Item.x1,Item.y1,Item.x2,Item.y2));
                              GetImage(Item.x1,Item.y1,Item.x2,Item.y2,Back^);
               end;
          end;

procedure Plocha.PutBack;
          begin
               if ImageSize(Item.x1,Item.y1,Item.x2,Item.y2) <> 0 then begin
                  PutImage(Item.x1,Item.y1,Back^,NormalPut);
                  FreeMem(Back,ImageSize(Item.x1,Item.y1,Item.x2,Item.y2));
               end;
          end;

destructor Plocha.Done;
          begin
               PutBack;
               Front.DeleteFromFront;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{Sprajt                                                                     }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Sprajt.Init(S:TSprite; P,Pb:pointer);
          begin
             with Item do begin
               x1 := S.a;x2:=S.c;
               y1 := S.b ;y2:=S.d;
               Meno := S.Name;
               Typek := 's';
               Message:=S.Mess;
               Front.Init;
               GetMem(PSprajt, ImageSize(x1,y1,x2,y2));   { Allocate memory on heap }
               GetMem(Back, ImageSize(x1,y1,x2,y2));   { Allocate memory on heap }
               PSprajt:=P;
               Back:=Pb;
             end;
             with S do begin
                  HotX:=HX; HotY:=HY;
                  MinX:=Mix; MinY:=MiY;
                  MaxX:=Max; MaxY:=MaY;
                  PoBoPo:=PBP;
            end;
          end;

destructor Sprajt.Done;
          begin
               PutBack;
               FreeMem(PSprajt,ImageSize(Item.x1,Item.y1,Item.x2,Item.y2));
               Front.DeleteFromFront;
          end;


function Sprajt.GetX:integer;
          begin
               GetX:=Item.X1;
          end;

function Sprajt.GetY:integer;
          begin
               GetY:=Item.y1;
          end;

procedure Sprajt.Zmena(x,y:integer);
          begin
            if x < 0 then x:=-1;
            if x > 0 then x:= 1;
            if y < 0 then y:=-1;
            if y > 0 then y:= 1;
            SetToXY(Item.x1+x,Item.y1+y);
          end;

procedure Sprajt.SetToXY(x,y:integer);
          var Vx,Vy:integer;
              dx,dy:integer;
          begin
               with Item do begin
                    if x<MinX then x:=MinX;
                    if y<MinY then y:=MinY;
                    if x > MaxX then x:= MaxX;
                    if y > MaxY then y:= MaxY;
                    if (x <> x1) or (y <> y1) then begin
                       HotX:=x+(HotX-x1);
                       HotY:=y+(HotY-y1);
                       PutImage(x1,y1,Back^,NormalPut);
                       VX:=abs(x2-x1);VY:=abs(y2-y1);
                       x1:=x;y1:=y;
                       x2:=x+VX;y2:=y+VY;
                       GetImage(x1,y1,x2,y2,Back^);
                       Putimage(x1,y1,PSprajt^,NormalPut);
                    end;
                    ZmenaVoFronte(Item);
               end;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{Riadok na pisanie                                                          }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor RiadokNaPisanie.Init(Riadok:TRiadokNaPisanie);
          var DP : byte;
          begin
          DP:=8;
          with Riadok do begin
                        xx:=xx+ActualX;
                        yy:=yy+ActualY;
                        Dlzka:= PocetM;
                        Textik:=Txt;
                        Vidi:=VidMena;
                        Item.x1 := xx; Item.y1 := yy;
                        Item.x2 := xx+(DP*Dlzka)+14; Item.y2 := yy+17;
                        Item.Meno := RName;
                        Item.Typek := 'l';
                        Item.Message := Mess;
          end;
          Front.Init;
          end;

procedure RiadokNaPisanie.SetText(Txt:string);
          begin
               Textik:=Txt;
          end;

procedure RiadokNaPisanie.PutKurzor(OldPoz,NewPoz:integer);
          var StredY : integer;
          begin
               SetColor(15);
               with Item do begin
               StredY:=trunc((y1+y2)/2)+6;
                    if OldPoz <> -1 then begin
                         SetWriteMode(1);
                         Line(x1+7+OldPoz*8,StredY,x1+13+OldPoz*8,StredY);
                    end;
                       if OldPoz<>NewPoz then begin
                         SetWriteMode(1);
                         Line(x1+7+NewPoz*8,StredY,x1+13+NewPoz*8,StredY);
                       end;
                    end;
          end;

procedure RiadokNaPisanie.PridajPismeno(Key:char);
          begin
          end;

procedure RiadokNaPisanie.Edit(x,y:integer);
          var OldPoz,NewPoz:integer;
              Key : char;
          label koniec;
          begin
               with Item do begin
                    OldPoz := -1;
                    NewPoz := trunc((X-x1-5)/8);
                    If NewPoz > length(Textik) then NewPoz:=length(Textik);
                    PutKurzor(OldPoz,NewPoz);
                    OldPoz:=NewPoz;
                    repeat
                          Key := ReadKey;
                          if ord(Key) = 0 then begin
                             Key := Readkey;
                             case ord(Key) of
                                  {vlavo}
                                  75 : begin
                                            If OldPoz <> 0 then begin
                                               NewPoz := NewPoz - 1;
                                               PutKurzor(OldPoz,NewPoz);
                                            end;
                                         end;
                                  {vpravo}
                                  77 : begin
                                            If OldPoz < length(Textik) then begin
                                               NewPoz := NewPoz + 1;
                                               PutKurzor(OldPoz,NewPoz);
                                            end;
                                       end;
                                  {END}
                                  79 : begin
                                         if OldPoz <> length(Textik) then begin
                                            NewPoz := length(Textik);
                                            PutKurzor(OldPoz,NewPoz);
                                         end;
                                       end;
                                  {HOME}
                                  71 : begin
                                          if OldPoz <> 0 then begin
                                            NewPoz := 0;
                                            PutKurzor(OldPoz,NewPoz);
                                          end;
                                       end;
                                  {DEL}
                                  83 : begin
                                            Delete(Textik,NewPoz+1,1);
                                            ShowText;
                                            PutKurzor(OldPoz,NewPoz);
                                       end;
                             end;
                          end
                          else begin
                               case ord(Key) of
                                    {BackSpace}
                                    8 : begin
                                           if OldPoz <> 0 then begin
                                             Delete(Textik,OldPoz,1);
                                             ShowText;
                                             NewPoz := NewPoz - 1;
                                             PutKurzor(-1,NewPoz);
                                           end;
                                        end;
                                    {ESC}
                                    27 : goto koniec;

                                32..126: begin
                                           if length(Textik) <> Dlzka then begin
{                                              if OldPoz = length(Textik) then PridajPismeno(Key)}
{                                              else begin}
                                                   Insert(Key,Textik,OldPoz+1);
                                                   ShowText;
                                                   NewPoz:=NewPoz+1;
                                                   PutKurzor(-1,NewPoz);
{                                              end;}
                                           end;
                                         end;

                               end;
                               end;
                               OldPoz:=NewPoz;
                    until ord(Key) = 13;
                    koniec:
                    PutKurzor(NewPoz,NewPoz);
                    SetWriteMode(0);
               end;
          end;

Procedure RiadokNaPisanie.Show;
          var DP : byte;
              Col : byte;
          begin
          DP:=8;
          Col:=0;
          With Item do begin
               SetFillstyle(1,Col);
               Bar(x1,y1,x2,y2);
               SetColor(8);Line(x1,y1,x2,y1);Line(x1,y1,x1,y2);
               SetColor(15);Line(x1+1,y2,x2,y2);Line(x2,y1,x2,y2);
               if Vidi = true then begin
                    SetColor(0);
                    SettextStyle(10, 0, 4);
                    SettextJustify(0,1);
                    OuttextXY(x1+1,y1-8,Meno);
                    SetColor(15);
                    OuttextXY(x1,y1-9,Meno);
               end;
          end;
          end;

Procedure RiadokNaPisanie.ShowText;
          var col : byte;
          begin
               SetWriteMode(0);
               with Item do begin
                    SetFillstyle(1,0);
                    Bar(x1+2,y1+2,x2-2,y2-2);
                    col := 7;
                    Setcolor(col);
                    SettextStyle(0, 0, 1);
                    SettextJustify(0,1);
                    OuttextXY(x1+7,trunc((y1+y2)/2)+2,Textik);
               end;
          end;

destructor RiadokNaPisanie.Done;
           begin
                Front.DeleteFromFront;
           end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Prepinac                                                                  }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Prepinac.Init(Name:string;x,y:integer;Pocet,Ktory:byte;Vid:boolean;Mess:string);
            begin
                 with Item do begin
                      x1 := x + 1+ActualX;
                      y1 := y + 1+ActualY;
                      Meno := Name;
                      Message := Mess;
                      x2 := x + (Pocet*5) + 2+ActualX;
                      y2 := y + 8+ActualY;
                      Typek := 'q';
                      Aktivita := true;
                end;
                Kolko := Pocet;
                Value := Ktory;
                Front.Init;
            end;

destructor Prepinac.Done;
           begin
                Front.DeleteFromFront;
           end;

procedure Prepinac.Show;
          var px,py:integer;
              prem : integer;
          begin
             with Item do begin
               SetFillStyle(1,0);
               Bar(x1,y1,x1+(Kolko*5)+2,y1+8);
               SetColor(15);
               line(x1+1,y1+7,x1+(Kolko*5)+1,y1+7);
               line(x1+(Kolko*5)+1,y1+2,x1+(Kolko*5)+1,y1+7);
               SetFillstyle(1,8);
               Bar(x1+2,y1+2,x1+(Kolko*5),y1+6);
               SetColor(7);
               px:=x1+6;
               for prem:=1 to Kolko - 1 do begin
                   Line(px,y1+2,px,y1+6);
                   px:=px+5;
               end;
                    SetColor(0);
                    SettextStyle(2, 0, 4);
                    SettextJustify(1,1);
                    OuttextXY(trunc((x1+x2)/2)+1,y1-9,Meno);
                    SetColor(15);
                    OuttextXY(trunc((x1+x2)/2),y1-10,Meno);

               prem :=0;
               for py := (y1-2)  to y1+10 do  begin
                   for px:=(x1+1+(Value*5)) to (x1+6+(Value*5))do
                       begin
                            Pozadie[prem] := GetPixel(px,py);
                            prem:=prem+1;
                       end;
               end;
               PutBitmap(X1+1+(Value*5),Y1-2,5,12,1,@GPrepinac);
            end;
          end;

procedure Prepinac.SetIt(x:integer);
          var Val : integer;
              px,py:integer;
              prem : integer;
          begin
            Val := trunc((x-Item.x1)/5);
            if (Val > Kolko-1) or (Val < 0) then exit;
            if Val <> Value then begin
               HideMouse;
               with Item do begin
                    PutBitmap(X1+1+(Value*5),Y1-2,5,12,1,@Pozadie);
                    Value := Val;
                    prem :=0;
                    for py := (y1-2)  to y1+10 do  begin
                        for px:=(x1+1+(Value*5)) to (x1+6+(Value*5))do
                            begin
                                 Pozadie[prem] := GetPixel(px,py);
                                 prem:=prem+1;
                            end;
                    end;
                    PutBitmap(X1+1+(Value*5),Y1-2,5,12,1,@GPrepinac);
               end;
            end;
            ShowMouse;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Button                                                                    }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Button.Init(Butt:TButton);
          begin
               with Butt do begin
                     Item.Meno := Name;
                     Item.x1 := ActualX+a; Item.y1 := ActualY+b;
                     Item.x2 := Actualx+a+c; Item.y2 := ActualY+b+d;
                     Item.typek := 'b';
                     Item.Message := Mess;
                     Aktivita := Akt;
                     Stav:=false;
               Front.Init;
               end;
          end;

destructor Button.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure Button.Show;
          var FP,FPT,CL,CD:byte; {farba pisma, tmava cast, bleda cast}
          begin
               FP := 15;FPT:=0;
               if Aktivita = false then FP:= 7;
               CL := 15; CD := 8;
               with Item do begin
               if Stav = Stlaceny then begin
                         CL := 8; CD := 7;
                         FP:=15;FPT:=0;
                         end;
                    SetFillStyle(1,Mcolor);
                    bar(x1,y1,x2,y2);
                    SetColor(0);
                    line(x1,y1,x1,y2);line(x1,y1,x2,y1);
                    line(x2,y1,x2,y2);line(x1,y2,x2,y2);
                    SetColor(CL);
                    line(x1+1,y1+1,x1+1,y2-1);line(x1+1,y1+1,x2-1,y1+1);
                    SetColor(CD);
                    line(x1+2,y2-1,x2-1,y2-1);line(x2-1,y1+1,x2-1,y2-1);
                    if Stav = Stlaceny then begin
                         x1:=x1+1;y1:=y1+1;
                    end;
                    SetColor(FPT);
                    SettextStyle(10, 0, 4);
                    SettextJustify(1,1);
                    OuttextXY(trunc((x1+x2)/2)+1,trunc((y1+y2)/2)+1,Meno);
                    SetColor(FP);
                    OuttextXY(trunc((x1+x2)/2),trunc((y1+y2)/2),Meno);
               if Stav = Stlaceny then begin
                         x1:=x1-1;y1:=y1-1;
                         end;

               end;
          end;


{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ BitmapButton                                                              }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor BitmapButton.Init(Butt:TButton;x1,y1,xx,yy:integer;nf:byte;Obrazok:Pobrazok);
          begin
               with Butt do begin
                     Item.Meno := Name;
                     Item.x1 :=  a; Item.y1 :=  b;
                     Item.x2 :=  a+c; Item.y2 :=  b+d;
                     Item.typek := 'B';
                     Item.Message := Mess;
                     Aktivita := Akt;
                     Stav:=false;
               Front.Init;
               end;
               BX:=x1+Item.x1;BY:=y1+Item.y1;
               DX:=xx;DY:=yy;nFF:=nF;
               Bitmapa:=Obrazok;
          end;

destructor BitmapButton.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure BitmapButton.Show;
          var FP,FPT,CL,CD:byte; {farba pisma, tmava cast, bleda cast}
          begin
               FP := 15;FPT:=0;
               if Aktivita = false then FP:= 7;
               CL := 15; CD := 8;
               with Item do begin
               if Stav = Stlaceny then begin
                         CL := 8; CD := 7;
                         FP:=15;FPT:=0;
                         end;
                    SetFillStyle(1,Mcolor);
                    bar(x1,y1,x2,y2);
                    SetColor(0);
                    line(x1,y1,x1,y2);line(x1,y1,x2,y1);
                    line(x2,y1,x2,y2);line(x1,y2,x2,y2);
                    SetColor(CL);
                    line(x1+1,y1+1,x1+1,y2-1);line(x1+1,y1+1,x2-1,y1+1);
                    SetColor(CD);
                    line(x1+2,y2-1,x2-1,y2-1);line(x2-1,y1+1,x2-1,y2-1);
                    if Stav = Stlaceny then begin
                         x1:=x1+1;y1:=y1+1;
                         Bx:=Bx+1;By:=By+1;
                    end;
                    PutBitmap(Bx,By,Dx,Dy,nFF,Bitmapa);
               if Stav = Stlaceny then begin
                         x1:=x1-1;y1:=y1-1;
                         Bx:=Bx-1;By:=By-1;
                         end;

               end;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{Radio button                                                               }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor RadioButton.Init(nejm:string;Buttons: array of TButton;Ktory,Pocet:byte);
          var prem : byte;
              Xnav : integer;
          begin
                    Kolko:=Pocet;
                    Value:=Ktory;
               for prem := 0 to Pocet - 1 do begin
                   New(RadioItem[prem]);
                   RadioItem[prem]^ := Buttons[prem];
               with Buttons[prem] do begin
                     Item.Meno := Name;
                     XNav:=length(Name)*6;
                     Item.x1 := ActualX+a; Item.y1 := ActualY+b;
                     Item.x2 := Actualx+a+c+XNav; Item.y2 := ActualY+b+d;
                     Item.typek := 'r';
                     Item.Message := Mess;
                     Aktivita := Akt;
                     Front.Init;
                    RadioItem[prem]^.a := ActualX+a;
                    RadioItem[prem]^.b := ActualY+b;
                    RadioItem[prem]^.c := ActualX+a+c;
                    RadioItem[prem]^.d := ActualY+b+d;
               end;
               end;
               Item.Meno:=Nejm;
               end;

procedure RadioButton.Show;
          var FP,FPT,CL,CD:byte; {farba pisma, tmava cast, bleda cast}
              Stav : boolean;
              prem : byte;
          begin
             for prem := 0 to Kolko -1  do begin
               with RadioItem[prem]^ do begin
                    FP := 15;FPT:=0;
{                    if Aktivita = false then FP:= 7;}
                    CL := 15; CD := 8;
                    if Value = prem then begin
                         CL := 8; CD := 7;
                         FP:=15;FPT:=0;
                    end;
                    SetFillStyle(1,Mcolor);
                    if Akt = false then SetFillStyle(9,Mcolor);
                    bar(a,b,c-1,d-1);
                    SetColor(0);
                    line(a,b,a,d);line(a,b,c,b);
                    line(c,b,c,d);line(a,d,c,d);
                    SetColor(CL);
                    line(a+1,b+1,a+1,d-1);line(a+1,b+1,c-1,b+1);
                    SetColor(CD);
                    line(a+2,d-1,c-1,d-1);line(c-1,b+1,c-1,d-1);

{ krizik              if (Value=prem) and Akt=true then begin
                       SetColor(1);
                       SetLineStyle(0,0,3);
                       line(a+4,b+4,c-4,d-4);
                       line(c-4,b+4,a+4,d-4);
                       SetLineStyle(0,0,1);
                    end;}

                    if (Value=prem) and Akt=true then begin
                       SetFillStyle(1,3);
                       bar(a+2,b+2,c-2,d-2);
                    end;

                    SetColor(FPT);
                    SettextStyle(10, 0, 4);
                    SettextJustify(0,1);
                    OuttextXY(c+6,b+trunc((d-b)/2)+1,Name);
                    SetColor(FP);
                    OuttextXY(c+5,b+trunc((d-b)/2),Name);
               end;
             end;
          end;

procedure RadioButton.SetIt;
          var CL,CD:byte; {farba pisma, tmava cast, bleda cast}
              Stav : boolean;
              prem : byte;
          label koniec;
          begin
{             if RadioItem[prem]^.Akt=false then goto koniec;}
             for prem := 0 to Kolko  -1 do begin
               with RadioItem[prem]^ do begin
{                    if Aktivita = false then FP:= 7;}
                    CL := 15; CD := 8;
                    if Value = prem then begin
                         CL := 8; CD := 7;
                    end;
                    SetFillStyle(1,Mcolor);
                    if Akt = false then SetFillStyle(9,Mcolor);
                    bar(a,b,c-1,d-1);
                    SetColor(0);
                    line(a,b,a,d);line(a,b,c,b);
                    line(c,b,c,d);line(a,d,c,d);
                    SetColor(CL);
                    line(a+1,b+1,a+1,d-1);line(a+1,b+1,c-1,b+1);
                    SetColor(CD);
                    line(a+2,d-1,c-1,d-1);line(c-1,b+1,c-1,d-1);

                    if (Value=prem) and Akt=true then begin
                       SetFillStyle(1,3);
                       bar(a+2,b+2,c-2,d-2);
                    end;

               end;
             end;
             koniec:
          end;

destructor RadioButton.Done;
          var prem : byte;
          begin
{               Front.Done;}
               for prem:=0 to Kolko - 1 do begin
                   with RadioItem[prem]^ do begin
                        Item.x1 := a; Item.y1 := b;
                        Item.x2 := c; Item.y2 := d;
                        Item.Meno := Name;
                        Item.Typek := 'r';
                        Item.Message := Mess;
                        DeleteFromFront;
                   end;
{                   Dispose(RadioItem[prem]);}
               end;
          end;


procedure RadioButton.WriteMess(xx,yy:integer);
          var prem : byte;
          begin
              for prem := 1 to Kolko do begin
                    with RadioItem[prem]^ do begin
                    if ((xx >  a) and (xx < b)) and
                       ((yy >  c) and (yy < d)) then
                    begin
                         Item.Message := Mess;
                         Dial.WriteMessage(Mess);
                         break;
                    end;
                    end;
              end;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Zapinac                                                                   }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Zapinac.Init(Butt:TButton;Hod:boolean);
          var Xnav:integer;
          begin
               with Butt do begin
                     XNav:=length(Name)*6;
                     Item.Meno := Name;
                     Item.x1 := ActualX+a; Item.y1 := ActualY+b;
                     Item.x2 := Actualx+a+c+XNav; Item.y2 := ActualY+b+d;
                     Item.typek := 'z';
                     Item.Message := Mess;
                     Aktivita := Akt;
                     Stav:=false;
                     Value:=Hod;
               Front.Init;
               end;
          end;

destructor Zapinac.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure Zapinac.Prepni;
          begin
               if Value = Zapnuty then Value:=Vypnuty
               else Value := Zapnuty;
          end;

procedure Zapinac.ShowIT;
          var FP,FPT,CL,CD:byte; {farba pisma, tmava cast, bleda cast}
              XNav:integer;
          begin
               CL := 15; CD := 8;
               with Item do begin
               if Stav = Stlaceny then begin
                         CL := 8; CD := 7;
                         FP:=15;FPT:=0;
                         end;
                    XNav:=length(Meno)*6;
                    SetFillStyle(1,Mcolor);
                    bar(x1,y1,x2-XNav,y2);
                    SetColor(0);
                    line(x1,y1,x1,y2);line(x1,y1,x2-Xnav,y1);
                    line(x2-XNAv,y1,x2-Xnav,y2);line(x1,y2,x2-Xnav,y2);
                    SetColor(CL);
                    line(x1+1,y1+1,x1+1,y2-1);line(x1+1,y1+1,x2-1-XNav,y1+1);
                    SetColor(CD);
                    line(x1+2,y2-1,x2-1-Xnav,y2-1);line(x2-1-Xnav,y1+1,x2-1-Xnav,y2-1);
                    if Stav = Stlaceny then begin
                          x1:=x1+1;y1:=y1+1;
                    end;
                    if Value = Zapnuty then begin
                       PutBitmap(x1+3,y1+3,8,8,1,@Aphex);
{                       SetColor(0);
                       SetLineStyle(0,0,3);
                       line(x1+4,y1+4,x2-4-Xnav,y2-4);
                       line(x2-4-Xnav,y1+4,x1+4,y2-4);
                       SetLineStyle(0,0,1);}

                    end;

               if Stav = Stlaceny then begin
                         x1:=x1-1;y1:=y1-1;
                         end;

          end;
          end;

procedure Zapinac.Show;
          var FP,FPT,CL,CD:byte; {farba pisma, tmava cast, bleda cast}
              XNav : integer;
          begin
               FP := 15;FPT:=0;
               if Aktivita = false then FP:= 7;
               CL := 15; CD := 8;
               with Item do begin
               XNav:=length(Meno)*6;
               if Stav = Stlaceny then begin
                         CL := 8; CD := 7;
                         FP:=15;FPT:=0;
                         end;
                    SetFillStyle(1,Mcolor);
                    bar(x1,y1,x2-XNav,y2);
                    SetColor(0);
                    line(x1,y1,x1,y2);line(x1,y1,x2-XNav,y1);
                    line(x2-XNav,y1,x2-XNav,y2);line(x1,y2,x2-XNav,y2);
                    SetColor(CL);
                    line(x1+1,y1+1,x1+1,y2-1);line(x1+1,y1+1,x2-XNav-1,y1+1);
                    SetColor(CD);
                    line(x1+2,y2-1,x2-XNav-1,y2-1);line(x2-XNav-1,y1+1,x2-XNav-1,y2-1);
                    if Stav = Stlaceny then begin
                          x1:=x1+1;y1:=y1+1;
                    end;
                    if Value = Zapnuty then begin
                       PutBitmap(x1+3,y1+3,8,8,1,@Aphex);
{                       SetColor(0);
                       SetLineStyle(0,0,3);
                       line(x1+4,y1+4,x2-XNav-4,y2-4);
                       line(x2-XNav-4,y1+4,x1+4,y2-4);
                       SetLineStyle(0,0,1);}

                    end;

               if Stav = Stlaceny then begin
                         x1:=x1-1;y1:=y1-1;
                         end;

                    SetColor(FPT);
                    SettextStyle(10, 0, 4);
                    SettextJustify(0,1);
                    OuttextXY(x2-XNav+6,y1+trunc((y2-y1)/2)+1,Meno);
                    SetColor(FP);
                    OuttextXY(x2-XNav+5,y1+trunc((y2-y1)/2),Meno);

               end;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ GrPrepinac                                                                }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor GrPrepinac.Init(Name:string;x,y:integer;St:byte;Mess:string);
          begin
                     Item.Meno := copy(Name,0,Pos('@',Name)-2);
                     Str1:=copy(Name,Pos('@',Name)+2,(Pos('&',Name)-Pos('@',Name)-3));
                     Str2:=(copy(Name,Pos('&',Name)+2,Length(Name)));
                     Item.x1 := ActualX+x; Item.y1 := ActualY+y;
                     Item.x2 := Actualx+x+38; Item.y2 := ActualY+y+12;
                     Item.typek := 'G';
                     Item.Message := Mess;
                     Aktivita := true;
                     Ktory:=st;
                     Front.Init;
               end;

destructor GrPrepinac.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure GrPrepinac.Prepni;
          begin
               if Ktory = 1 then Ktory := 2
               else Ktory := 1;
          end;

procedure GrPrepinac.Show;
          var CL,CD:byte;
          begin
               if Ktory = 1 then begin
                    CL := 0; CD := 15;
               end
               else begin
                    CL := 15; CD := 0;
               end;
               HideMOuse;
               with Item do begin
                    setcolor(CL);
                    Arc(x1+6,y1+6,90,180,6);line(x1+6,y1,x1+19,y1);
                    SetTextStyle(2,0,2);
                    SetTextJustify(1,1);
                    Outtextxy(x1+10,y1+5,Str1);
                    setcolor(CD);
                    SetTextStyle(2,0,2);
                    Outtextxy(x1+30,y1+5,Str2);
                    line(x1+19,y1+1,x1+19,y1+12);line(x1+6,y1+12,x1+19,y1+12);
                    Arc(x1+6,y1+6,195,280,6);
                    line(x1+21,y1,x1+34,y1);Arc(x1+34,y1+6,0,90,6);
                    setcolor(CL);
                    Arc(x1+34,y1+6,280,0,6);line(x1+21,y1+12,x1+34,y1+12);
                    line(x1+21,y1+1,x1+21,y1+12);
                    ShowMouse;
               end;
          end;

procedure GrPrepinac.SetIt(x:integer);
          var Hod:byte;
          begin
             with Item do begin
               if x > x1 + 20 then Hod := 2
               else Hod := 1;
               if Hod <> Ktory then begin
                  Ktory := Hod;
                  Show;
               end;
             end;
          end;

procedure GrPrepinac.ShowMeno;
          begin
               with Item do begin
                    SetTextJustify(1,1);
                    SetTextStyle(2,0,4);
                    SetColor(0);
                    OutTextxy(x1+20,y1-9,Meno);
                    SetColor(15);
                    OutTextxy(x1+19,y1-10,Meno);
               end;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ GrZapinac                                                                 }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor GrZapinac.Init(Name:string;x,y:integer;St:byte;Mess:string);
          var Xnav:integer;
          begin
                     Item.Meno := Name;
                     Item.x1 := ActualX+x+18; Item.y1 := ActualY+y+1;
                     Item.x2 := Actualx+x+35; Item.y2 := ActualY+y+16;
                     Item.typek := 'Z';
                     Item.Message := Mess;
                     Aktivita := true;
                     Stav:=false;
                     Value:=St;
               Front.Init;
               end;

destructor grZapinac.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure GrZapinac.Prepni;
          begin
             with Item do begin
               if Value = 1 then begin
                  Value:=0;
                  PutBitmap(x1-18,y1-1,36,17,1,@Zap_OFF);
               end
               else begin
                    Value := 1;
                    PutBitmap(x1-18,y1-1,36,17,1,@Zap_ON);
                    end;
             end;
          end;

procedure GrZapinac.Show;
          var FP,FPT,CL,CD:byte; {farba pisma, tmava cast, bleda cast}
          begin
               FP := 15;FPT:=0;
               if Aktivita = false then FP:= 7;
               CL := 15; CD := 8;
               with Item do begin
                    if Value = 1 then PutBitmap(x1-18,y1-1,36,17,1,@Zap_ON)
                    else PutBitmap(x1-18,y1-1,36,17,1,@Zap_OFF);;
                    SetColor(FPT);
                    SettextStyle(2, 0, 4);
                    SettextJustify(1,1);
                    OuttextXY(x1,y1-8,Meno);
                    SetColor(FP);
                    OuttextXY(x1-1,y1-9,Meno);

               end;
          end;

procedure GrZapinac.ShowIt;
          var CD,CL:byte;
          begin
                CD:=8;CL:=15;
                if stav = Stlaceny then begin
                   CD := 7;
                   CL := 8;
                end;
                with Item do begin
                    Setcolor(CL);
                    Line(x1+4,y1+6,x1+13,y1+6);
                    Line(x1+4,y1+6,x1+4,y1+9);
                    SetColor(CD);
                    Line(x1+4,y1+10,x1+14,y1+10);
                    Line(x1+14,y1+6,x1+14,y1+10);
               end;
          end;

{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Potenciometer                                                             }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Potenciometer.Init(Name:string;x,y:integer;Mess:string;St:boolean);
          begin
                     Item.Meno := Name;
                     Item.x1 := ActualX+x+10; Item.y1 := ActualY+y+1+10;
                     Item.x2 := Actualx+x+40-10; Item.y2 := ActualY+y+40-10;
                     Item.typek := 'x';
                     Item.Message := Mess;
                     Aktivita := St;
                     Front.Init;
          end;

destructor Potenciometer.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure Potenciometer.NakresliHo(newval:byte);
          begin
            if newVal < 0 then newVal := 0;
            if newVal >  15 then newVal:=15;
            Value:=NewVal;
            with Item do begin
               PutBitmap(x1-10,y1-10,39,39,1, @GPotenciometer);
             Setcolor(2);
{             circle(x1-10+Polohy[poloha,1],y1-10+Polohy[poloha,2],1);
             Putpix1-10el(x1-10+Polohy[poloha,1],y1-10+Polohy[poloha,2],0);}
             SetLineStyle(0, 0, 3);
             Line(x1-10+trunc((20+Polohy[Value,1])/2),y1-10+trunc((18+Polohy[Value,2])/2),
                 x1-10+Polohy[Value,1],y1-10+Polohy[Value,2]);
             SetLineStyle(0, 0, 1);
             Setcolor(1);
             Line(x1-10+trunc((20+Polohy[Value,1])/2),y1-10+trunc((18+Polohy[Value,2])/2),
                 x1-10+Polohy[Value,1],y1-10+Polohy[Value,2]);

                    SetColor(0);
                    SettextStyle(2, 0, 4);
                    SettextJustify(1,1);
                    OuttextXY(x1-10+21,y1-10-6,Meno);
                    SetColor(15);
                    OuttextXY(x1-10+20,y1-10-7,Meno);

            end;
          end;



procedure Potenciometer.SetTo(newVal:integer);
          begin
            if newVal < 0 then newVal := 0;
            if newVal >  15 then newVal:=15;
            if Value <> newVal then begin
            Value := newVal;
            with Item do begin
             PutBitmap(x1-10,y1-10,39,39,1,  @GPotenciometer);
             Setcolor(2);
{             circle(x1-10+Polohy[poloha,1],y1-10+Polohy[poloha,2],1);
             Putpix1-10el(x1-10+Polohy[poloha,1],y1-10+Polohy[poloha,2],0);}
             SetLineStyle(0, 0, 3);
             Line(x1-10+trunc((20+Polohy[Value,1])/2),y1-10+trunc((18+Polohy[Value,2])/2),
                 x1-10+Polohy[Value,1],y1-10+Polohy[Value,2]);
             SetLineStyle(0, 0, 1);
             Setcolor(1);
             Line(x1-10+trunc((20+Polohy[Value,1])/2),y1-10+trunc((18+Polohy[Value,2])/2),
                 x1-10+Polohy[Value,1],y1-10+Polohy[Value,2]);
            end;
           end;
          end;
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}
{ Bezec                                                                      }
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

constructor Bezec.Init(Name:string;x,y:integer;HH,DH,Nas:integer;Mess:string;St:boolean);
            var Naso:byte;
            begin
                 Naso:=Nas;
                 if Nas=0 then Naso:=1;
                 with Item do begin
                      Meno := Name;
                      Message:=Mess;
                      x1:=x-6+ActualX;x2:=x+6+ActualX;
                      y1:=y+ActualY;y2:=y+Naso*abs(HH-DH)+ActualY;
                      Typek:='w';
                      Aktivita:=St;
                      Nasobok:=Nas;
                      DolH:=DH;
                      HorH:=HH;
                      Front.Init;
                 end;
            end;

destructor Bezec.Done;
          begin
               Front.DeleteFromFront;
          end;

procedure Bezec.NakresliHo(newval:integer);
          var xx,yy,prem:integer;
              Nas:byte;
          begin
            if newVal < DolH then newVal := DolH;
            if newVal >  HorH then newVal:= HorH;
            Value:=NewVal;
            Nas:=Nasobok;
            if Nasobok = 0 then Nas := 1;
            with Item do begin
               SetTextStyle(2,0,4);
               SetTextJustify(1,1);
               Setcolor(0);
               OutTextXY(x1+6+1,y1-9,Meno);
               SetColor(15);
               OutTextxy(x1+6,y1-10,Meno);
               Setcolor(0);
               line(x1+6,y1,x1+6,y1+(HorH-DolH)*Nas);
               setcolor(15);
               line(x1+6-2,y1-1,x1+6+2,y1-1);
               line(x1+6-2,y1,x1+6-2,y1+((HorH-DolH)*Nas));
               line(x1+6+2,y1,x1+6+2,y1+((HorH-DolH)*Nas));
               line(x1+6-2,y1+((HorH-DolH)*Nas)+1,x1+6+2,y1+((HorH-DolH)*Nas)+1);
               Setcolor(8);
               yy:=y1;
               for prem:=DolH to HorH do
                   begin
                        if Nasobok=0 then begin
                           if yy mod 2<>0 then begin
                              line(x1+6-6,yy,x1+6-4,yy);
                              line(x1+6+4,yy,x1+6+6,yy);
                           end;
                           end
                        else begin
                              line(x1+6-6,yy,x1+6-4,yy);
                              line(x1+6+4,yy,x1+6+6,yy);
                           end;
                        yy:=yy+Nasobok;
                        if Nasobok=0 then yy:=yy+1;
                   end;
               if Nasobok=0 then Nasobok:=1;
               prem := 0;
               for YY:=y2-(Value*Nasobok)-9 to y2 + 9 - (Value*Nasobok) do begin
                   for XX:=x1 to x1 + 12 do begin
                       ZaNim[prem]:=GetPixel(xx,yy);
                       prem:=prem+1;
                   end;
               end;
               PutBitmap(x1,y2-(Value*Nasobok)-9,12,18,1, @GBezec);
            end;
          end;

procedure Bezec.SetToY(hod:integer);
          var NewVal : integer;
              prem   : integer;
              XX,YY  : integer;
          begin
             if Nasobok=0 then Nasobok:=1;
             with Item do begin
               NewVal := trunc((y2-hod)/Nasobok);
               if newVal < DolH then newVal := DolH;
               if newVal >  HorH then newVal:= HorH;
               if NewVal <> Value then begin
                   PutBitmap(x1,y2-(Value*Nasobok)-9,12,18,1, @ZaNim);
                   Value:=NewVal;
                   prem := 0;
                   for YY:=y2-(Value*Nasobok)-9 to y2 + 9 - (Value*Nasobok) do begin
                       for XX:=x1 to x1 + 12 do begin
                           ZaNim[prem]:=GetPixel(xx,yy);
                           prem:=prem+1;
                       end;
                   end;
                   PutBitmap(x1,y2-(Value*Nasobok)-9,12,18,1, @GBezec);
                  end;
               end;
            end;

procedure Bezec.SetTo(hod:integer);
          var prem   : integer;
              XX,YY  : integer;
          begin
               if Nasobok=0 then Nasobok:=1;
               if Hod < DolH then Hod := DolH;
               if Hod >  HorH then Hod:= HorH;
               if Hod <> Value then begin
                  with Item do begin
                   PutBitmap(x1,y2-(Value*Nasobok)-9,12,18,1, @ZaNim);
                   Value:=Hod;
                   prem := 0;
                   for YY:=y2-(Value*Nasobok)-9 to y2 + 9 - (Value*Nasobok) do begin
                       for XX:=x1 to x1 + 12 do begin
                           ZaNim[prem]:=GetPixel(xx,yy);
                           prem:=prem+1;
                       end;
                   end;
                   PutBitmap(x1,y2-(Value*Nasobok)-9,12,18,1, @GBezec);
                  end;
               end;
            end;



end.