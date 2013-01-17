VERSION 5.00
Begin VB.Form frm 
   BorderStyle     =   1  'Fixed Single
   Caption         =   "Simple rcomage GUI"
   ClientHeight    =   5130
   ClientLeft      =   45
   ClientTop       =   330
   ClientWidth     =   6390
   Icon            =   "frm.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   ScaleHeight     =   5130
   ScaleWidth      =   6390
   StartUpPosition =   2  'CenterScreen
   Begin VB.PictureBox picComp 
      BorderStyle     =   0  'None
      Height          =   3795
      Left            =   420
      OLEDropMode     =   1  'Manual
      ScaleHeight     =   3795
      ScaleWidth      =   5535
      TabIndex        =   20
      Top             =   900
      Visible         =   0   'False
      Width           =   5535
      Begin VB.PictureBox picCompPackRes 
         BorderStyle     =   0  'None
         Height          =   255
         Left            =   1620
         ScaleHeight     =   255
         ScaleWidth      =   3495
         TabIndex        =   34
         Top             =   1920
         Width           =   3495
         Begin VB.OptionButton optCompPackResNone 
            Caption         =   "None"
            Enabled         =   0   'False
            Height          =   255
            Left            =   0
            TabIndex        =   35
            Top             =   0
            Width           =   1095
         End
         Begin VB.OptionButton optCompPackResZlib 
            Caption         =   "Zlib"
            Enabled         =   0   'False
            Height          =   255
            Left            =   1140
            TabIndex        =   36
            Top             =   0
            Value           =   -1  'True
            Width           =   1095
         End
         Begin VB.OptionButton optCompPackResRlz 
            Caption         =   "RLZ"
            Enabled         =   0   'False
            Height          =   255
            Left            =   2280
            TabIndex        =   37
            Top             =   0
            Width           =   1095
         End
      End
      Begin VB.CheckBox chkCompPackRes 
         Caption         =   "Overwrite compression defined in XML"
         Height          =   255
         Left            =   0
         TabIndex        =   32
         Top             =   1560
         Width           =   5475
      End
      Begin VB.CommandButton cmdComp 
         Caption         =   "Compile"
         Height          =   435
         Left            =   2040
         TabIndex        =   38
         Top             =   3360
         Width           =   1515
      End
      Begin VB.PictureBox picCompPackHdr 
         BorderStyle     =   0  'None
         Height          =   255
         Left            =   1620
         ScaleHeight     =   255
         ScaleWidth      =   3495
         TabIndex        =   28
         Top             =   1140
         Width           =   3495
         Begin VB.OptionButton optCompPackHdrRlz 
            Caption         =   "RLZ"
            Enabled         =   0   'False
            Height          =   255
            Left            =   2280
            TabIndex        =   31
            Top             =   0
            Width           =   1095
         End
         Begin VB.OptionButton optCompPackHdrZlib 
            Caption         =   "Zlib"
            Height          =   255
            Left            =   1140
            TabIndex        =   30
            Top             =   0
            Width           =   1095
         End
         Begin VB.OptionButton optCompPackHdrNone 
            Caption         =   "None"
            Height          =   255
            Left            =   0
            TabIndex        =   29
            Top             =   0
            Value           =   -1  'True
            Width           =   1095
         End
      End
      Begin VB.TextBox txtCompXML 
         Height          =   285
         Left            =   960
         OLEDropMode     =   1  'Manual
         TabIndex        =   22
         Top             =   0
         Width           =   3435
      End
      Begin VB.CommandButton cmdCompXMLBrowse 
         Caption         =   "Browse..."
         Height          =   315
         Left            =   4440
         OLEDropMode     =   1  'Manual
         TabIndex        =   23
         Top             =   0
         Width           =   1035
      End
      Begin VB.TextBox txtCompRCO 
         Height          =   285
         Left            =   960
         TabIndex        =   25
         Top             =   660
         Width           =   3435
      End
      Begin VB.CommandButton cmdCompRCOBrowse 
         Caption         =   "Browse..."
         Height          =   315
         Left            =   4440
         TabIndex        =   26
         Top             =   660
         Width           =   1035
      End
      Begin VB.Label lblCompPackRes 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "BMP/GIM/GMO:"
         Enabled         =   0   'False
         Height          =   195
         Left            =   0
         TabIndex        =   33
         Top             =   1920
         Width           =   1215
      End
      Begin VB.Label lblCompPackHdr 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Header &Compression:"
         Height          =   195
         Left            =   0
         TabIndex        =   27
         Top             =   1140
         Width           =   1515
      End
      Begin VB.Label lblCompXML 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "&XML Input:"
         Height          =   195
         Left            =   0
         OLEDropMode     =   1  'Manual
         TabIndex        =   21
         Top             =   0
         Width           =   780
      End
      Begin VB.Label lblCompRCO 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "&RCO Output:"
         Height          =   195
         Left            =   0
         TabIndex        =   24
         Top             =   660
         Width           =   915
      End
      Begin VB.Line Line1 
         X1              =   0
         X2              =   5520
         Y1              =   480
         Y2              =   480
      End
   End
   Begin VB.PictureBox picTab 
      BorderStyle     =   0  'None
      Height          =   435
      Left            =   420
      ScaleHeight     =   435
      ScaleWidth      =   3255
      TabIndex        =   0
      Top             =   240
      Width           =   3255
      Begin VB.OptionButton optTabCompile 
         Caption         =   "Compile"
         Height          =   435
         Left            =   1620
         Style           =   1  'Graphical
         TabIndex        =   2
         Top             =   0
         Width           =   1635
      End
      Begin VB.OptionButton optTabDump 
         Caption         =   "Dump"
         Height          =   435
         Left            =   0
         Style           =   1  'Graphical
         TabIndex        =   1
         Top             =   0
         Value           =   -1  'True
         Width           =   1635
      End
   End
   Begin VB.Frame fraTab 
      Height          =   4575
      Left            =   180
      TabIndex        =   3
      Top             =   360
      Width           =   5955
      Begin VB.PictureBox picDump 
         BorderStyle     =   0  'None
         Height          =   3915
         Left            =   240
         OLEDropMode     =   1  'Manual
         ScaleHeight     =   3915
         ScaleWidth      =   5535
         TabIndex        =   4
         Top             =   420
         Width           =   5535
         Begin VB.CheckBox chkDumpVsmxconv 
            Caption         =   "Decode V&SMX scripts"
            Height          =   255
            Left            =   120
            TabIndex        =   39
            Top             =   2760
            Value           =   1  'Checked
            Width           =   5295
         End
         Begin VB.CheckBox chkDumpRawtext 
            Caption         =   "Dump ra&w text instead of XML (may be slow!)"
            Height          =   255
            Left            =   120
            TabIndex        =   17
            Top             =   2520
            Width           =   5295
         End
         Begin VB.CheckBox chkDumpVagconv 
            Caption         =   "Convert &VAG sounds to WAV"
            Height          =   255
            Left            =   120
            TabIndex        =   16
            Top             =   2280
            Value           =   1  'Checked
            Width           =   5295
         End
         Begin VB.CheckBox chkDumpGimconv 
            Caption         =   "Convert &GIM images to PNG (uses gimconv; somewhat slow)"
            Height          =   255
            Left            =   120
            TabIndex        =   15
            Top             =   2040
            Value           =   1  'Checked
            Width           =   5295
         End
         Begin VB.CheckBox chkDumpResSubdirs 
            Caption         =   "Separate resource types into &separate folders"
            Height          =   255
            Left            =   960
            TabIndex        =   14
            Top             =   1560
            Value           =   1  'Checked
            Width           =   4455
         End
         Begin VB.CommandButton cmdDump 
            Caption         =   "Dump"
            Default         =   -1  'True
            Height          =   435
            Left            =   2040
            TabIndex        =   19
            Top             =   3480
            Width           =   1515
         End
         Begin VB.CommandButton cmdDumpRes 
            Caption         =   "Browse..."
            Height          =   315
            Left            =   4440
            TabIndex        =   13
            Top             =   1200
            Width           =   1035
         End
         Begin VB.TextBox txtDumpRes 
            Height          =   285
            Left            =   960
            TabIndex        =   12
            Top             =   1200
            Width           =   3435
         End
         Begin VB.CommandButton cmdDumpXMLBrowse 
            Caption         =   "Browse..."
            Height          =   315
            Left            =   4440
            TabIndex        =   10
            Top             =   780
            Width           =   1035
         End
         Begin VB.TextBox txtDumpXML 
            Height          =   285
            Left            =   960
            TabIndex        =   9
            Top             =   780
            Width           =   3435
         End
         Begin VB.CommandButton cmdDumpRCOBrowse 
            Caption         =   "Browse..."
            Height          =   315
            Left            =   4440
            OLEDropMode     =   1  'Manual
            TabIndex        =   7
            Top             =   120
            Width           =   1035
         End
         Begin VB.TextBox txtDumpRCO 
            Height          =   285
            Left            =   960
            OLEDropMode     =   1  'Manual
            TabIndex        =   6
            Top             =   120
            Width           =   3435
         End
         Begin VB.Label lblDumpNote 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "Note, GIM, VAG and VSMX conversions may be lossy."
            ForeColor       =   &H8000000D&
            Height          =   195
            Left            =   1080
            TabIndex        =   18
            Top             =   3120
            Width           =   3315
         End
         Begin VB.Label lblDumpRes 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "&Resources:"
            Height          =   195
            Left            =   0
            TabIndex        =   11
            Top             =   1200
            Width           =   810
         End
         Begin VB.Line lnDump 
            X1              =   0
            X2              =   5520
            Y1              =   600
            Y2              =   600
         End
         Begin VB.Label lblDumpXML 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "&XML Output:"
            Height          =   195
            Left            =   0
            TabIndex        =   8
            Top             =   780
            Width           =   900
         End
         Begin VB.Label lblDumpRCO 
            AutoSize        =   -1  'True
            BackStyle       =   0  'Transparent
            Caption         =   "&RCO Input:"
            Height          =   195
            Left            =   0
            OLEDropMode     =   1  'Manual
            TabIndex        =   5
            Top             =   120
            Width           =   795
         End
      End
   End
