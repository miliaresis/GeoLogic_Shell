unit Central;
interface
uses
  io,Windows, Imageform, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, StdCtrls, ExtCtrls;
type
    TForm4 = class(TForm)
    MainMenu1: TMainMenu; Romania1: TMenuItem; General1: TMenuItem; Exit1: TMenuItem;
    ListBox1: TListBox; OPENALL2: TOpenDialog; LoadFile1: TMenuItem; Writefile1: TMenuItem;
    Label1: TLabel; Label2: TLabel; SAVEfileB1: TMenuItem;
    AAAAA: TButton;
    Display: TLabel; Invert: TButton; Label3: TLabel; Help1: TMenuItem;
    Fileformat1: TMenuItem; about1: TMenuItem; Curvature1: TMenuItem;  Operation1: TMenuItem;
    upslope1: TMenuItem;   GIS1: TMenuItem; IP1: TMenuItem; Border1: TMenuItem; Pixelsthan1: TMenuItem;
    Labelling1: TMenuItem; Eliminationsize1: TMenuItem;
    Constants1: TMenuItem; statisticssize1: TMenuItem;
    Despecle1: TMenuItem;  Displayheader1: TMenuItem;
    Displaytextfile1: TMenuItem; Display1: TMenuItem;
    OpenDialog1: TOpenDialog; Invert02551: TMenuItem;
    Runoffsimulation1: TMenuItem;
    Objects1: TMenuItem;
    Representation1: TMenuItem;
    Linethinning1: TMenuItem;
    SegMatrix1: TMenuItem;
    Regiongrowing1: TMenuItem;
    THRESHOLDS1: TMenuItem;
    Label4: TLabel;
    Button1: TButton;
    Button2: TButton;
    Histogram1: TMenuItem;
    Map: TMenuItem;
    classes1: TMenuItem;
    despecle4416size1: TMenuItem;
    procedure Exit1Click(Sender: TObject);
    procedure LoadFile1Click(Sender: TObject);
    procedure AAAAAClick(Sender: TObject);
    procedure InvertClick(Sender: TObject);
    procedure Fileformat1Click(Sender: TObject);
    procedure about1Click(Sender: TObject);
    procedure Operation1Click(Sender: TObject);
    procedure upslope1Click(Sender: TObject);
    procedure SAVEfileB1Click(Sender: TObject);
    procedure Writefile1Click(Sender: TObject);
    procedure Curvature1Click(Sender: TObject);
    procedure Constants1Click(Sender: TObject);
    procedure Labelling1Click(Sender: TObject);
    procedure statisticssize1Click(Sender: TObject);
    procedure Despecle1Click(Sender: TObject);
    procedure Displayheader1Click(Sender: TObject);
    procedure Border1Click(Sender: TObject);
    procedure Displaytextfile1Click(Sender: TObject);
    procedure Eliminationsize1Click(Sender: TObject);
    procedure Pixelsthan1Click(Sender: TObject);
    procedure Invert02551Click(Sender: TObject);
    procedure Runoffsimulation1Click(Sender: TObject);
    procedure Representation1Click(Sender: TObject);
    procedure Linethinning1Click(Sender: TObject);
    procedure SegMatrix1Click(Sender: TObject);
    procedure Regiongrowing1Click(Sender: TObject);
    procedure THRESHOLDS1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Moments1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Histogram1Click(Sender: TObject);
    procedure classes1Click(Sender: TObject);
    procedure despecle4416size1Click(Sender: TObject);
    
  private { Private declarations }
  public  { Public declarations }
end;
var
  Form4: TForm4;
implementation
{$R *.DFM}
//$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
procedure TForm4.Exit1Click(Sender: TObject);
begin form1.close;showmessage (' > > bye, thanks !');application.terminate;
end;
/////#######################################3
procedure TForm4.LoadFile1Click(Sender: TObject);
Var s:string;slength:integer;
 Procedure Inputfile;
 var strx:string;
 begin
  form1.close; listbox1.items.add('');
  Showmessage('Read IDRISI file A (*.rst, *.rdc)' );
  OPENALL2.filename:='    ';strx:=''; OPENALL2.execute;
  strx:=Openall2.filename; slength:=length(strx);
  Basicfilename:=Copy(strx,1,slength-4);
     s:='Read File: '+extractfilename(strx);listbox1.items.add(s);
     Label1.caption:='File A: '+extractfilename(strx);
     s:='  Dir: '+extractfiledir(strx);listbox1.items.add(s);
  Read_DOC_GMD_FILE (basicfilename,Arows,Acols,Adatatypeid,Aspacing);
  listbox1.items.add('  (Rows,columns)= ( '+inttostr(Arows)+' , '+inttostr(Acols)+' )'+
  format(' , Spacing= %.1f',[Aspacing]));Label2.caption:='File B: ';
 end;
begin
    Inputfile; Initialize;
   If (Arows<=arraysize1) or (Acols<=arraysize2) then begin
      READIMAGEFILE (basicfilename,Amin,Amax);
      listbox1.items.add('  (Min,Max)= ( '+inttostr(Amin)+' , '+inttostr(Amax)+' )');
   end
   else begin
      Showmessage('array size is '+inttostr(Arows)+' * '+inttostr(Acols)+
      ' that is greater than '+inttostr(arraysize1)+' * '+inttostr(arraysize2));
      Arows:=0;Acols:=0;
   end;
