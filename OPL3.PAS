unit OPL3;

interface

uses Trans;

const Frekvencie : array[1..24] of real =(
                 16.352,17.324,18.354,19.445,20.601,21.826,23.124,24.499,25.956,
                 27.500,29.135,30.867,32.703,34.648,36.708,38.890,41.203,43.653,
                 46.249,48.999,51.913,55.000,58.270,61.735);

const MenaNot  : array[1..24] of string =(
             'c','c#','d','d#','e','f','f#','g','g#','a',
             'a#','h','c1','c#1','d1','d#1','e1','f1','f#1',
             'g1','g#1','a1','a#1','h1');

type Operator = record
              Tremolo  : byte; {0 = OFF, 1 = ON}
              Vibrato  : byte; {0 = OFF, 1 = ON}
              Sus      : byte; {0 = OFF, 1 = ON}
              KSR      : byte; {0 = OFF, 1 = ON}
              FMul     : byte;
              KSL      : byte;
              Level    : byte;
              Attack   : byte;
              Decay    : byte;
              Sustain  : byte;
              Release  : byte;
              WaveForm : byte;
              end;

     Pair = record
            Opers    : array[1..2] of Operator;
            FeedFact : byte;
            RL       : byte; {0 = Center, 1 = Right, 2 = Left}
     end;

     Polana2Inst = record
                 Name      : string[16];
                 NumOp     : byte; {pocet operatorov == 2}
                 NoteSel   : byte; {0 = OFF, 1 = ON}
                 TremDepth : byte; {0 = 1, 1 = 4.8}
                 VibDepth  : byte; {0 = 7, 1 = 14}
                 FeedType  : byte;
                 PercMode  : byte; {0 = OFF, 1 = ON}
                 PercChan  : byte;
{                 PercInst  : byte; {0 = BD, 1 = SD, 2 = TT, 3 = CY, 4 = HH}
                 Ops       : Pair;
      end;

     Polana4Inst = record
                 Name      : string[16];
                 NumOp     : byte; {pocet operatorov == 4}
                 NoteSel   : byte; {0 = OFF, 1 = ON}
                 TremDepth : byte; {0 = 1, 1 = 4.8}
                 VibDepth  : byte; {0 = 7, 1 = 14}
                 FeedType  : byte;
                 PercMode  : byte; {0 = OFF, 1 = ON}
                 PercChan  : byte;
                 Ops       : array[1..2] of Pair;
     end;

     PiHeader = record
              ID      : string[3];  {'Pi '}
              Res1    : byte;
              Res2    : byte;
              InstNum : word; {pocet instrumentov}
     end;


type Chan_4_Op = array[1..4] of word; {offsety operatorov v 4-op kanali}
     Chan_2_Op = array[1..2] of word; {offsety operatorov v 2-op kanali}
     Perku_Op = word;                 {offset pre perkusie [okrem DB]}

     Kanal  =  record
                     Meno  : string[15];
                     ID    : byte;   {1=2op, 2=4op}
                     kanal : byte;   {cislo kanalu}
               end;

     {--------------------------+-------------------------}
     {   <1.sada>               |   <2.sada>              }
     {--------------------------+-------------------------}
     {   3 x 4-op kanaly        |    3 x 4-op kanaly      }
     {        alebo             |           +             }
     {   6 x 2-op kanaly        |    3 x 2-op kanaly      }
     {           +              |                         }
     {    1 x 2-op kanal  \_    |         alebo           }
     {    4 x 1-op kanaly / |   |                         }
     {            perkusie _|   |     9 x 2-op kanaly     }
     {        alebo             |                         }
     {    3 x 2-op kanaly       |                         }
     {--------------------------+-------------------------}

{ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ                              OPERATORY & KANALY                         บ}
{ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

{offsety vsetkych 36 operatorov}
const Operatory : array[1..36] of word =(
         $00,$01,$02,$03,$04,$05,$08,$09,$0A,$0B,$0C,$0D,$10,$11,$12,$13,$14,
         $15,$100,$101,$102,$103,$104,$105,$108,$109,$10A,$10B,$10C,$10D,$110,
         $111,$112,$113,$114,$115);

{6 x 4-op kanal}
{operatory moznych 4-op kanalov}
     CH4OP : array[1..6,1..4] of byte =(
                          (1, 4, 7, 10),(2, 5, 8, 11),
                          (3, 6, 9, 12),(19,22,25,28),
                          (20,23,26,29),(21,24,27,30));

{18 x 2-op kanal (+ 3 x 2-op kanal bez perkusii)}
{operatory moznych 2-op kanalov}
      CH2OP : array[1..18,1..2] of byte =(
                           (31,34),(32,35),(33,36),(1,4),(7,10),
                           (2,5),(8,11),(3,6),(9,12),(19,22),
                           (25,28),(20,23),(26,29),(21,24),(27,30),
                           (13,16),(14,17),(15,18));

{5 x perkusie}
      Bass     : Chan_2_Op = (13,16);
      Snare    : Perku_Op  =  17;
      Tom      : Perku_Op  =  15;
      Cymbal   : Perku_Op  =  18;
      Hi_Hat   : Perku_Op  =  14;

const SynthModes : array[1..9,1..4] of byte =(
                   (1,0,0,0),(0,0,0,0),(0,0,0,0),(1,0,0,0),(0,1,0,0),
                   (1,1,0,0),(0,0,0,0),(0,0,0,0),(0,0,0,0));
{อออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออ}

function OPLdetect:byte;     {vracia kod > 0=nic, 1=OPL2, 2=OPL3}
function GetSBport : word;   {vrati port SB kompatibilnej karty}
procedure InitOPL;           {inicializuje premenne}
function Get2ChFree: byte;   {vrati pocet volnych 2-op kanalov}
function Get4ChFree: byte;   {vrati pocet volnych 4-op kanalov}
function Act2opChanell(Name:string):boolean; {aktivuje 2-op kanal}
function Act4opChanell(Name:string):boolean; {aktivuje 4-op kanal}
function Deact2opChanell(Name:string):boolean; {deaktivuje 2-op kanal}
function Deact4opChanell(Name:string):boolean; {deaktivuje 4-op kanal}
function GetFreq(Meno:string):real;
procedure Set4Sound(CHname:string; Instr : Polana4Inst); {vlozi do kanala zvuk}
procedure Play4Sound(CHname:string;Freq:real;octave:byte);
procedure Stop4Sound(CHname:string);
procedure Set2Sound(CHname:string; Instr : Polana2Inst); {vlozi do kanala zvuk}
procedure Play2Sound(CHname:string;Freq:real;octave:byte);
procedure Stop2Sound(CHname:string);


implementation

var FMport  : word; {port zvukovaj karty}
    OpJeFree: array[1..36] of boolean; {je operator volny ?}
    Active2Ch : byte;     {aktivnych 2-op kanalov}
    Active4Ch : byte;     {aktivnych 4-op kanalov}
    PerkActiv : boolean;  {su perkusie aktivne ?}
    O2Kanal   : array[1..18] of Kanal; {2-op kanaly}
    O4Kanal   : array[1..6] of Kanal;  {4-op kanaly}
    delay1    : integer; {pauza po zapise registru}
    delay2    : integer; {pauza po zapise dat}
    OPL3ex    : boolean; {OPL3 ext.}
    OP4BYTE   : byte;    {aktivita 4-op kanalov v reg 4 2.sady}

function GetFreq(Meno:string):real;
         var prem : byte;
         begin
              for prem := 1 to  24 do
                  if Meno = MenaNot[prem] then GetFreq:=Frekvencie[prem];
         end;


{zapis dat do jedneho z registrov FM-karty}
procedure FMwriteReg(reg : word; data : byte);assembler;
    label out1,loop1,loop2;
    asm
        mov     dx,FMport
        mov     ax,reg
        or      ah,ah          { horny byte nenulovy - druha sada}
        jz      out1
        inc     dx
        inc     dx
     out1:
        out     dx,al
        mov     cx,delay1
     loop1:                      { delay between writes}
        in      al,dx
        loop    loop1

        inc     dx
        mov     al,data
        out     dx,al
        dec     dx
        mov     cx,delay2

     loop2:                       { delay after data write}
        in      al,dx
        loop    loop2
     end;

function OPLdetect:byte;
         var s1,s2,prem : byte;
             pokus : byte;
         label este_raz;
         begin
            pokus := 1;
            delay1:=12;delay2:=32;
            FMport := GetSBport;
            if FMport = 0 then begin
               writeln('SB card not found.');
               halt;
            end;
{            writeln;}
{            writeln('SB karta na adrese : ',DectoHex(FMPort),'H');}
           este_raz:
            OPLdetect := 0;
            FMwriteReg(4, $60);
            FMwriteReg(4, $80);
            s1 := Port[FMport];
            FMwriteReg(2, $ff);
            FMwriteReg(4, $21);
              for prem := 0 to 130 do
                  s2 := port[FMPort];
            s2 := Port[FMport];
            FMwriteReg(4, $60);
            FMwriteReg(4, $80);
            if (s1 = 0) and (s2 = $c0) then { ak OPL2 = true , pokracuj}
               begin
                    OPLdetect := 1;
                    s1 := port[FMport];
                    if s1 and 6 = 0 then OPLdetect := 2;
               end
            else if (OPLdetect = 0) and (pokus = 1) then
                 begin
                      pokus := pokus + 1;
                      FMport := $388;
                      goto este_raz;
                 end;
         end;

function GetSBport : word; {Vrati port SB kompatibilnej karty}
           var BPORT, XPORT : word;
               WPORT, RPORT : word;
               APORT, READY : word;
               loopctr, bytik : byte;
               label dalej;
           begin
                BPORT := $210; XPORT := $216;
                WPORT := $21C; RPORT := $21A;
                APORT := $21E;
             repeat;
                    Port[XPORT] := 1;
                    for loopctr:=1 to 180 do;
                    Port[XPORT] := 0;
                    loopctr := 0;
                    repeat
                          bytik := Port[RPORT];
                          loopctr := loopctr + 1;
                          if bytik = $aa then goto dalej;
                    until loopctr > 100;
                    if bytik <> $aa then
                    begin
                         BPORT := BPORT + $10; XPORT := XPORT + $10;
                         WPORT := WPORT + $10; RPORT := RPORT + $10;
                         APORT := APORT + $10;
                    end;
                    if bytik = $aa then goto dalej;
             until RPORT = $270;
             dalej:
             if BPORT = $270 then GetSBport := 0
             else GetSBport := BPORT;
           end;

procedure InitOPL;          {inicializuje premenne}
          var oper : byte;
              prem:integer;
          begin
               if OPLdetect = 2 then {OPL3}
                  begin
               delay1 := 2; delay2 := 12;
               for prem := 1 to $f5 do
                   FMWriteReg(prem, 0);
               for prem := 100 to $1f5 do
                   FMWriteReg(prem, 0);
                       FMwriteReg($105, 1); {OPL3 ext.}
                       OPL3ex:=true;
                       for oper := 1 to 36 do OpJeFree[oper]:=true;
                  end
               else if OPLdetect = 1 then  {OPL2}
                    begin
               for prem := 1 to $f5 do
                   FMWriteReg(prem, 0);
                       OPL3ex:=false;
                       delay1 := 6; delay2 := 36;
                       for oper := 1 to 18 do OpJeFree[oper]:=true;
                    end
               else begin
                         write('Error: OPL3 chip not found!');
                         halt;
                    end;
               Active2Ch := 0;
               Active4Ch := 0;
               PerkActiv := false;
               OP4BYTE   := $ff;
               FMwriteReg($104, OP4BYTE);
          end;


{ษอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออป}
{บ                        AKTIVACIA & DEAKTIVACIA KANALOV                  บ}
{ศอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผ}

function IsFree2(kanal:byte):boolean; {zisti ci je dany 2-op kanal volny}
          var oper,prem : byte;
              volnych_op   : byte;
          begin
               IsFree2 := false;
               volnych_op  :=  0;
               for prem:=1 to 2 do
                   if OpJeFree[CH2OP[kanal,prem]] then
                      volnych_op := volnych_op + 1;
                   if volnych_op = 2 then IsFree2 := true;
          end;


function IsFree4(kanal:byte):boolean; {zisti ci je dany 4-op kanal volny}
          var oper,prem : byte;
              volnych_op   : byte;
          begin
               IsFree4 := false;
               volnych_op  :=  0;
               for prem:=1 to 4 do
                   if OpJeFree[CH4OP[kanal,prem]] then
                      volnych_op := volnych_op + 1;
                   if volnych_op = 4 then IsFree4 := true;
          end;

function Get4ChFree: byte;   {vrati pocet volnych 4-op kanalov}
         var volnych   : byte;
             kanal     : byte;
         begin
              volnych := 0;
              for kanal := 1 to 6 do
                  if IsFree4(kanal) then volnych := volnych + 1;
              Get4ChFree := volnych;
         end;

function Get2ChFree: byte;   {vrati pocet volnych 2-op kanalov}
         var volnych   : byte;
             kanal     : byte;
         begin
              volnych := 0;
              for kanal := 1 to 18 do
                  if IsFree2(kanal) then volnych := volnych + 1;
              Get2ChFree := volnych;
         end;

procedure MakeItFree2(kanal:byte); {uvolni 2-op kanal}
          begin
               OpJeFree[CH2OP[kanal,1]] := true;
               OpJeFree[CH2OP[kanal,2]] := true;
          end;

procedure MakeItNotFree2(kanal:byte); {vytvori 2-op kanal}
          begin
               OpJeFree[CH2OP[kanal,1]] := false;
               OpJeFree[CH2OP[kanal,2]] := false;
          end;

procedure MakeItFree4(kanal:byte); {uvolni 4-op kanal}
          begin
               OpJeFree[CH4OP[kanal,1]] := true;
               OpJeFree[CH4OP[kanal,2]] := true;
               OpJeFree[CH4OP[kanal,3]] := true;
               OpJeFree[CH4OP[kanal,4]] := true;
          end;

procedure MakeItNotFree4(kanal:byte); {vytvori 4-op kanal}
          begin
               OpJeFree[CH4OP[kanal,1]] := false;
               OpJeFree[CH4OP[kanal,2]] := false;
               OpJeFree[CH4OP[kanal,3]] := false;
               OpJeFree[CH4OP[kanal,4]] := false;
          end;

function Act2opChanell(Name:string):boolean; {aktivuje 2-op kanal}
          var kan : byte;
              ISfree    : byte;
              volnych   : byte;
          begin
               Act2opChanell:=false;
               for kan:=1 to 18 do
                   if IsFree2(kan) then
                      begin
                           Act2opChanell := true;
                           MakeItNotFree2(kan);
                           Active2Ch := Active2Ch + 1;
                           with O2Kanal[Active2Ch] do
                           begin
                                Meno :=  Name;
                                ID   :=  1;
                                kanal := kan;
                           end;
                           break;
                      end;
          end;

function Deact2opChanell(Name:string):boolean; {deaktivuje 2-op kanal}
         var k : byte;
         label koniec;
         begin
              Deact2opChanell := true;
              k:=0;
              repeat
                    k:=k+1;
                    if k > Active2Ch then
                       begin
                            Deact2opChanell := false;
                            goto koniec;
                       end;
              until O2Kanal[k].Meno = Name;
{              if k = Active2Ch then
                 begin}
                      Active2Ch := Active2Ch - 1;
                      MakeitFree2(k);
{                      goto koniec;
                 end
              else begin
                        repeat
                              O2Kanal[k] := O2Kanal[k+1];
                              k:=k+1;
                        until k = Active2Ch;
                        Active2Ch := Active2Ch - 1;
                   end;                            }
         koniec:
         end;




function Act4opChanell(Name:string):boolean; {aktivuje 4-op kanal}
          var kan : byte;
              ISfree    : byte;
              volnych   : byte;
              bytik,k   : byte;
          begin
               Act4opChanell:=false;
               for kan:=1 to 6 do
                   if IsFree4(kan) then
                      begin
                           Act4opChanell := true;
                           MakeItNotFree4(kan);     {obsad ho}
                           Active4Ch := Active4Ch + 1;
                           bytik := 1;
{                           for k := 1 to kan do
                               bytik :=bytik + 2*(kan-1);
                           OP4BYTE := OP4BYTE or bytik;
                           FMwriteReg($104, OP4Byte);  }
                           with O4Kanal[Active4Ch] do
                           begin
                                Meno :=  Name;
                                ID   := 2;
                                kanal := kan;
                           end;
                           break;
                      end;
          end;


 function Deact4opChanell(Name:string):boolean; {deaktivuje 4-op kanal}
         var k, bytik, prem : byte;
         label koniec;
         begin
              Deact4opChanell := true;
              k:=0;
              repeat
                    k:=k+1;
                    if k > Active4Ch then
                       begin
                            Deact4opChanell := false;
                            goto koniec;
                       end;
              until O4Kanal[k].Meno = Name;
{              if k = Active4Ch then
                 begin              }
                      Active4Ch := Active4Ch - 1;
                           bytik := 1;
                           for prem := 1 to k do
                               bytik := bytik * 2;
                           OP4BYTE := OP4BYTE xor bytik;
                           FMwriteReg($104, OP4BYTE);
                           MakeItFree4(k);
{
                        goto koniec;
                 end
              else begin
                           bytik := 1;
                           for prem := 1 to k do
                               bytik := bytik * 2;
                           OP4BYTE := OP4BYTE xor bytik;
                           FMwriteReg($104, OP4BYTE);
                        repeat
                              O4Kanal[k] := O4Kanal[k+1];
                              k:=k+1;
                        until k = Active4Ch;
                        Active2Ch := Active2Ch - 1;
                   end;}
         koniec:
         end;

procedure Set4Sound(CHname:string; Instr : Polana4Inst); {vlozi do kanala zvuk}
          var prem : byte;
              kanal : byte;
              OPof : Chan_4_Op;
              Cur  : byte;
              BinCis : string;
              TD, VD : byte;

          begin
               for prem := 1 to Active4Ch do
                   if O4Kanal[prem].Meno = Chname then
                      kanal := O4Kanal[prem].kanal;
                      OPof[1] := Operatory[CH4OP[kanal,1]];
                      OPof[2] := Operatory[CH4OP[kanal,2]];
                      OPof[3] := Operatory[CH4OP[kanal,3]];
                      OPof[4] := Operatory[CH4OP[kanal,4]];
                      with Instr do begin
                           {8h}
                           case NoteSel of
                                1 : FMWriteReg(($8+OPof[1]), 64);
                                0 : FMWriteReg(($8+OPof[1]), 0);
                           end;
                           {BDh}
                           if TremDepth = 1 then TD := 128
                              else TD := 0;
                           if VibDepth =  1 then VD := 64
                              else VD := 0;
                           Cur:=TD + VD;
                           BinCis:= DectoBin(Cur);
                           FMWriteReg(($BD + OPof[1]), TD + VD);
{Ops1}

                           with Ops[1] do begin
                                {C0h}
                                case RL of
                                     0 : Cur:= 48;
                                     1 : Cur:= 32;
                                     2 : Cur:= 16;
                                end;
                                Cur := Cur + (FeedFact * 2) + SynthModes[FeedType,1];
                                FMWriteReg(($C0 + OPof[1]), Cur);
{O1}                            with Opers[1] do begin
                                     {20h}
                                     Cur:=0;
                                     if Tremolo = 1 then Cur := 128;
                                     if Vibrato = 1 then Cur := Cur + 64;
                                     if Sustain = 1 then Cur := Cur + 32;
                                     if KSR     = 1 then Cur := Cur + 16;
                                     Cur := Cur + FMul;
                                     FMWriteReg(($20 + OPof[1]), Cur);
                                     {40h}
                                     FMWriteReg($40 + OPof[1], KSL * 64 + Level);
                                     {60h}
                                     FMWriteReg($60 + OPof[1], Attack * 16 + Decay );
                                     {80h}
                                     FMWriteReg($80 + OPof[1], Sustain * 16 + Release );
                                     {E0h}
                                     FMWriteReg($E0 + OPof[1], WaveForm);
                                end;
{O2}                            with Opers[2] do begin
                                     {C4h}
                                     FMWriteReg(($C4 + OPof[2]), SynthModes[FeedType,2]);
                                     {20h}
                                     Cur:=0;
                                     if Tremolo = 1 then Cur := 128;
                                     if Vibrato = 1 then Cur := Cur + 64;
                                     if Sustain = 1 then Cur := Cur + 32;
                                     if KSR     = 1 then Cur := Cur + 16;
                                     Cur := Cur + FMul;
                                     FMWriteReg(($20 + OPof[2]), Cur);
                                     {40h}
                                     FMWriteReg($40 + OPof[2], KSL * 64 + Level);
                                     {60h}
                                     FMWriteReg($60 + OPof[2], Attack * 16 + Decay );
                                     {80h}
                                     FMWriteReg($80 + OPof[2], Sustain * 16 + Release );
                                     {E0h}
                                     FMWriteReg($E0 + OPof[2], WaveForm);
                                end;
                           end;
{Ops2}

                           with Ops[2] do begin
                                {C0h}
                                case RL of
                                     0 : Cur:= 48;
                                     1 : Cur:= 32;
                                     2 : Cur:= 16;
                                end;
                                Cur := Cur + (FeedFact * 2) + SynthModes[FeedType,3];
                                FMWriteReg(($C0 + OPof[3]), Cur);
{O1}                            with Opers[1] do begin
                                     {20h}
                                     Cur:=0;
                                     if Tremolo = 1 then Cur := 128;
                                     if Vibrato = 1 then Cur := Cur + 64;
                                     if Sustain = 1 then Cur := Cur + 32;
                                     if KSR     = 1 then Cur := Cur + 16;
                                     Cur := Cur + FMul;
                                     FMWriteReg(($20 + OPof[3]), Cur);
                                     {40h}
                                     FMWriteReg($40 + OPof[3], KSL * 64 + Level);
                                     {60h}
                                     FMWriteReg($60 + OPof[3], Attack * 16 + Decay );
                                     {80h}
                                     FMWriteReg($80 + OPof[3], Sustain * 16 + Release );
                                     {E0h}
                                     FMWriteReg($E0 + OPof[3], WaveForm);
                                end;
{O2}                            with Opers[2] do begin
                                     {C4h}
                                     FMWriteReg(($C4 + OPof[4]), SynthModes[FeedType,4]);
                                     {20h}
                                     Cur:=0;
                                     if Tremolo = 1 then Cur := 128;
                                     if Vibrato = 1 then Cur := Cur + 64;
                                     if Sustain = 1 then Cur := Cur + 32;
                                     if KSR     = 1 then Cur := Cur + 16;
                                     Cur := Cur + FMul;
                                     FMWriteReg(($20 + OPof[4]), Cur);
                                     {40h}
                                     FMWriteReg($40 + OPof[4], KSL * 64 + Level);
                                     {60h}
                                     FMWriteReg($60 + OPof[4], Attack * 16 + Decay );
                                     {80h}
                                     FMWriteReg($80 + OPof[4], Sustain * 16 + Release );
                                     {E0h}
                                     FMWriteReg($E0 + OPof[4], WaveForm);
                                end;
                           end;
                      end;
               end;

procedure Play4Sound(CHname:string;Freq:real;octave:byte);
          var F_NUM : longint;
              FN    : byte;
              FN2H  : byte;
              prem,kanal : byte;
              OPof : Chan_4_Op;
          begin
               FN2H := 0;
               F_NUM := trunc(Freq * 1.31);
               FN := lo(F_NUM);
               FN2H := hi(F_NUM);
               for prem := 1 to Active4Ch do
                   if O4Kanal[prem].Meno = Chname then
                      kanal := O4Kanal[prem].kanal;
                   OPof[1] := Operatory[CH4OP[kanal,1]];
                   OPof[2] := Operatory[CH4OP[kanal,2]];
                   OPof[3] := Operatory[CH4OP[kanal,3]];
                   OPof[4] := Operatory[CH4OP[kanal,4]];
               FMWriteReg($A0 + OpOf[1], FN);
               FMWriteReg($B0 + OpOf[1], 32 + FN2H);
          end;

procedure Stop4Sound(CHname:string);
          var prem,kanal : byte;
              OPof : Chan_4_Op;
          begin
               for prem := 1 to Active4Ch do
                   if O4Kanal[prem].Meno = Chname then
                      kanal := O4Kanal[prem].kanal;
                   OPof[1] := Operatory[CH4OP[kanal,1]];
                   OPof[2] := Operatory[CH4OP[kanal,2]];
                   OPof[3] := Operatory[CH4OP[kanal,3]];
                   OPof[4] := Operatory[CH4OP[kanal,4]];
               FMWriteReg($B0 + OpOf[1], 0);

          end;

procedure Set2Sound(CHname:string; Instr : Polana2Inst); {vlozi do kanala zvuk}
          var prem : byte;
              kanal : byte;
              OPof : Chan_2_Op;
              Cur  : byte;
              BinCis : string;
              TD, VD : byte;

          begin
               for prem := 1 to Active2Ch do
                   if O2Kanal[prem].Meno = Chname then
                      kanal := O2Kanal[prem].kanal;
                      OPof[1] := Operatory[CH2OP[kanal,1]];
                      OPof[2] := Operatory[CH2OP[kanal,2]];
                      with Instr do begin
                           {8h}
                           case NoteSel of
                                1 : FMWriteReg(($8+OPof[1]), 64);
                                0 : FMWriteReg(($8+OPof[1]), 0);
                           end;
                           {BDh}
                           if TremDepth = 1 then TD := 128
                              else TD := 0;
                           if VibDepth =  1 then VD := 64
                              else VD := 0;
                           Cur:=TD + VD;
                           BinCis:= DectoBin(Cur);
                           FMWriteReg(($BD + OPof[1]), TD + VD);
{Ops}                      with Ops do begin
                                case RL of
                                     0 : Cur:= 48;
                                     1 : Cur:= 32;
                                     2 : Cur:= 16;
                                end;
                                Cur := Cur + (FeedFact * 2) + SynthModes[FeedType,1];
                                FMWriteReg(($C0 + OPof[1]), Cur);
{O1}                            with Opers[1] do begin
                                     {20h}
                                     Cur:=0;
                                     if Tremolo = 1 then Cur := 128;
                                     if Vibrato = 1 then Cur := Cur + 64;
                                     if Sustain = 1 then Cur := Cur + 32;
                                     if KSR     = 1 then Cur := Cur + 16;
                                     Cur := Cur + FMul;
                                     FMWriteReg(($20 + OPof[1]), Cur);
                                     {40h}
                                     FMWriteReg($40 + OPof[1], KSL * 64 + Level);
                                     {60h}
                                     FMWriteReg($60 + OPof[1], Attack * 16 + Decay );
                                     {80h}
                                     FMWriteReg($80 + OPof[1], Sustain * 16 + Release );
                                     {E0h}
                                     FMWriteReg($E0 + OPof[1], WaveForm);
                                end;
{O2}                            with Opers[2] do begin
                                     {C4h}
                                     FMWriteReg(($C4 + OPof[2]), SynthModes[FeedType,2]);
                                     {20h}
                                     Cur:=0;
                                     if Tremolo = 1 then Cur := 128;
                                     if Vibrato = 1 then Cur := Cur + 64;
                                     if Sustain = 1 then Cur := Cur + 32;
                                     if KSR     = 1 then Cur := Cur + 16;
                                     Cur := Cur + FMul;
                                     FMWriteReg(($20 + OPof[2]), Cur);
                                     {40h}
                                     FMWriteReg($40 + OPof[2], KSL * 64 + Level);
                                     {60h}
                                     FMWriteReg($60 + OPof[2], Attack * 16 + Decay );
                                     {80h}
                                     FMWriteReg($80 + OPof[2], Sustain * 16 + Release );
                                     {E0h}
                                     FMWriteReg($E0 + OPof[2], WaveForm);
                                end;
                           end;
                      end;
               end;

procedure Play2Sound(CHname:string;Freq:real;octave:byte);
          var F_NUM : longint;
              FN    : byte;
              FN2H  : byte;
              prem,kanal : byte;
              OPof : Chan_2_Op;
          begin
               Freq:=Freq*(octave+1);
               FN2H := 0;
               F_NUM := trunc(Freq * 1.31);
               FN := lo(F_NUM);
               FN2H := hi(F_NUM);
               for prem := 1 to Active2Ch do
                   if O2Kanal[prem].Meno = Chname then
                      kanal := O2Kanal[prem].kanal;
                   OPof[1] := Operatory[CH2OP[kanal,1]];
                   OPof[2] := Operatory[CH2OP[kanal,2]];
               FMWriteReg($A0 + OpOf[1], FN);
               FMWriteReg($B0 + OpOf[1], 32 + FN2H);
          end;

procedure Stop2Sound(CHname:string);
          var prem,kanal : byte;
              OPof : Chan_2_Op;
          begin
               for prem := 1 to Active2Ch do
                   if O2Kanal[prem].Meno = Chname then
                      kanal := O2Kanal[prem].kanal;
                   OPof[1] := Operatory[CH2OP[kanal,1]];
                   OPof[2] := Operatory[CH2OP[kanal,2]];
               FMWriteReg($B0 + OpOf[1], 0);
          end;

end.