End
Attribute VB_Name = "frm"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit
Private Declare Sub InitCommonControls Lib "comctl32.dll" ()



Private Sub chkCompPackRes_Click()
Dim e As Boolean
e = (chkCompPackRes.Value = 1)
lblCompPackRes.Enabled = e
optCompPackResNone.Enabled = e
optCompPackResZlib.Enabled = e
'optCompPackResRlz.Enabled = e
End Sub

Private Sub cmdComp_Click()
If Len(txtCompXML.Text) = 0 Then
 MsgBox "Please select an XML file to compile!", vbExclamation
 Exit Sub
End If
If Len(txtCompRCO.Text) = 0 Then
 MsgBox "Please select where to compile the RCO to!", vbExclamation
 Exit Sub
End If

If Not FileExists(txtCompXML.Text) Then
 MsgBox "Input XML file cannot be found!", vbExclamation
 Exit Sub
End If

If FileExists(txtCompRCO.Text) Then Kill txtCompRCO.Text

Dim args As String
Dim tmpF As String
args = "--pack-hdr "
If optCompPackHdrNone.Value Then
 args = args & "none "
ElseIf optCompPackHdrZlib.Value Then
 args = args & "zlib "
ElseIf optCompPackHdrRlz.Value Then
 args = args & "rlz "