end;
///#################################################3
procedure TForm4.AAAAAClick(Sender: TObject);
Var  Mybitmap:Tbitmap;norows,nocols:integer;
     greylevel:integer; bb:elevationarray;
 Procedure RUNRUN; var i,j,xx:integer;
 begin
  form1.close; Mybitmap:=Tbitmap.Create;
  Mybitmap.height:=Norows;Mybitmap.width:=Nocols;
  DISPLAYIMAGEFILE(BB);
  For i:=1 to Norows do begin for j:=1 to Nocols do  begin
    greylevel:= (bb[i,j]); XX:=0;
    if imageinvert2='paint' then begin
     if (AorB='A') or (AorB='a') then if a[i,j]=PAINTID then XX:=1;
     if (AorB='B') or (AorB='b') then if b[i,j]=PAINTID then xx:=1;
    end;
   If imageinvert='invert' then greylevel:= 255 - greylevel;
   If XX<>1 then MyBitMap.canvas.pixels[j,i]:=PaletteRGB (greylevel,greylevel,greylevel)
    else MyBitMap.canvas.pixels[j,i]:=PaletteRGB (240,240,0);
  end;end;
  form1.width:=20+nocols; form1.height:=40+norows;
  form1.Image1.height:=Norows; form1.Image1.width:=Nocols;
  form1.Image1.Picture.Graphic:=mybitmap; form1.show;
 end;
begin
  form1.close; epiloges:=['A','B','a','b'];
  repeat
      GetString('dispay A or B image (A/B):',AorB); Chara:=AorB[1];
   until (Chara in epiloges);
  if (AorB='A') or (AorB='a') then begin
      Norows:=Arows; Nocols:=Acols;form1.caption:=basicfilename;
  end;
  if (AorB='B') or (AorB='b') then begin
      Norows:=Brows; Nocols:=Bcols;form1.caption:=outputfilename;
  end;
  if (Arows=0) and (Acols=0) and  ((AorB='A') or (AorB='a')) then
     Showmessage ('Image array of A is empty ! Load a file please ....')
  else  if (Brows=0) and (Bcols=0) and  ((AorB='b') or (AorB='B')) then
     Showmessage ('Image array of B is empty ! do some processing please please ....')
  else RUNRUN;
  end;
//###################################################
procedure TForm4.InvertClick(Sender: TObject);
begin
  If imageinvert='invert' then  begin imageinvert:='normal';invert.caption:='Normal';end
  else If imageinvert='normal' then begin imageinvert:='invert';invert.caption:='Invert'; end;
  form1.close;
end;
//##################################################
procedure TForm4.Button1Click(Sender: TObject);
begin
 if imageinvert2='none' then begin
 repeat repeat GetInteger('Paint ID',PAINTID) until (PAINTID<=Amax) or (PAINTID<=Bmax);
 until (PAINTID>=Amin) or (PAINTID>=Bmin); button1.caption:='id: '+inttostr(PAINTID);
 imageinvert2:='paint'; end else begin imageinvert2:='none'; button1.caption:='none';end;
end;
//#########################################################
procedure TForm4.Fileformat1Click(Sender: TObject);
begin
   listbox1.items.add('');listbox1.items.add('FILE FORMAT)');
   listbox1.items.add(' 2 files (*.rst, *.rdc)');
   listbox1.items.add('  Standard IDRISI32');
   listbox1.items.add('  Data type: byte or integer');
   listbox1.items.add('  ARRAY LIMIT: '+inttostr(arraysize1)+' * '+inttostr(arraysize2));
end;
//##################################################
procedure TForm4.about1Click(Sender: TObject);
begin
   listbox1.items.add(' ');
   listbox1.items.add('My recipes, Ver. 1.1, Sept. 2006');listbox1.items.add(' ');
   listbox1.items.add('    by George Miliaresis');listbox1.items.add(' ');
   listbox1.items.add('   ....helping students');listbox1.items.add(' ');
   listbox1.items.add('     ....to play with images');
end;
//#####################################################
procedure TForm4.Operation1Click(Sender: TObject);
begin
   listbox1.items.add('');listbox1.items.add('Raster image A is loaded');
   listbox1.items.add('if A->DEM then B is');listbox1.items.add('  Gradient');
   listbox1.items.add('  Aspect (downslope/upslope');
   listbox1.items.add('  Curvature (mean/profile/planar)');
   listbox1.items.add('If A bitmap then B is');
   listbox1.items.add('  Labelling of objects');
   listbox1.items.add('  Size filtering');
end;
///########################################################
procedure TForm4.upslope1Click(Sender: TObject);
var strx,strx2:string;
begin
 If (Arows<>0) and (Acols<>0) then begin
   form1.close; listbox1.items.add(' ');
   epiloges:=['u','U','d','D','g','G'];
   repeat
      GetString('Upslope/Downslope/Gradient (U/D/G):',AorB);Chara:=AorB[1];
   until (Chara in epiloges);
   if (AorB='u') or (AorB='U') then strx:='asp_up' else
   if (AorB='d') or (AorB='D')then strx:='asp_down' else
   if (AorB='g') or (AorB='G')then strx:='Gradient';
   listbox1.items.add('Slope '+strx+' of A');
   Showmessage('compute Slope '+strx+' of FILE A ( '+  Basicfilename+' .rst,.rdc)' );
   Outputfilename:=basicfilename+'_Slope_'+strx;
   Bdatatypeid:=1;Brows:=Arows;Bcols:=Acols;Bspacing:=Aspacing;
   strx2:=timetostr(time);ASPECT_UPSLOPE (AorB);
   listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
   Label2.caption:='File B: the Slope '+strx+' of A';
   listbox1.items.add('  (Min,Max)= ( '+inttostr(Bmin)+' , '+inttostr(Bmax)+' )');
 end else showmessage('Image array of A is empty ! do some processing please....');
