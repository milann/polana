
{---------------------------------------------------------------}
{								}
{	Pascal Mouse						}
{	Mouse Interface for Turbo/Borland Pascal 6.0/7.0	}
{	Version 1.5						}
{       June 17 1997						}
{								}
{	Copyright (c) 1996-1997 Tanescu A. Horatiu		}
{								}
{---------------------------------------------------------------}
{	Source code						}
{---------------------------------------------------------------}

{$G+} (* enable 80286 code generation *)

unit Mouse;


interface


{ Graphic cursor shape record used by SetGraphicCursor }

type
  TGraphicCursor = record
    HotSpotX, HotSpotY : Integer;
    Masks : array [0..1, 0..15] of Word;
  end;

{ Mouse installed flag }

const
  MouseInstalled : Boolean = False;

{ Number of buttons on the mouse }

var
  ButtonCount : Integer;

{ Mouse buttons state variables }

var
  RightButtonPressed  : Boolean;
  LeftButtonPressed   : Boolean;
  CenterButtonPressed : Boolean;

{ Current position of the mouse }

var
  MouseX : Integer;
  MouseY : Integer;

function  InitMouse : Boolean;
procedure ShowMouse;
procedure HideMouse;
procedure ReadMouse;
procedure MouseTo(X, Y : Integer);
function  GetMouseDown(Button : Integer; var LastX, LastY : Integer) : Integer;
function  GetMouseUp(Button : Integer; var LastX, LastY : Integer) : Integer;
procedure SetMouseXRange(MinX, MaxX : Integer);
procedure SetMouseYRange(MinY, MaxY : Integer);
procedure SetMouseRange(MinX, MinY, MaxX, MaxY : Integer);
procedure SetGraphicCursor(NewShape : TGraphicCursor);
procedure SetTextCursor(ScreenMask, CursorMask : Word);
procedure SetHardwareCursor(FirstLn, LastLn : Word);
procedure GetMouseMove(var X, Y : Integer);
procedure SetMouseHandler(Mask : Integer; Handler : Pointer);
procedure SetLightPenEmulation(LightPen : Boolean);
procedure SetMickeyRatio(X, Y : Integer);
procedure HideMouseIn(X1, Y1, X2, Y2 : Integer);
function  DefineGraphicCursor(Width, Height, HotSpotX, HotSpotY : Byte; Masks : Pointer) : Integer;
procedure SetMouseThreshold(Threshold : Integer);
function  ExchangeMouseHandler(Mask : Integer; Handler : Pointer; var OldMask : Integer) : Pointer;
function  DriverStateSize : Integer;
procedure SaveDriverState(Size : Integer; var Buf);
procedure RestoreDriverState(Size : Integer; Buf : Pointer);
function  SetAlternateMouseHandler(Mask : Integer; Handler : Pointer) : Boolean;
function  GetAlternateMouseHandler(Mask : Integer) : Pointer;
procedure SetMouseSensitivity(Horiz, Vert, Threshold : Integer);
procedure GetMouseSensitivity(var Horiz, Vert, Threshold : Integer);
procedure SetMouseInterruptRate(Rate : Integer);
procedure SetMousePage(Page : Integer);
function  GetMousePage : Integer;
function  DisableMouse : Pointer;
function  EnableMouse : Boolean;
function  SoftwareReset : Boolean;
procedure SetMouseLanguage(Language : Integer);
function  GetMouseLanguage : Integer;
function  MouseVersion : Integer;
function  MouseIRQ : Byte;
function  MouseType : Byte;
function  MouseCursor : Byte;
procedure GetMouseMaxRange(var MaxX, MaxY : Integer);
procedure GetTextCursor(var ScreenMask, CursorMask : Word);
procedure GetHardwareCursor(var FirstLn, LastLn : Word);
function  GetMouseState : ShortInt;
function  GetMouseHotSpotX : Integer;
function  GetMouseHotSpotY : Integer;
function  GetMouseMinX : Integer;
function  GetMouseMinY : Integer;
function  GetMouseMaxX : Integer;
function  GetMouseMaxY : Integer;
procedure GetMouseRange(var MinX, MinY, MaxX, MaxY : Integer);
function  TextX(X : Integer) : Integer;
function  TextY(Y : Integer) : Integer;
function  VirtualX(X : Integer) : Integer;
function  VirtualY(Y : Integer) : Integer;


implementation


uses Dos;

var
  ScreenWidth  : Word absolute $0040:$004A;


