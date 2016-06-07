unit Pii;

interface
uses OPL3;

const DefaultInstr : Polana4Inst = (
              Name : '';
              NumOp : 0;
              NoteSel : 0;
              TremDepth : 0;
              VibDepth  : 0;
              FeedType  : 2;
              PercMode  : 0;
              PercChan  : 0;

              Ops: ((Opers:
              ((Tremolo : 0;
              Vibrato  : 0;
              Sus      : 0;
              KSR      : 0;
              FMul     : 0;
              KSL      : 0;
              Level    : 0;
              Attack   : 0;
              Decay    : 0;
              Sustain  : 0;
              Release  : 0;
              WaveForm : 0),
              (Tremolo  : 0;
              Vibrato  : 0;
              Sus      : 0;
              KSR      : 0;
              FMul     : 0;
              KSL      : 0;
              Level    : 0;
              Attack   : 0;
              Decay    : 0;
              Sustain  : 0;
              Release  : 0;
              WaveForm : 0));
            FeedFact : 0;
            RL       : 0),
            (Opers:
              ((Tremolo  : 0;
              Vibrato  : 0;
              Sus      : 0;
              KSR      : 0;
              FMul     : 0;
              KSL      : 0;
              Level    : 0;
              Attack   : 0;
              Decay    : 0;
              Sustain  : 0;
              Release  : 0;
              WaveForm : 0),
              (Tremolo  : 0;
              Vibrato  : 0;
              Sus      : 0;
              KSR      : 0;
              FMul     : 0;
              KSL      : 0;
              Level    : 0;
              Attack   : 0;
              Decay    : 0;
              Sustain  : 0;
              Release  : 0;
              WaveForm : 0));
            FeedFact : 0;
            RL       : 0)));


type Kanal = object
            MenoKanalu : string;
            ZOp        : Polana4Inst;
            Hrajuci    : boolean;
            Frekvencia : real;
            Oktava     : byte;
            procedure Aktivuj;
            procedure Init(MK:string;Inst:Polana4Inst);
            procedure SetSound;
            procedure ZrusKanal;
            procedure SetOct(oct:byte);
            procedure SetFreq(fr:real);
            procedure PlayIt;
            procedure StopIt;
            end;

procedure InitChanells;
procedure ZrusChanells;
function Save4Inst(filename:string):byte;
function Load4Inst(filename:string):byte;

var Kanals : array [1..6] of Kanal;
    AktualKanal:byte;
{          Error : integer;}
{          FileName : string;}
{            procedure Save4Inst;
            procedure Load4Inst;}

{procedure Hybaj(fn:string;Name:string);}

implementation

procedure Kanal.Init(MK:string;Inst:Polana4Inst);
          begin
               MenoKanalu:=MK;
               ZOp:=Inst;
               Hrajuci := false;
               Aktivuj;
          end;

procedure Kanal.Aktivuj;
          begin
             if not Act4opChanell(MenoKanalu) then halt;
          end;

procedure Kanal.SetFreq(fr:real);
          begin
               frekvencia := fr;
          end;

procedure Kanal.SetOct(oct:byte);
          begin
               Oktava:=oct;
          end;

procedure Kanal.PlayIt;
          begin
              Play4Sound(Menokanalu,Frekvencia,Oktava);
              Hrajuci:=true;
          end;

procedure Kanal.StopIt;
          begin
              Stop4Sound(Menokanalu);
              Hrajuci:=false;
          end;

procedure Kanal.ZrusKanal;
          begin
               Hrajuci:=false;
               StopIt;
               if not Deact4OpChanell(MenoKanalu) then ;
          end;

function Save4Inst(filename:string):byte;
         var f   : file;
             Hed : PiHeader;
             M : word;
             P1: pointer;
         begin
              Save4Inst := 0;
              with Hed do begin
                   ID := 'Pi ';
                   Res1 := 0;
                   Res2 := 0;
                   InstNum := 1;
              end;
              P1:=Ptr(Seg(Hed),Ofs(Hed)+1);
              assign(f, filename);rewrite(f,1);
              with Hed do begin
                   Blockwrite(f,P1^,3);
                   Blockwrite(f,Res1,1);
                   Blockwrite(f,Res2,1);
                   Blockwrite(f,InstNum,1);
              end;
              Blockwrite(f,Kanals[AktualKanal].Zop,76,M);
              close(f);
         end;

function Load4Inst(filename:string):byte;
         var f   : file;
             Hed : array[1..6] of byte;
         label koniec;
         begin
             Load4Inst:=0;
             assign(f, filename);reset(f,1);
                   Blockread(f,Hed,6);
                   if char(Hed[1])+char(Hed[2])+char(Hed[3]) <> 'Pi ' then
                      begin
                           Load4Inst:=1;
                           goto koniec;
                      end;
             blockread(f,Kanals[AktualKanal].ZOp,76);
              koniec:
              close(f);
         end;

procedure Kanal.SetSound;
          begin
               Set4Sound(Menokanalu, Zop);
          end;

procedure InitChanells;
          var Meno : string;
              prem : byte;
          begin
               for prem := 1 to 6 do begin
                   str(prem,Meno);
                   Kanals[prem].Init(Meno, DefaultInstr);
                   AktualKanal:=1;
               end;
          end;

procedure ZrusChanells;
          var prem : byte;
          begin
               for prem := 1 to 6 do begin
                   Kanals[prem].StopIt;
                   Kanals[prem].ZrusKanal;
               end;
          end;

{procedure Hybaj(fn:string;Name:string);
          begin
               ZV.filename:=fn;
               ZV.menokanalu := Name;
               ZV.frekvencia:=440;
               ZV.Aktivuj;
               ZV.Load4Inst;
               ZV.SetSound;
               ZV.Playit;
               readln;
               ZV.StopIt;
               ZV.ZrusKanal;
          end;}

end.