end;
//#####################################################3
procedure TForm4.SAVEfileB1Click(Sender: TObject);
var strx:string[15];
begin
   showmessage('Image file B, will be saved to disk.');
   If (Brows<>0) and (Bcols<>0) then begin
    If (Bmax<32769) and (Bmin>-32769) then begin
     form1.close;listbox1.items.add(' ');WRITEIMAGEFILE;
     listbox1.items.add('FILE B was saved to disk');
     listbox1.items.add('   '+extractfilename(outputfilename+'.rdc,'));
     listbox1.items.add('   '+extractfilename(outputfilename+'.rst,'));
     listbox1.items.add('   '+extractfiledir(outputfilename+'.rdc,'));
     if bdatatypeid=1 then strx:='byte';
     if bdatatypeid=2 then strx:='integer';
     listbox1.items.add(format('  Spacing= %.1f',[Bspacing])+' , '+strx);
     listbox1.items.add('  (Rows,columns)= ( '+inttostr(Brows)+' , '+inttostr(Bcols)+' )');
     listbox1.items.add('  (Min,Max)= ( '+inttostr(Bmin)+' , '+inttostr(Bmax)+' )');
   end else showmessage('integer values size out of the 2-bytes integer range: [-32768,32768]'+
   '    ... it can not be saved ! (you might change curvature multiplier factor, or filter object for their CCL-number to be <32769)');
   end else showmessage('Image array of B is empty ! do some processing please....');
end;
//########################################################
procedure TForm4.Writefile1Click(Sender: TObject);
Var AAA:char; strx:string;
begin
   epiloges:=['A','B','a','b'];
   repeat
      GetString('Save file A or B (A/B):',AorB);Chara:=AorB[1];
   until (Chara in epiloges); AAA:=' ';
   if ((Chara='a') or (Chara='A')) then If ((Arows<>0) and (Acols<>0)) then AAA:='A';
   if ((Chara='b') or (Chara='B')) then If ((Brows<>0) and (Bcols<>0)) then AAA:='B';
   If AAA<>' ' then begin
   showmessage ('File '+Chara+' will be saved to tiff format, if pixels are 2'+
      ' bytes in length (integer not byte) then it is rescaled'+
      ' to 1 byte according to the minimum,maximum values');
     SAVE2TIF(AAA);
   if AAA='B' then strx:=extractfilename(Outputfilename+'.tif');
   if AAA='A' then strx:=extractfilename(Basicfilename+'.tif');
   listbox1.items.add(''); listbox1.items.add('WRITE '+AAA+' to TIF');
   listbox1.items.add('  File:'+strx);
   end else showmessage('Image array of '+Chara+' is empty ! do some processing please....');
end;
//###################################################
procedure TForm4.Curvature1Click(Sender: TObject);
var strx,strx2:string; min,max:real; ff,ii:integer;
begin
 If (Arows<>0) and (Acols<>0) then begin
   form1.close; listbox1.items.add(' ');epiloges:=['M','m','F','f','L','l'];
   repeat
      GetString('Mean/Profile/Planar (M/F/L):',AorB);Chara:=AorB[1];
   until (Chara in epiloges);
   if (AorB[1]='M') or (AorB[1]='m') then strx:='Mean';
   if (AorB[1]='F') or (AorB[1]='f') then strx:='Profile';
   if (AorB[1]='L') or (AorB[1]='l') then strx:='Planar';
   Showmessage('compute '+strx+' curvature of FILE A ( '+  Basicfilename+' .rst,.rdc)' );
   listbox1.items.add(strx+' curvature of A');
   strx2:=timetostr(time);
   CURVATUREs_all (AorB, min,max) ;
   listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
   Outputfilename:=basicfilename+'_Curvature_'+strx;
   Label2.caption:='File B: '+strx+' curvature of A';
   listbox1.items.add(format('   Min= %.12f',[min])+format(' , Max= %.12f',[max]));
   ii:=0;ff:=trunc(factor); repeat FF:=trunc(ff/10);ii:=ii+1; until FF=1;
   listbox1.items.add('  (Min,Max)= ( '+inttostr(Bmin)+' , '+inttostr(Bmax)+' )'+' , factor: '+inttostr(ii)+' ('+inttostr(factor)+')');
 end else showmessage('Image array of A is empty ! Load a file please....');
 end;
//###################################################
procedure TForm4.Constants1Click(Sender: TObject);
begin
   listbox1.items.add('');listbox1.items.add('CONSTANTS');
   listbox1.items.add(' -maximum array (dimension): '+inttostr(arraysize1)+' * '+inttostr(arraysize2));
   listbox1.items.add(' -number of Objects (dimension): '+inttostr(Number_of_objects));
   listbox1.items.add(format(' -zero curvature: %.9f',[ZeroCurvature]));
   listbox1.items.add(format(' -Thresholds: '+' Flat=%.1f',[flat])+' , Curvature factor='+inttostr(factor));
   listbox1.items.add(' -aspect: 1=E,2=NE,3=N,4=NW,5=W,6=SW,7=S,8=SE,');
   listbox1.items.add('                  0= aspect undefined (if grad<flat threshold)');