End If

If chkCompPackRes.Value = 1 Then
 args = args & "--pack-res "
 If optCompPackResNone.Value Then
  args = args & "none "
 ElseIf optCompPackResZlib.Value Then
  args = args & "zlib "
 ElseIf optCompPackResRlz.Value Then
  args = args & "rlz "
 End If
End If

Load frmWait
frmWait.Show , Me

tmpF = TempFileName
On Local Error GoTo shellErr
ChangeDir DirName(txtCompXML.Text)
ShellAndWait """" & appPath & "rcomage\rcomage.exe"" compile --quiet """ & txtCompXML.Text & """ """ & txtCompRCO.Text & """ " _
 & args & " --gimconv-cmd """ & appPath & "GimConv\GimConv.exe"" 2>""" & tmpF & """", vbHide
ChangeDir ""
On Local Error GoTo 0
If Not frmWait Is Nothing Then Unload frmWait

If FileExists(tmpF) Then
 If Not ParseOutputFile(tmpF) Then
  Kill tmpF
  If FileExists(txtCompRCO.Text) Then _
   MsgBox "RCO successfully compiled.", vbInformation _
  Else _
   MsgBox "RCO was not written!", vbCritical
 Else
  Kill tmpF
 End If
Else
 MsgBox "Error executing process, or reading/writing temporary output log.", vbCritical
End If

Exit Sub
shellErr:
 MsgBox "Unable to run rcomage!" & vbNewLine & Err.Description, vbCritical
End Sub

Private Sub cmdCompRCOBrowse_Click()
Dim s As String
s = Trim$(ShowComnDialog(Me.hwnd, txtDumpRCO.Text, "RCO Files (*.rco)" & vbNullChar & "*.rco" & vbNullChar & "All Files (*.*)" & vbNullChar & "*.*", "Select where to save compiled RCO", 0, "rco"))
If Len(s) > 0 Then txtCompRCO.Text = s
End Sub

Private Sub cmdCompXMLBrowse_Click()
Dim s As String
s = Trim$(ShowComnDialog(Me.hwnd, txtDumpXML.Text, "XML Files (*.xml)" & vbNullChar & "*.xml" & vbNullChar & "All Files (*.*)" & vbNullChar & "*.*", "Select an XML dump"))
If Len(s) > 0 Then txtCompXML.Text = s
End Sub

Private Sub cmdCompXMLBrowse_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
picComp_OLEDragDrop Data, Effect, Button, Shift, X, Y
End Sub

Private Sub cmdCompXMLBrowse_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
picComp_OLEDragOver Data, Effect, Button, Shift, X, Y, State
End Sub

Private Sub cmdDump_Click()
If Len(txtDumpRCO.Text) = 0 Then
 MsgBox "Please give an RCO file to dump!", vbExclamation
 Exit Sub
End If
If Len(txtDumpXML.Text) = 0 Then
 MsgBox "Please select where to dump the XML file!", vbExclamation
 Exit Sub
End If
If Len(txtDumpRes.Text) = 0 Then
 MsgBox "Please select where to dump RCO resources!", vbExclamation
 Exit Sub
End If

If Not FileExists(txtDumpRCO.Text) Then
 MsgBox "Input RCO file cannot be found!", vbExclamation
 Exit Sub
End If


If FileExists(txtDumpXML.Text) Then Kill txtDumpXML.Text

Dim args As String
Dim tmpF As String
Dim resPath As String
Dim baseDir As String
Dim resMadeImg As Boolean, resMadeSnd As Boolean, resMadeMdl As Boolean, resMadeTxt As Boolean, resMadeVSMX As Boolean
If True Then 'If chkDumpRes.Value = 1 Then
 MkDirRecur txtDumpRes.Text
 If Not IsDir(txtDumpRes.Text) Then
  MsgBox "Can't make specified resource directory!  Make sure the path is valid.", vbCritical
  Exit Sub
 End If
 
 baseDir = DirName(txtDumpXML.Text)
 resPath = txtDumpRes.Text
 If Right$(resPath, 1) <> "\" Then resPath = resPath & "\"
 
 ChangeDir baseDir
 
 If chkDumpResSubdirs.Value = 0 Then
  args = DumpPathToArg("--resdir", resPath, baseDir)
 Else
  
  args = DumpPathToArg("--images", resPath & "Images", baseDir) & " " & _
          DumpPathToArg("--sounds", resPath & "Sounds", baseDir) & " " & _
          DumpPathToArg("--models", resPath & "Models", baseDir) & " " & _
          DumpPathToArg("--text", resPath & "Text", baseDir) & " " & _
          DumpPathToArg("--vsmx", resPath & "VSMX", baseDir) & ""
  
  If Not IsDir(resPath & "Images") Then
   MkDir resPath & "Images"
   resMadeImg = True
  End If
  If Not IsDir(resPath & "Sounds") Then
   MkDir resPath & "Sounds"
   resMadeSnd = True
  End If
  If Not IsDir(resPath & "Models") Then
   MkDir resPath & "Models"
   resMadeMdl = True
  End If
  If Not IsDir(resPath & "Text") Then
   MkDir resPath & "Text"
   resMadeTxt = True
  End If
  If Not IsDir(resPath & "VSMX") Then
   MkDir resPath & "VSMX"
   resMadeVSMX = True
  End If
 End If
Else
 args = "--xml-only"
End If

If chkDumpGimconv.Value = 1 Then args = args & " --conv-gim png --gimconv-cmd """ & appPath & "GimConv\GimConv.exe"""
If chkDumpVagconv.Value = 1 Then args = args & " --conv-vag"
If chkDumpVsmxconv.Value = 1 Then args = args & " --decode-vsmx"
If chkDumpRawtext.Value = 1 Then args = args & " --output-txt"