procedure ButtonsState; assembler;
asm
	MOV	LeftButtonPressed, AL
	MOV	RightButtonPressed, AL
	MOV	CenterButtonPressed, AL
	AND	LeftButtonPressed, 0001H
	AND	RightButtonPressed, 0002H
	AND	CenterButtonPressed, 0004H
end;

function InitMouse : Boolean; assembler;
asm
	XOR	AX, AX
	INT	33H
	MOV	ButtonCount, BX
	MOV	MouseInstalled, AL
end;

procedure ShowMouse; assembler;
asm
	MOV	AX, 0001H
	INT	33H
end;

procedure HideMouse; assembler;
asm
	MOV	AX, 0002H
	INT	33H
end;

procedure ReadMouse; assembler;
asm
	MOV	AX, 0003H
	INT	33H
	MOV	MouseX, CX
	MOV	MouseY, DX
	MOV	AX, BX
	CALL	ButtonsState
end;

procedure MouseTo(X, Y : Integer); assembler;
asm
	MOV	AX, 0004H
	MOV	CX, X
	MOV	DX, Y
	INT	33H
	CALL	ReadMouse
end;

function GetMouseDown(Button : Integer; var LastX, LastY : Integer) : Integer; assembler;
asm
	MOV	AX, 0005H
	MOV	BX, Button
	INT	33H
	CALL	ButtonsState
	LES	DI, LastX
	MOV	AX, CX
	STOSW
	LES	DI, LastY
	MOV	AX, DX
	STOSW
	MOV	AX, BX
end;

function GetMouseUp(Button : Integer; var LastX, LastY : Integer) : Integer; assembler;
asm
	MOV	AX, 0006H
	MOV	BX, Button
	INT	33H
	CALL	ButtonsState
	LES	DI, LastX
	MOV	AX, CX
	STOSW
	LES	DI, LastY
	MOV	AX, DX
	STOSW
	MOV	AX, BX
end;

procedure SetMouseXRange(MinX, MaxX : Integer); assembler;
asm
	MOV	AX, 0007H
	MOV	CX, MinX
	MOV	DX, MaxX
	INT	33H
	CALL	ReadMouse
end;

procedure SetMouseYRange(MinY, MaxY : Integer); assembler;
asm
	MOV	AX, 0008H
	MOV	CX, MinY
	MOV	DX, MaxY
	INT	33H
	CALL	ReadMouse
end;

procedure SetMouseRange(MinX, MinY, MaxX, MaxY : Integer); assembler;
asm
	MOV	AX, 0007H
	MOV	CX, MinX
	MOV	DX, MaxX
	INT	33H
	MOV	AX, 0008H
	MOV	CX, MinY
	MOV	DX, MaxY
	INT	33H
	CALL	ReadMouse
end;

procedure SetGraphicCursor(NewShape : TGraphicCursor); assembler;
asm
	PUSH	DS
	LDS	SI, NewShape
	LODSW
	MOV	BX, AX
	LODSW
	MOV	CX, AX
	POP	DS
	LES	DX, NewShape
	ADD	DX, OFFSET TGraphicCursor.Masks
	MOV	AX, 0009H
	INT	33H
end;

procedure SetTextCursor(ScreenMask, CursorMask : Word); assembler;
asm
	MOV	AX, 000AH
	XOR	BX, BX
	MOV	CX, ScreenMask
	MOV	DX, CursorMask
	INT	33H
end;

procedure SetHardwareCursor(FirstLn, LastLn : Word); assembler;
asm
	MOV	AX, 000AH
	MOV	BX, 0001h
	MOV	CX, FirstLn
	MOV	DX, LastLn
	INT	33H
end;

procedure GetMouseMove(var X, Y : Integer); assembler;
asm
	MOV	AX, 000BH
	INT	33H
	MOV	AX, CX
	LES	DI, X
	STOSW
	MOV	AX, DX
	LES	DI, Y
	STOSW
end;

procedure SetMouseHandler(Mask : Integer; Handler : Pointer); assembler;
asm
	LES	DX, Handler
	MOV	CX, Mask
	MOV	AX, 000CH
	INT	33H
end;

procedure SetLightPenEmulation(LightPen : Boolean); assembler;
asm
	CMP	LightPen, False
	JE	@@1
	MOV	AX, 000DH
	JMP	@@2
@@1:	MOV	AX, 000EH
@@2:	INT	33H
end;