end;
//####################################################
procedure TForm4.Labelling1Click(Sender: TObject);
var count:longint;strx,strx2:string;
begin
   form1.close;showmessage('(A) should be a bitmap, 0->background !');
   epiloges:=['F','f','B','b'];
   repeat
      GetString('Fore/back-ground (F/B):',AorB);Chara:=AorB[1];
   until (Chara in epiloges);
   if (AorB[1]='F') or (AorB[1]='f') then strx:='Foreground (<>0)';
   if (AorB[1]='B') or (AorB[1]='b') then strx:='Background ( 0s )';
   strx2:=TimetoStr(Time);
   Showmessage('Connected Components Labelling ('+strx+') of A ( '+  Basicfilename+' .rst,.rdc)' );
   CONNECTED_COMPONENTs_LABELLING(strx,count);
   if (AorB[1]='F') or (AorB[1]='f') then strx:='fore';
   if (AorB[1]='B') or (AorB[1]='b') then strx:='back';
   listbox1.items.add(''); listbox1.items.add('Connected Components Labelling-'+strx+'ground');
   listbox1.items.add('  No of objects:'+inttostr(count));Outputfilename:=basicfilename+'_CCL'+strx;
   listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
   Label2.caption:='File B: Connected Components of A';
   showmessage('(A) was erased from memory ! while (B) contains'+
   ' the connected components, labelled with an integer value !');
end;
//#####################################################
procedure TForm4.statisticssize1Click(Sender: TObject);
var smean,smin,smax: real; str: string; BB:BBBB;
begin
   form1.close; showmessage('(A) should be an connected components labelled matrix ! '+
   'The size per objects is computed.');
   OBJECT_STATISTICS (str,smean,smin,smax,BB);
   listbox1.items.add('');listbox1.items.add('Size statistics');
   listbox1.items.add(' File:'+extractfilename(str));
   listbox1.items.add('  No of objects: '+inttostr(Amax)+format(' , mean: %.2f',[smean]));
   listbox1.items.add(format('  (min,max): (%.0f',[smin])+format(' , %.0f',[smax])+') , '+
   format('coverage: %.1f',[100*smean*Amax/(Arows*Acols)])+'%');
   Label2.caption:='File written as text: size per object';
end;
//#####################################################
procedure TForm4.Despecle1Click(Sender: TObject);
var Pits_removed:integer;strx:String;
begin
 form1.close;listbox1.items.add(' ');showmessage('(A) should be a bitmap ! ');
 epiloges:=['F','f','B','b'];
   repeat
      GetString('Fore/back-ground (F/B):',AorB);Chara:=AorB[1];
   until (Chara in epiloges);
   if (AorB[1]='F') or (AorB[1]='f') then strx:='Foreground (<>0)';
   if (AorB[1]='B') or (AorB[1]='b') then strx:='Background ( 0s )';
 Showmessage('Erase '+strx+' pits of A ( '+  Basicfilename+' .rst,.rdc)' );
 listbox1.items.add('Erase '+strx+' of A'); DESPECLE (AorB,Pits_removed);
 listbox1.items.add('   Points removed: '+inttostr(Pits_removed));
 if (AorB[1]='F') or (AorB[1]='f') then strx:='_Fore';
 if (AorB[1]='B') or (AorB[1]='b') then strx:='_Back';
 Outputfilename:=basicfilename+strx+'Pits';
 Label2.caption:='File B: Despecle ('+strx+'pits remove) A';
end;
//#######################################################
procedure TForm4.Displayheader1Click(Sender: TObject);
var file2:textfile; s2:string[35]; i:integer;
begin
 If (Arows<>0) and (Acols<>0) then begin
   form1.close;assignfile(file2,Basicfilename+'.rdc');reset (file2);listbox1.items.add('');
   for i:=1 to 24 do begin Readln(file2,s2);listbox1.items.add(s2);end;
   closefile(file2);
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Border1Click(Sender: TObject);
var length:integer;
begin
 If (Arows<>0) and (Acols<>0) then begin
   form1.close;listbox1.items.add(' ');showmessage('Border delineation (0=background) '+
   'If a single object is selected then outputfile file is byte and border pixels are labeled with 255. '+
   'If multiple objects are selected (input is a CCL matrix) then each border that corrsponds to a specific object is labelled with object ID.');
   epiloges:=['m','M','s','S'];
   repeat
      GetString('Multiple/Single object (M/S):',AorB);Chara:=AorB[1];
   until (Chara in epiloges);
   Border(length,Chara); listbox1.items.add('Border delineation ');
   listbox1.items.add('  Length: '+inttostr(length));
   Outputfilename:=basicfilename+'_Border';
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Displaytextfile1Click(Sender: TObject);
var file1:textfile;str:string[75];
begin
  form1.close;OPENDialog1.execute;OPENDialog1.filename;
  assignfile (file1,OPENDialog1.filename);reset(file1);listbox1.items.add('');
 repeat readln(file1,str);listbox1.items.add(str); until eof(file1); closefile(file1);
end;
//#########################################################
procedure TForm4.Eliminationsize1Click(Sender: TObject);
var K,LL,LLLL:integer; strx,strx2:String[20];
begin
   form1.close; If (Arows<>0) and (Acols<>0) then begin
   showmessage('(A) should be an connected components labelled matrix ! '+
   'The objects are erased on the basis of their size. The output is a bitmap (0/255)');
   GetInteger('size threshold:',K); Label2.caption:='File B: Size filtering';
   listbox1.items.add('');listbox1.items.add('Size filtering by the threshold: '+inttostr(K));
   strx2:=timetostr(time);
   SIZE_FILTERING(K,LL,LLLL);
   listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
   If LLLL<>0 then strx:=format(' ( %.1f',[100*LL/LLLL])+' % ) ,';
   listbox1.items.add('  removed :'+inttostr(LL)+strx+' out of '+inttostr(LLLL));
   Outputfilename:=basicfilename+'_Size_'+inttostr(K);
   end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Pixelsthan1Click(Sender: TObject);