Load frmWait
frmWait.Show , Me

tmpF = TempFileName
On Local Error GoTo shellErr
ShellAndWait """" & appPath & "rcomage\rcomage.exe"" dump --quiet --no-decomp-warn """ & txtDumpRCO.Text & """ """ & txtDumpXML.Text & """ " & args & " 2>""" & tmpF & """", vbHide
ChangeDir ""
On Local Error Resume Next
' remove empty directories if made
If resMadeImg Then RmDir resPath & "Images"
If resMadeSnd Then RmDir resPath & "Sounds"
If resMadeMdl Then RmDir resPath & "Models"
If resMadeTxt Then RmDir resPath & "Text"
If resMadeVSMX Then RmDir resPath & "VSMX"
On Local Error GoTo 0
If Not frmWait Is Nothing Then Unload frmWait
If FileExists(tmpF) Then
 If Not ParseOutputFile(tmpF) Then
  Kill tmpF
  If FileExists(txtDumpXML.Text) Then _
   MsgBox "RCO successfully dumped.", vbInformation _
  Else _
   MsgBox "XML was not written!", vbCritical
 Else
  Kill tmpF
 End If
Else
 MsgBox "Error executing process, or reading/writing temporary output log.", vbCritical
End If


Exit Sub
shellErr:
 MsgBox "Unable to run rcomage!" & vbNewLine & Err.Description, vbCritical
End Sub

Private Function DumpPathToArg(argName As String, s As String, Optional base As String = "") As String
 If Len(s) > 0 Then
  If Right$(s, 1) = "\" Then s = Left$(s, Len(s) - 1)
  If Right$(base, 1) = "\" Then base = Left$(base, Len(base) - 1)
  
  Dim compar As String
  compar = DirName(base) ' base is already a dir, so compare with up one level
  
  If Len(compar) > 0 And Len(compar) <= Len(s) Then
   If LCase$(compar) & "\" = LCase$(Left$(s & "\", Len(compar) + 1)) Then
    ' we use a relative path
    Dim useFullPath As Boolean
    
    ' check for full path match
    If Len(base) <= Len(s) Then
     If LCase$(base) & "\" = LCase$(Left$(s & "\", Len(base) + 1)) Then
      useFullPath = True
     End If
    End If
    
    If useFullPath Then
     s = Mid$(s & "\", Len(base) + 2)
    Else
     s = "..\" & Mid$(s & "\", Len(compar) + 2)
    End If
    If Right$(s, 1) = "\" Then s = Left$(s, Len(s) - 1)
    If Len(s) = 0 Then s = "."
   End If
  End If
  
  If s = "." Then
   DumpPathToArg = ""
  Else
   DumpPathToArg = argName & " """ & s & """"
  End If
 ' If Right$(s, 1) = "\" Then  ' stop weird bug where \" escapes the " (won't stop things like \\" though)
 '  DumpPathToArg = """" & Left$(s, Len(s) - 1) & """"
 ' Else
 '  DumpPathToArg = """" & s & """"
 ' End If
 'Else
 ' DumpPathToArg = "-"
 End If
End Function

Private Function DirName(s As String) As String ' also trims off trailing "\"
If Len(s) = 0 Then
 DirName = ""
 Exit Function
End If

If Right$(s, 1) = "\" Then s = Left$(s, Len(s) - 1)

If InStr(1, s, "\") > 0 Then _
 DirName = Left$(s, InStrRev(s, "\") - 1) _
Else _
 DirName = s
End Function

Private Sub cmdDumpRCOBrowse_Click()
Dim s As String
s = Trim$(ShowComnDialog(Me.hwnd, DirName(txtDumpRCO.Text), "RCO Files (*.rco)" & vbNullChar & "*.rco" & vbNullChar & "All Files (*.*)" & vbNullChar & "*.*", "Select an RCO file to dump"))
If Len(s) > 0 Then txtDumpRCO.Text = s
End Sub

Private Sub cmdDumpRCOBrowse_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
picDump_OLEDragDrop Data, Effect, Button, Shift, X, Y
End Sub

Private Sub cmdDumpRCOBrowse_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
picDump_OLEDragOver Data, Effect, Button, Shift, X, Y, State
End Sub

Private Sub cmdDumpRes_Click()
Dim s As String
s = Trim$(ShowCommDirDlg(Me.hwnd, "Save resources to:", txtDumpRes.Text))
If Len(s) > 0 Then txtDumpRes.Text = s
End Sub

Private Sub cmdDumpXMLBrowse_Click()
Dim s As String
s = Trim$(ShowComnDialog(Me.hwnd, DirName(txtDumpXML.Text), "XML Files (*.xml)" & vbNullChar & "*.xml" & vbNullChar & "All Files (*.*)" & vbNullChar & "*.*", "Select where to save XML dump", 0, "xml"))
If Len(s) > 0 Then
 txtDumpXML.Text = s
 txtDumpXML_LostFocus
End If
End Sub

Private Sub Form_Initialize()
InitCommonControls

appPath = App.Path
If Right$(appPath, 1) <> "\" Then appPath = appPath & "\"
End Sub

Private Sub lblCompXML_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
picComp_OLEDragDrop Data, Effect, Button, Shift, X, Y
End Sub

Private Sub lblCompXML_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
picComp_OLEDragOver Data, Effect, Button, Shift, X, Y, State
End Sub

Private Sub lblDumpRCO_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
picDump_OLEDragDrop Data, Effect, Button, Shift, X, Y
End Sub

Private Sub lblDumpRCO_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
picDump_OLEDragOver Data, Effect, Button, Shift, X, Y, State
End Sub

Private Sub optTabCompile_Click()
picDump.Visible = False
picComp.Visible = True
cmdDump.Default = False
cmdComp.Default = True
On Local Error Resume Next
txtCompXML.SetFocus
End Sub

Private Sub optTabDump_Click()
picComp.Visible = False
picDump.Visible = True
cmdComp.Default = False
cmdDump.Default = True
On Local Error Resume Next
txtDumpRCO.SetFocus
End Sub

Private Sub picComp_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Not Data.GetFormat(ClipBoardConstants.vbCFFiles) Then Exit Sub

If Data.Files.Count > 1 Then _
 MsgBox "More than one file was dropped - only the first file will be used.", vbExclamation

txtCompXML.Text = Data.Files(1)

On Local Error Resume Next
ChDrive Left$(Data.Files(1), 2)
ChDir DirName(Data.Files(1))
End Sub

Private Sub picComp_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
Generic_OLEDragOver Data, Effect
End Sub

Private Sub picDump_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
If Not Data.GetFormat(ClipBoardConstants.vbCFFiles) Then Exit Sub

If Data.Files.Count > 1 Then _
 MsgBox "More than one file was dropped - only the first file will be used.", vbExclamation

txtDumpRCO.Text = Data.Files(1)
On Local Error Resume Next
ChDrive Left$(Data.Files(1), 2)
ChDir DirName(Data.Files(1))
End Sub

Private Sub picDump_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
Generic_OLEDragOver Data, Effect
End Sub

Private Sub txtCompXML_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
picComp_OLEDragDrop Data, Effect, Button, Shift, X, Y
End Sub

Private Sub txtCompXML_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
picComp_OLEDragOver Data, Effect, Button, Shift, X, Y, State
End Sub

Private Sub txtDumpRCO_OLEDragDrop(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single)
picDump_OLEDragDrop Data, Effect, Button, Shift, X, Y
End Sub

Private Sub txtDumpRCO_OLEDragOver(Data As DataObject, Effect As Long, Button As Integer, Shift As Integer, X As Single, Y As Single, State As Integer)
picDump_OLEDragOver Data, Effect, Button, Shift, X, Y, State
End Sub

Private Sub txtDumpXML_LostFocus()
If Len(txtDumpXML.Text) < 1 Then Exit Sub
If InStr(1, txtDumpXML.Text, "\") < 1 Then Exit Sub
If Len(txtDumpRes.Text) = 0 Then
  Dim fPath As String
  fPath = DirName(txtDumpXML.Text)
  If Len(fPath) < 1 Then Exit Sub
  txtDumpRes.Text = fPath
End If
End Sub

Private Function ParseOutputFile(fn As String) As Boolean
Dim ff As Integer
Dim ln As String
Dim output As String
output = Space$(65536)
output = ""
ff = FreeFile
Open fn For Input Access Read Lock Write As #ff

Do Until EOF(ff)
 Line Input #ff, ln
 ln = Trim$(ln)
 If Len(ln) > 0 Then
  output = output & ln & vbNewLine
 End If
Loop

Close #ff

If Len(output) > 0 Then
 ParseOutputFile = True
 Load frmOutput
 frmOutput.txt.Text = output
 frmOutput.Show vbModal, Me
Else
 ParseOutputFile = False
End If
End Function

Private Sub ChangeDir(d As String)
 Static lastDir As String
 Dim targ As String, temp As String
 If Len(d) = 0 Then
  If Len(lastDir) = 0 Then Exit Sub
  targ = lastDir
 Else
  targ = d
  If Len(lastDir) = 0 Then
   lastDir = CurDir
   If Right$(lastDir, 1) <> "\" Then lastDir = lastDir & "\"
  End If
 End If
 
 If Mid$(targ & "\", 2, 2) = ":\" Then ChDrive Left$(targ, 1)
 ChDir targ
 temp = CurDir
 If Right$(temp, 1) <> "\" Then temp = temp & "\"
 If Right$(targ, 1) <> "\" Then targ = targ & "\"
 If LCase$(temp) <> LCase$(targ) Then
  MsgBox "Couldn't chdir!", vbCritical
  'Exit Sub
 End If
End Sub
