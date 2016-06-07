unit Pii;

interface
uses OPL3;

type Kanal = object;

            MenoKanalu : string;
            ZOp : Polana2Inst;
            Error : integer;
            FileName : string;
            Frekvencia : real;
            Oktava     : byte;
            Aktualny   : boolean;
            procedure Aktivuj;
            procedure SetSound;
            procedure Save2Inst;
            procedure Load2Inst;
            procedure ZrusKanal;
            procedure PlayIt;
            procedure StopIt;
            end;

    Kanal2OP = object
            MenoKanalu : string;
            ZOp : Polana2Inst;
            Error : integer;
            FileName : string;
            Frekvencia : real;
            Oktava     : byte;
            Aktualny   : boolean;
            procedure Aktivuj;
            procedure SetSound;
            procedure Save2Inst;
            procedure Load2Inst;
            procedure ZrusKanal;
            procedure PlayIt;
            procedure StopIt;
            end;

type Kanal4OP = object
            MenoKanalu : string;
            ZOp : Polana4Inst;
            Error : integer;
            FileName : string;
            Frekvencia : real;
            Oktava     : byte;
            Aktualny   : boolean;
            procedure Aktivuj;
            procedure SetSound;
            procedure Save4Inst;
            procedure Load4Inst;
            procedure ZrusKanal;
            procedure PlayIt;
            procedure StopIt;
            end;

var K2 : array[1..6] of Kanal2OP;
    K4 : array[1..6] of Kanal4OP;

procedure Hybaj(fn:string;Name:string);

implementation

procedure Kanal4OP.Aktivuj;
          begin
             Act4opChanell(MenoKanalu);
          end;

procedure Kanal2OP.Aktivuj;
          begin
             Act2opChanell(Menokanalu);
          end;

procedure Kanal4OP.PlayIt;
          begin
              Play4Sound(Menokanalu,Frekvencia,Oktava);
          end;

procedure Kanal2OP.PlayIt;
          begin
              Play2Sound(Menokanalu,Frekvencia,Oktava);
          end;

procedure Kanal2OP.StopIt;
          begin
              Stop2Sound(Menokanalu);
          end;

procedure Kanal4OP.StopIt;
          begin
              Stop4Sound(Menokanalu);
          end;

procedure Kanal4OP.ZrusKanal;
          begin
               Deact4OpChanell(MenoKanalu);
          end;

procedure Kanal2OP.ZrusKanal;
          begin
               Deact2OpChanell(MenoKanalu);
          end;

procedure Kanal4OP.Save4Inst;
         var f   : file;
             Hed : PiHeader;
             M : word;
             P1: pointer;
         begin
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
              Blockwrite(f,ZOp,76,M);
              close(f);
         end;

procedure Kanal2OP.Save2Inst;
         var f   : file;
             Hed : PiHeader;
             M   : word;
             P1  : pointer;
         begin
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
              Blockwrite(f,ZOp,50,M);
              close(f);
         end;

procedure Kanal4OP.Load4Inst;
         var f   : file;
             Hed : array[1..6] of byte;
         label koniec;
         begin
             assign(f, filename);reset(f,1);
                   Blockread(f,Hed,6);
                   if char(Hed[1])+char(Hed[2])+char(Hed[3]) <> 'Pi ' then
                      begin
                           Error:=1;
                           goto koniec;
                      end;
             blockread(f,ZOp,76);
              koniec:
              close(f);
         end;

procedure Kanal2OP.Load2Inst;
         var f   : file;
             Hed : array[1..6] of byte;
         label koniec;
         begin
             assign(f, filename);reset(f,1);
                   Blockread(f,Hed,6);
                   if char(Hed[1])+char(Hed[2])+char(Hed[3]) <> 'Pi ' then
                      begin
                           Error:=1;
                           goto koniec;
                      end;
             blockread(f,ZOp,50);
             koniec:
             close(f);
         end;

procedure Kanal2OP.SetSound;
          begin
               Set2Sound(Menokanalu, Zop);
          end;

procedure Kanal4OP.SetSound;
          begin
               Set4Sound(Menokanalu, Zop);
          end;

procedure Hybaj(fn:string;Name:string);
          begin
               K4[1].filename:=fn;
               K4[1].menokanalu := Name;
               K4[1].frekvencia:=440;
               K4[1].Aktivuj;
               K4[1].Load4Inst;
               K4[1].SetSound;
               K4[1].Playit;
               readln;
               K4[1].StopIt;
               K4[1].ZrusKanal;
          end;

end.