var k,points:integer;strx:String;
begin
 form1.close; If (Arows<>0) and (Acols<>0) then begin
 listbox1.items.add(' ');showmessage('Label pixels on the basis of a threshold ! ');
 repeat GetInteger('Threshold:',K); until (k>Amin) and (k<Amax);
 epiloges:=['G','g','L','l','E','e'];
 repeat GetString('GT-EQ-LT (G/E/L):',AorB);Chara:=AorB[1];
 until (Chara in epiloges);
   if (AorB[1]='G') or (AorB[1]='g') then strx:='Greater';
   if (AorB[1]='L') or (AorB[1]='l') then strx:='Less';
   if (AorB[1]='E') or (AorB[1]='e') then strx:='Equal';
 Label2.caption:='File B: label pixels '+strx+' '+inttostr(k);
 listbox1.items.add(' Label pixels '+strx+' than '+inttostr(k));
 LABELPIXELS(k,AorB[1],points);
 listbox1.items.add('    Pixels labelled: '+inttostr(points)+
 format(' , %.2f',[100*points/(Bcols*Brows)])+' %');
 Outputfilename:=basicfilename+'_'+strx+'_'+inttostr(K);
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Invert02551Click(Sender: TObject);
begin
 form1.close; If (Arows<>0) and (Acols<>0) then begin
   listbox1.items.add(' '); showmessage('Invert look up table if A is of byte [0..255] datatype ! ');
   if Adatatypeid=1 then begin
    Label2.caption:='File B: invert lookup table [0,255]->[255,0]';
    listbox1.items.add(' Invert lookup table [0,255]->[255,0]');
    INVERTLUT;
    Outputfilename:=basicfilename+'_invert';
   end else showmessage('(A) is not of byte (datatypeid=1) datatype');
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Runoffsimulation1Click(Sender: TObject);
var iteration:integer;strx2:string;
begin
 form1.close; If (Arows<>0) and (Acols<>0) then begin
  listbox1.items.add(' '); listbox1.items.add('Runoff Simulation (iterative)');
  showmessage(' Runoff Simulation (A should be either a downslope or  an upslope matrix !');
  strx2:=timetostr(time);
  IterativeRUNOFF (Arows,Acols,Iteration);
  listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
  listbox1.items.add('  Iterations: '+inttostr(Iteration));
  listbox1.items.add('  (Min,Max)= ( '+inttostr(Bmin)+' , '+inttostr(Bmax)+' )');
  Outputfilename:=basicfilename+'_runoff';
  Label2.caption:='File B: runoff simulation';
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Representation1Click(Sender: TObject);
var new,new1,new2,strx2:string;
  Procedure READFILE2;
  Var slength:integer;
   Procedure Inputfile;
   var strx:string;
   begin
   Showmessage('Read INTERSECTION FILE (it will replace A)' );
   OPENALL2.filename:='    ';strx:=''; OPENALL2.execute;
   strx:=Openall2.filename; slength:=length(strx);
   Basicfilename:=Copy(strx,1,slength-4);
   Read_DOC_GMD_FILE (basicfilename,Arows,Acols,Adatatypeid,Aspacing);
  end;
  begin
  Inputfile;
   If (Arows=Brows) or (Acols=Bcols) then begin
      READIMAGEFILE (basicfilename,Amin,Amax);
   end
   else begin
      Showmessage('array size is '+inttostr(Arows)+' * '+inttostr(Acols)+
      ' is different than B '+inttostr(Brows)+' * '+inttostr(Bcols));
      Acols:=0;Arows:=0;
   end;
 end;
begin
 form1.close;
 showmessage('(A) a CCL matrix, that will be copied to matrix (B) ! and a new matrix '+
 'wil be loaded (containing the intersection layer) that will be assigned to matrix A');
 If (Arows<>0) and (Acols<>0) then begin
  listbox1.items.add(' ');listbox1.items.add('Intersect objects');
  new:=Basicfilename; listbox1.items.add(' CCL:'+extractfilename(new));
  REPLACEMATRIX;  READFILE2;
  new1:=extractfilename(basicfilename); listbox1.items.add(' Layer:'+extractfilename(new1));
  new2:=new+'_'+new1+'.txt';
  listbox1.items.add(' text:'+extractfilename(new2));
  strx2:=TimetoStr(Time);
  INTERSECT(new,new1,new2);
  listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
  Label2.caption:='File B: intersection of file (CCL) to a layer';
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Linethinning1Click(Sender: TObject);
var count1,count2,iter:integer;strx2:string;
begin
 form1.close;
 If (Arows<>0) and (Acols<>0) then begin
  listbox1.items.add(' '); listbox1.items.add('Line Thinning');
  showmessage('(A) should be a Label matrix depicting line features (eg. drainage network)');
  strx2:=timetostr(time);
  Linethinning (count1, count2,iter);
  listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
  listbox1.items.add(' Iterations: '+inttostr(iter));
  if count1<>0 then listbox1.items.add(' Remain: '+inttostr(count2)+format(' (%.1f',[100*count2/count1])+'%) out of '+inttostr(count1));
  Outputfilename:=basicfilename+'_Thinned'; Label2.caption:='File B: Line Thinning';
 end else showmessage('Load file (A) please ...');