procedure SetMickeyRatio(X, Y : Integer); assembler;
asm
	MOV	AX, 000FH
	MOV	CX, X
	MOV	DX, Y
	INT	33H
end;

procedure HideMouseIn(X1, Y1, X2, Y2 : Integer); assembler;
asm
	MOV	AX, 0010H
	MOV	CX, X1
	MOV	DX, Y1
	MOV	SI, X2
	MOV	DI, Y2
	INT	33H
end;

function DefineGraphicCursor(Width, Height, HotSpotX, HotSpotY : Byte;
                             Masks : Pointer) : Integer; assembler;
asm
	MOV	AX, 0012H
	MOV	BH, Width
	MOV	CH, Height
	MOV	BL, HotSpotX
	MOV	CL, HotSpoty
	LES	DX, Masks
	INT	33H
end;

procedure SetMouseThreshold(Threshold : Integer); assembler;
asm
	MOV	AX, 0013H
	MOV	DX, Threshold
	INT	33H
end;

function ExchangeMouseHandler(Mask : Integer; Handler : Pointer;
                              var OldMask : Integer) : Pointer; assembler;
asm
	LES	DX, Handler
	MOV	CX, Mask
	MOV	AX, 0014H
	INT	33H
	PUSH	ES
	PUSH	DX
	MOV	AX, CX
        LES	DI, OldMask
        STOSW
	POP	AX
	POP	DX
end;

function DriverStateSize : Integer; assembler;
asm
	MOV	AX, 0015H
	INT	33H
	MOV	AX, BX
end;

procedure SaveDriverState(Size : Integer; var Buf); assembler;
asm
	MOV	AX, 0016H
	MOV	BX, Size
	LES	DX, Buf
	INT	33H
end;

procedure RestoreDriverState(Size : Integer; Buf : Pointer); assembler;
asm
	MOV	AX, 0017H
	MOV	BX, Size
	LES	DX, Buf
	INT	33H
end;

function SetAlternateMouseHandler(Mask : Integer; Handler : Pointer) : Boolean; assembler;
asm
	LES	DX, Handler
	MOV	CX, Mask
	MOV	AX, 0018H
	INT	33H
	CMP	AX, 0018H
	JNE	@@1
	MOV	AL, True
        RET
@@1:
	MOV	AL, False
end;

function GetAlternateMouseHandler(Mask : Integer) : Pointer; assembler;
asm
	MOV	CX, Mask
	MOV	AX, 0019H
	INT	33H
	OR	CX, CX
	JE	@@1
        MOV	AX, DX
        MOV     DX, BX
        RET
@@1:
  	XOR	DX, DX
        XOR	AX, AX
end;

procedure SetMouseSensitivity(Horiz, Vert, Threshold : Integer); assembler;
asm
	MOV	AX, 001AH
	MOV	BX, Horiz
	MOV	CX, Vert
	MOV	DX, Threshold
	INT	33H
end;

procedure GetMouseSensitivity(var Horiz, Vert, Threshold : Integer); assembler;
asm
	MOV	AX, 001BH
	INT	33H
	MOV	AX, BX
        LES	DI, Horiz
        STOSW
	MOV	AX, CX
        LES	DI, Vert
        STOSW
	MOV	AX, DX
        LES	DI, Threshold
        STOSW
end;

procedure SetMouseInterruptRate(Rate : Integer); assembler;
asm
	MOV	BX, Rate
	MOV	AX, 001CH
	INT	33H
end;

procedure SetMousePage(Page : Integer); assembler;
asm
	MOV	AX, 001DH
	MOV	BX, Page
	INT	33H
end;

function GetMousePage : Integer; assembler;
asm
	MOV	AX, 001EH
	INT	33H
	MOV	AX, BX
end;

function DisableMouse : Pointer; assembler;
asm
	MOV	AX, 001FH
	INT	33H
	CMP	AX, 001FH
	JE	@@1
        MOV	DX, ES
        MOV	AX, BX
	RET
@@1:
	XOR	DX, DX
        XOR	AX, AX
end;

function EnableMouse : Boolean; assembler;
asm
	MOV	AX, 0020H
	INT	33H
	CMP	AX, 0020H
	JE	@@1
        MOV	AL, True
	RET
@@1:
        MOV	AL, False
end;

function SoftwareReset : Boolean; assembler;
asm
	MOV	AX, 0021H
	INT	33H
	CMP	AX, 0021H
	JE	@@1
	MOV	ButtonCount, BX
	MOV	MouseInstalled, AL
	RET