end;
///########################################################
procedure TForm4.SegMatrix1Click(Sender: TObject);
var k:integer;new,new1:string;
 Procedure READFILE2;
  Var slength:integer;
   Procedure Inputfile;
   var strx:string;
   begin
   Showmessage('Read INTERSECTION FILE (it will replace A)' );
   OPENALL2.filename:='    ';strx:=''; OPENALL2.execute;
   strx:=Openall2.filename; slength:=length(strx);
   Basicfilename:=Copy(strx,1,slength-4);
   Read_DOC_GMD_FILE (basicfilename,Arows,Acols,Adatatypeid,Aspacing);
  end;
  begin
  Inputfile;
   If (Arows=Brows) or (Acols=Bcols) then begin
      READIMAGEFILE (basicfilename,Amin,Amax);
   end
   else begin
      Showmessage('array size is '+inttostr(Arows)+' * '+inttostr(Acols)+
      ' is different than B '+inttostr(Brows)+' * '+inttostr(Bcols));
      Acols:=0;Arows:=0;
   end;
 end;
begin
 form1.close;
 If (Arows<>0) and (Acols<>0) then begin
  listbox1.items.add(' '); listbox1.items.add('Segmentation Matrix Composition');
  showmessage('(A) should be the gradient matrix. A new matrix will be loaded '+
  'and the pixels <>0 will be replace the corresponding pixels of the gradient matrix. I=255 if Ridges matrix '
  + 'and I=100 if Valleys! (100-stop segmentation, 255 (seeds) are included in the final dataset)');
  repeat GetInteger('Label (100->valleys, 255->ridges):',K); until (k=100) or (k=255);
  listbox1.items.add(' Label number:'+inttostr(k));
  new:=Basicfilename; listbox1.items.add(' Gradient:'+extractfilename(new+'.rst'));
  REPLACEMATRIX;READFILE2;
  new1:=extractfilename(basicfilename); listbox1.items.add(' Label:'+extractfilename(new1+'.rst'));
  Outputfilename:=new+'_'+new1+'_SGMAT_'+inttostr(k);
  Label2.caption:='File B: composition of segmentation matrix';
  SEGMATRIX(k);
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.Regiongrowing1Click(Sender: TObject);
var k1,k2,total,CountIterations:integer;strx,strx2:String;
begin
 form1.close;
 If (Arows<>0) and (Acols<>0) then begin
  listbox1.items.add(' '); listbox1.items.add('Region Growing');
  showmessage('(A) should be a segmentation matrix derived from gradient (in the range 0 to 90) '+
  'with seeds labelled with 255 and blocks of growing as 0');
  repeat GetInteger('MIN Threshold (0..80): ',K1); until (k1>0) and (k1<80);
  repeat GetInteger('MAX Threshold (0..89): ',K2); until (k2>0) and (k2<90) and (K2>k1);
  listbox1.items.add(' Gradient in the range: ('+inttostr(k1)+' , '+inttostr(k2)+' )');
  Outputfilename:=Basicfilename+'RegGrow_'+inttostr(k1)+'_'+inttostr(k2);
  Label2.caption:='File B: Region Growing';
  strx2:=TimetoStr(Time);
  RECGROW (k1,k2,Total,CountIterations);
  strx:=format(' ,%6.2f',[100*total/(Arows*Acols)])+' %, iterations:'+inttostr(CountIterations);
  listbox1.items.add('  Points segmented: '+inttostr(total)+strx);
  listbox1.items.add('  Started: '+strx2+' , Ended: '+TimetoStr(Time));
 end else showmessage('Load file (A) please ...');
end;
//#########################################################
procedure TForm4.THRESHOLDS1Click(Sender: TObject);
var k1,i:integer;
begin
showmessage('REDEFINE THRESHOLDS :         a) flat terrain [ if gradient < flat terrain then'
 +' gradient=0 and aspect is undefined ],        b) Zero curvature [ minimum threshold for '
 +'the division operator ] ! ');
 repeat GetInteger('Flat terrain (0, 1 or 2): ',k1); until (k1=0) or (k1=1) or (k1=2);
 if k1=0 then flat:=0.5 else flat:=k1;
 repeat GetInteger('Curvature Scaling Factor [1..8]: ',k1); until (k1>0) and (k1<9);
 factor:=1;for i:=1 to k1 do factor:=factor*10;
 listbox1.items.add(' ');listbox1.items.add('THRESHOLDS');
 listbox1.items.add(format('  Flat terrain: %.1f',[flat])+' , Curvature multiplier: '+inttostr(factor));
end;
//#########################################################
procedure TForm4.FormCreate(Sender: TObject);
begin
 p18:=180/3.1415926; ZeroCurvature:= 0.00000001;
 flat:=2.0; {flat terrain threshold}
 factor:=100000; {multiplier of curvature}
 Label2.caption:='File B: '; Label1.caption:='File A: ';
 imageinvert:='normal';
 imageinvert2:='none';
end;
//#########################################################
procedure TForm4.Button2Click(Sender: TObject);
begin
listbox1.clear;
end;
//#########################################################
procedure TForm4.Histogram1Click(Sender: TObject);
var k,Numberofcategories,Limit_down,Limit_up,increment:integer;
    category: bbbb; new:textfile;strx:string;
  Procedure READFILE2;
  Var slength:integer;
   Procedure Inputfile;
   var strx:string;
   begin
   Showmessage('Read LABEL MATRIX(it will replace A)' );
   OPENALL2.filename:='    ';strx:=''; OPENALL2.execute;
   strx:=Openall2.filename; slength:=length(strx);
   Basicfilename:=Copy(strx,1,slength-4);
   Read_DOC_GMD_FILE (basicfilename,Arows,Acols,Adatatypeid,Aspacing);
  end;
  begin
  Inputfile;
   If (Arows=Brows) or (Acols=Bcols) then begin READIMAGEFILE (basicfilename,Amin,Amax);
   end else begin
      Showmessage('array size is '+inttostr(Arows)+' * '+inttostr(Acols)+
      ' is different than B '+inttostr(Brows)+' * '+inttostr(Bcols));
      Acols:=0;Arows:=0;
   end;end;
    procedure write_output;
    var i:integer; 
    begin
     listbox1.items.add(' id,     interval,          frequency');
     writeln(new,' '); writeln(new,'    id,           interval,           frequency');
     for i:=1 to Numberofcategories do begin
      strx:=inttostr(i)+' [ '+inttostr(Limit_down+((i-1)*increment))+
      ' , '+inttostr(Limit_down+(i*increment))+ ' ) '+inttostr(category[i]);
      listbox1.items.add(strx); writeln(new,i:5,' ',(Limit_down+((i-1)*increment)):9,
      ' ',(Limit_down+(i*increment)):9,' ',category[i]:14);
    end;end;
    procedure Input_variables;
    var i:integer;strx:string;
    begin
     Outputfilename:=basicfilename+'_histogram.txt';
     assignfile(new,Outputfilename);rewrite(new);
     showmessage('Histogram calculation of matrix A'); epiloges:=['N','Y','n','y'];
     listbox1.items.add(' '); listbox1.items.add('Histogram calculation of A');
     writeln(new,'Histogram calculation of A'); writeln(new,'file: ',Outputfilename);
     listbox1.items.add('  file: '+extractfilename(Outputfilename));
     listbox1.items.add('  dir : '+extractfiledir(Outputfilename));
     repeat GetString('Label matrix ? (y/n):',AorB);Chara:=AorB[1];
     until (Chara in epiloges);
     repeat GetInteger(' lower limit ['+inttostr(Amin)+','+inttostr(Amax)+')? : ',Limit_down);
     until ((Limit_down>=Amin) and (Limit_down<Amax));
     repeat GetInteger(' upper limit ('+inttostr(Limit_down)+','+inttostr(Amax)+']? : ',Limit_up);
     until ((Limit_up>Limit_down) and (Limit_down<=Amax));
     repeat GetInteger(' Increment <'+inttostr(Limit_up-Limit_down)+' ? ',increment);
     until (Limit_up-Limit_down>increment);
     Numberofcategories:=trunc((Limit_up-Limit_down)/increment)+1;
     strx:=' Actual range: ['+inttostr(Amin)+','+inttostr(Amax)+']';
     listbox1.items.add(strx);writeln(new,strx);
     strx:=' Selected range: ['+inttostr(Limit_down)+','+inttostr(Limit_up)+']';
     listbox1.items.add(strx);writeln(new,strx);
     strx:=' Increment: '+inttostr(increment);
     listbox1.items.add(strx);writeln(new,strx);
     strx:=' Categories: '+inttostr(Numberofcategories);
     listbox1.items.add(strx);writeln(new,strx);
     Label2.caption:='File B: Histogram calculation, saved as textfile';
     for i:=1 to Numberofcategories do category[i]:=0;
    end;
    Procedure DENSITIES;
    var i,j:integer;
    begin
     for i:=1 to arows do begin for j:=1 to acols do begin
      if ((a[i,j]>=Limit_down) and (a[i,j]<=Limit_up)) then begin
       k:=trunc((a[i,j]-Limit_down)/increment);
       category[k+1]:=category[k+1]+1;
     end;end;end;
    end;
    Procedure DENSITIES2;
    var i,j:integer;
    begin
     for i:=1 to Brows do begin for j:=1 to Bcols do begin if a[i,j]<>0 then begin
      if ((B[i,j]>=Limit_down) and (B[i,j]<=Limit_up)) then begin
       k:=trunc((B[i,j]-Limit_down)/increment); category[k+1]:=category[k+1]+1;
     end;end;end;end;
    end;
begin
 form1.close;
 If (Arows<>0) and (Acols<>0) then begin
  Input_Variables;
  If ((Chara='n') or (Chara='N')) then DENSITIES;
  If ((Chara='y') or (Chara='Y')) then begin
    REPLACEMATRIX; READFILE2;
    strx:='  Label file: '+extractfilename(basicfilename+'.rdc');
    listbox1.items.add(strx);writeln(new,strx);
    DENSITIES2;
  end;
  Write_Output;
 end else showmessage('Load file (A) please ...');
 closefile(new);
end;
//########################################################
procedure TForm4.Moments1Click(Sender: TObject);
var i,p,q,k:integer; BB:BBBBreal;
begin
 form1.close;
//// TEST
i:=1;
repeat
 GetInteger(' ? : ',i);
 p:=lo(i); q:=hi(i); k:=p+(q*256);
// if k>32768 then i:=65536-
 listbox1.items.add('  '+inttostr(i)+' : '+inttostr(p)+' + ( '+inttostr(q)+' * 256 )= '+inttostr(k));