@@1:
	XOR	AL, AL
	MOV	MouseInstalled, AL
end;

procedure SetMouseLanguage(Language : Integer); assembler;
asm
	MOV	AX, 0022H
	MOV	BX, Language
	INT	33H
end;

function GetMouseLanguage : Integer; assembler;
asm
	MOV	AX, 0023H
	INT	33H
	MOV	AX, BX
end;

function MouseVersion : Integer; assembler;
asm
	MOV	AX, 0024H
	INT	33H
	CMP	AX, 0FFFFH
	JE	@@1
	MOV	AX, BX
@@1:
end;

function MouseIRQ : Byte; assembler;
asm
	MOV	AX, 0024H
	INT	33H
	CMP	AX, 0FFFFH
	JE	@@1
	MOV	AL, CL
@@1:
end;

function MouseType : Byte; assembler;
asm
	MOV	AX, 0024H
	INT	33H
	CMP	AX, 0FFFFH
	JE	@@1
	MOV	AL, CH
@@1:
end;

function MouseCursor : Byte; assembler;
asm
	MOV	AX, 0025H
	INT	33H
	SHL	AH, 2
	SHR	AH, 6
	MOV	AL, AH
end;

procedure GetMouseMaxRange(var MaxX, MaxY : Integer); assembler;
asm
	MOV	AX, 0026H
	INT	33H
	MOV	AX, CX
	LES	DI, MaxX
	STOSW
	MOV	AX, DX
	LES	DI, MaxY
	STOSW
end;

procedure GetTextCursor(var ScreenMask, CursorMask : Word); assembler;
asm
	MOV	AX, 0027H
	INT	33H
	LES	DI, ScreenMask
	STOSW
	MOV	AX, BX
	LES	DI, CursorMask
	STOSW
end;

procedure GetHardwareCursor(var FirstLn, LastLn : Word); assembler;
asm
	MOV	AX, 0027H
	INT	33H
	LES	DI, FirstLn
	STOSW
	MOV	AX, BX
	LES	DI, LastLn
	STOSW
end;

function GetMouseState : ShortInt; assembler;
asm
	MOV	AX, 002AH
	INT	33H
end;

function GetMouseHotSpotX : Integer; assembler;
asm
	MOV	AX, 002AH
	INT	33H
	MOV	AX, BX
end;

function GetMouseHotSpotY : Integer; assembler;
asm
	MOV	AX, 002AH
	INT	33H
	MOV	AX, CX
end;

function GetMouseMinX : Integer; assembler;
asm
	MOV	AX, 0031H
	INT	33H
end;

function GetMouseMinY : Integer; assembler;
asm
	MOV	AX, 0031H
	INT	33H
	MOV	AX, BX
end;

function GetMouseMaxX : Integer; assembler;
asm
	MOV	AX, 0031H
	INT	33H
	MOV	AX, CX
end;

function GetMouseMaxY : Integer; assembler;
asm
	MOV	AX, 0031H
	INT	33H
	MOV	AX, DX
end;

procedure GetMouseRange(var MinX, MinY, MaxX, MaxY : Integer); assembler;
asm
	MOV	AX, 0031H
	INT	33H
	LES	DI, MinX
	STOSW
	MOV	AX, BX
	LES	DI, MinY
	STOSW
	MOV	AX, CX
	LES	DI, MaxX
	STOSW
	MOV	AX, DX
	LES	DI, MaxY
	STOSW
end;

function TextX(X : Integer) : Integer;
begin
  TextX := X div (640 div ScreenWidth) + 1
end;

function TextY(Y : Integer) : Integer;
begin
  TextY := Y div 8 + 1
end;

function VirtualX(X : Integer) : Integer;
begin
  VirtualX := X * (640 div ScreenWidth) + 1
end;

function VirtualY(Y : Integer) : Integer;
begin
  VirtualY := Y * 8 + 1
end;

var
  Int33 : Pointer;

begin

  { Before using INT 33H, the mouse software interrupt, we must verify	}
  { that the INT 33H vector is non-zero. If the vector is zero it is	}
  { dangerous to call any mouse routine through INT 33H. PASCAL MOUSE	}
  { will simply halt your program in this case (but you can easily	}
  { modify this behaviour).						}
  GetIntVec($33, Int33); if Int33 = nil then Halt;

  MouseInstalled := InitMouse
end.