////TEST
 until i=0;
 If (Arows<>0) and (Acols<>0) then begin
  listbox1.items.add(' '); listbox1.items.add('Moments Calculation');
  showmessage('(A) should be a CCL matrix for MOMENTSs Calculation');
  p:=0;q:=0;
  MOMENTS(p, q,BB);
  for I:=1 to Amax do listbox1.items.add(' '+inttostr(i)+format(' %.1f',[BB[i]]));
  Label2.caption:='File B: Moments';
 end else showmessage('Load file (A) please ...');
end;
/////@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
procedure TForm4.classes1Click(Sender: TObject);
var arows,Kintervals:integer;inputfile,inputdir:string;
    a: array [1..Number_of_objects ] of real;
    k: array [1..12 ] of integer;
    mmin,mmax:real;
   Procedure READArray;
   var s:string;workingfile:textfile;i:integer;
   begin
      listbox1.items.add('RECLASS to intervals ---------- ');
      showmessage('The datafile should be single column, tab delimitated'+
      ' the number of rows should be known ');
       openDialog1.execute;    {read filename from dialog menu}
       inputfile:=extractfilename(openDialog1.filename);
       inputdir:=extractfiledir(openDialog1.filename);
       s:='File : '+inputfile; listbox1.items.add( '      '+s);
       s:='Dir  : '+inputdir; listbox1.items.add( '      '+s);
       assignfile(workingfile,inputfile);
       reset(workingfile); arows:=0;
       repeat GetInteger('number of objects: ',arows); until (arows>0);
       s:=' objects: '+inttostr(arows);listbox1.items.add(s);
          for i:=1 to arows do begin
             read(workingfile,a[i]);
             if i=1 then begin mmin:=a[i];mmax:=a[i];end;
             if a[i]<mmin then mmin:=a[i];
             if a[i]>mmax then mmax:=a[i];
          end;
       s:=format('   min: %.2f',[mmin]);listbox1.items.add(s);
       s:=format('   max: %.2f',[mmax]);listbox1.items.add(s);
       closefile(workingfile);
      end;
   Procedure READINTERVALS;
   var s:string;i:integer;
   begin
      showmessage (format('min: %.2f',[mmin])+format('   max: %.2f',[mmax]));
      Kintervals:=0;repeat GetInteger('number of intervals: ',Kintervals); until (Kintervals<11);
      s:='   intervals: '+inttostr(Kintervals);listbox1.items.add(s);
      k[1]:=trunc(mmin);
      for i:=1 to Kintervals do begin
         s:=inttostr(i)+': [ '+inttostr(k[i])+' , ';
         repeat GetInteger(s+'__ ) ',K[i+1]); until (K[i+1]>k[i]) ;
         if (i=Kintervals) and (k[Kintervals+1]<mmax) then k[Kintervals+1]:=trunc(mmax)+1;
         s:=s+inttostr(k[i+1])+' )';listbox1.items.add(s);
      end;
   end;
    Procedure Remap;
    var i,j:integer;workingfile:textfile;
        count_int: array [1..12 ] of real;sum:real;
    begin
       for i:=1 to Kintervals do count_int[i]:=0;
       for i:=1 to arows do begin
       for j:=1 to Kintervals do begin
         if (a[i]>=k[j]) and (a[i]<k[j+1]) then begin
            a[i]:=j;count_int[j]:=count_int[j]+1;
         end;
       end;
       end;
       assignfile(workingfile,inputfile+'.new');
       rewrite(workingfile);
       for i:=1 to arows do writeln(workingfile,trunc(a[i]));
       closefile(workingfile);
       sum:=0; for i:=1 to Kintervals do sum:=sum+count_int[i];
       listbox1.items.add(' --> total: '+format(' %.0f',[sum]));
       for i:=1 to Kintervals do listbox1.items.add(inttostr(i)+' : '+format(' %.0f',[count_int[i]]));
   end;
begin
    READArray;
    READINTERVALS;
    REMAP;
end;
//##############################################################################
procedure TForm4.despecle4416size1Click(Sender: TObject);
var Pits_removed,SIZEOFKERNEL:integer;strx,strx33:String;
begin
 form1.close;listbox1.items.add(' ');showmessage('(A) should be a bitmap ! ');
 epiloges:=['F','f' {, 'B','b'}];
   repeat
      GetString('Fore/back-ground (F/ only F works not B):',AorB);Chara:=AorB[1];
   until (Chara in epiloges);
   if (AorB[1]='F') or (AorB[1]='f') then strx:='Foreground (<>0)';
   if (AorB[1]='B') or (AorB[1]='b') then strx:='Background ( 0s )';
 Showmessage('Erase '+strx+' pits of A ( '+  Basicfilename+' .rst,.rdc)' );
 repeat GetInteger('size n ((2*n)-1):',SIZEOFKERNEL); until (SIZEOFKERNEL>1) and (SIZEOFKERNEL<10);
 listbox1.items.add('Erase '+strx+' of A, of size '+
 inttostr( ((2*SIZEOFKERNEL)-1)* ((2*SIZEOFKERNEL)-1) ));
 DESPECLE16 (AorB,SIZEOFKERNEL,Pits_removed);
 listbox1.items.add('   Points removed: '+inttostr(Pits_removed));
 if (AorB[1]='F') or (AorB[1]='f') then strx:='_Fore';
 if (AorB[1]='B') or (AorB[1]='b') then strx:='_Back';
 strx33:=inttostr( ((2*SIZEOFKERNEL)-1)*((2*SIZEOFKERNEL)-1) );
 Outputfilename:=basicfilename+strx+'Pits_of_size_'+strx33;
 Label2.caption:='File B: Despecle ('+strx+'pits 16 pixels size remove) A';
end;
//#######################################################

end.
