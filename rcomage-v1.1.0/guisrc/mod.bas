Attribute VB_Name = "mod"
Option Explicit

Public appPath As String

Private Const MAX_PATH = 260


Private Declare Function SendMessage Lib "user32.dll" Alias "SendMessageA" (ByVal hwnd As Long, ByVal wMsg As Long, ByVal wParam As Long, ByRef lParam As Any) As Long

'============ SHELL AND WAIT ================
Private Declare Function OpenProcess Lib "kernel32.dll" (ByVal dwDesiredAccess As Long, ByVal bInheritHandle As Long, ByVal dwProcessId As Long) As Long
Private Declare Function WaitForSingleObject Lib "kernel32.dll" (ByVal hHandle As Long, ByVal dwMilliseconds As Long) As Long
'Private Declare Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long
Private Const SYNCHRONIZE As Long = &H100000
Private Const PROCESS_QUERY_INFORMATION As Long = (&H400)
Private Const INFINITE As Long = &HFFFFFFFF
Private Declare Function GetExitCodeProcess Lib "kernel32.dll" (ByVal hProcess As Long, ByRef lpExitCode As Long) As Long

'============ TEMP FILENAME ================
Private Declare Function GetTempFileName Lib "kernel32.dll" Alias "GetTempFileNameA" (ByVal lpszPath As String, ByVal lpPrefixString As String, ByVal wUnique As Long, ByVal lpTempFileName As String) As Long
Private Declare Function GetTempPath Lib "kernel32.dll" Alias "GetTempPathA" (ByVal nBufferLength As Long, ByVal lpBuffer As String) As Long


'============ FILE FINDING ================
Private Declare Function FindFirstFile Lib "kernel32" Alias "FindFirstFileA" (ByVal lpFileName As String, lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function FindNextFile Lib "kernel32.dll" Alias "FindNextFileA" (ByVal hFindFile As Long, ByRef lpFindFileData As WIN32_FIND_DATA) As Long
Private Declare Function CloseHandle Lib "kernel32.dll" (ByVal hObject As Long) As Long
'Private Const MAX_PATH = 260
Private Type FILETIME
        dwLowDateTime As Long
        dwHighDateTime As Long
End Type
Private Type WIN32_FIND_DATA
        dwFileAttributes As Long
        ftCreationTime As FILETIME
        ftLastAccessTime As FILETIME
        ftLastWriteTime As FILETIME
        nFileSizeHigh As Long
        nFileSizeLow As Long
        dwReserved0 As Long
        dwReserved1 As Long
        cFileName As String * MAX_PATH
        cAlternate As String * 14
End Type
Private Const INVALID_HANDLE_VALUE As Long = -1




'============ BROWSE FOR FOLDER ================
Private Declare Function SHBrowseForFolder Lib "shell32.dll" (ByRef lpBI As BROWSEINFO) As Long
Private Declare Function SHGetPathFromIDList Lib "shell32.dll" (ByVal pidl As Any, ByVal pszPath As String) As Long
Private Type BROWSEINFO
 hOwner As Long
 pidlRoot As Long
 pszDisplayName As String
 lpszTitle As String
 ulFlags As Long
 lpfn As Long
 lParam As Long
 iImage As Long
End Type
Private Const BIF_RETURNONLYFSDIRS As Long = &H1
Private Const BIF_DONTGOBELOWDOMAIN As Long = &H2
Private Const BIF_STATUSTEXT As Long = &H4
Private Const BIF_RETURNFSANCESTORS As Long = &H8
Private Const BIF_EDITBOX As Long = &H10
Private Const BIF_VALIDATE As Long = &H20
Private Const BIF_USENEWUI As Long = &H40

Private Const WM_USER As Long = &H400
Private Const BFFM_ENABLEOK As Long = (WM_USER + 101)
Private Const BFFM_INITIALIZED As Long = 1
Private Const BFFM_SELCHANGED As Long = 2
Private Const BFFM_SETSELECTIONA As Long = (WM_USER + 102)
Private Const BFFM_SETSTATUSTEXTA As Long = (WM_USER + 100)
Private Const BFFM_VALIDATEFAILEDA As Long = 3

Private m_BFF_curDir As String


'============ COMMON DIALOG ================
Private Const OFN_PATHMUSTEXIST = &H800
Private Const OFN_HIDEREADONLY = &H4
Private Const OFN_FILEMUSTEXIST = &H1000
Private Const OFN_OVERWRITEPROMPT As Long = &H2
Private Const OFN_ALLOWMULTISELECT As Long = &H200
Private Const OFN_EXPLORER As Long = &H80000

Private Type OPENFILENAME
     lngStructSize As Long          ' Size of structure
     hwndOwner As Long              ' Owner window handle
     hInstance As Long              ' Template instance handle
     strFilter As String            ' Filter string
     strCustomFilter As String      ' Selected filter string
     intMaxCustFilter As Long       ' Len(strCustomFilter)
     intFilterIndex As Long         ' Index of filter string
     strFile As String              ' Selected filename & path
     intMaxFile As Long             ' Len(strFile)
     strFileTitle As String         ' Selected filename
     intMaxFileTitle As Long        ' Len(strFileTitle)
     strInitialDir As String        ' Directory name
     strTitle As String             ' Dialog title
     lngFlags As Long               ' Dialog flags
     intFileOffset As Integer       ' Offset of filename
     intFileExtension As Integer    ' Offset of file extension
     strDefExt As String            ' Default file extension
     lngCustData As Long            ' Custom data for hook
     lngfnHook As Long              ' LP to hook function
     strTemplateName As String      ' Dialog template name
End Type

Private Declare Function GetOpenFileName _
 Lib "comdlg32.dll" Alias "GetOpenFileNameA" _
 (pOpenfilename As Any) As Long
Private Declare Function GetSaveFileName Lib "comdlg32.dll" Alias "GetSaveFileNameA" (ByRef pOpenfilename As OPENFILENAME) As Long







Public Function ShowCommDirDlg(hwndForm As Long, strTitle As String, strDir As String) As String
Dim bi As BROWSEINFO
With bi
 .hOwner = hwndForm
 .lpszTitle = strTitle
 .ulFlags = BIF_DONTGOBELOWDOMAIN Or BIF_USENEWUI Or BIF_RETURNONLYFSDIRS Or BIF_STATUSTEXT
 .lpfn = RetAddrOfFunc(AddressOf ShowCommDirDlgCallback)
 'If Len(strDir) > 0 Then
 ' .lParam = StrPtr(strDir)
 'End If
 m_BFF_curDir = strDir
End With
Dim strOut As String
strOut = Space$(MAX_PATH)
SHGetPathFromIDList SHBrowseForFolder(bi), strOut

ShowCommDirDlg = Trim$(Replace$(strOut, vbNullChar, ""))
End Function

' thanks to Flyguy at http://www.xtremevbtalk.com/showpost.php?p=120563&postcount=3 for this code :)
Private Function ShowCommDirDlgCallback(ByVal hwnd As Long, ByVal uMsg As Long, ByVal lp As Long, ByVal pData As Long) As Long
  Dim lpIDList As Long
  Dim ret As Long
  Dim sBuffer As String
  
  'On Error Resume Next
  Select Case uMsg
    Case BFFM_INITIALIZED
      Call SendMessage(hwnd, BFFM_SETSELECTIONA, 1, ByVal m_BFF_curDir)
      
    Case BFFM_SELCHANGED
      sBuffer = Space(MAX_PATH)
      
      ret = SHGetPathFromIDList(lp, sBuffer)
      If ret = 1 Then
        Call SendMessage(hwnd, BFFM_SETSTATUSTEXTA, 0, sBuffer)
      End If
  End Select
  
  ShowCommDirDlgCallback = 0
End Function



Public Function ShowComnDialog(hwndOwner As Long, ByVal strInitDir As String, strFilter As String, strTitle As String, Optional intSaveFilter As Integer = -1, Optional strSaveDefExt As String = "", Optional intMultiSelect As Integer = -1) As String
Dim of As OPENFILENAME
Dim strBuff As String * 255

If strInitDir = "" Then strInitDir = CurDir$


strBuff = String$(255, vbNullChar)
With of
 .lngStructSize = Len(of)
 .hwndOwner = hwndOwner
 .strFilter = strFilter
 .intFilterIndex = 0
 .strFile = strBuff
 .intMaxFile = 255
 .strFileTitle = String$(255, vbNullChar)
 .intMaxFileTitle = 255
 .strTitle = strTitle
 
 .lngFlags = IIf(intSaveFilter <> -1, OFN_OVERWRITEPROMPT, OFN_FILEMUSTEXIST) Or OFN_PATHMUSTEXIST Or OFN_HIDEREADONLY Or IIf(intMultiSelect > -1, OFN_ALLOWMULTISELECT Or OFN_EXPLORER, 0)

 .strInitialDir = strInitDir
 .hInstance = 0
 .strCustomFilter = String$(255, vbNullChar)
 .intMaxCustFilter = 255
 .lngfnHook = 0
 
 .strDefExt = strSaveDefExt
End With

If intSaveFilter <> -1 Then
 GetSaveFileName of
 intSaveFilter = of.intFilterIndex
Else
 GetOpenFileName of
End If

If intMultiSelect > -1 Then
 intMultiSelect = of.intFileOffset
 ShowComnDialog = Trim$(Left$(of.strFile, InStr(1, of.strFile, vbNullChar & vbNullChar) - 1))
Else
 ShowComnDialog = Trim$(Replace$(of.strFile, vbNullChar, ""))
End If
End Function




Public Sub Generic_OLEDragOver(Data As DataObject, Effect As Long)
If Not Data.GetFormat(ClipBoardConstants.vbCFFiles) Then _
 Effect = OLEDropEffectConstants.vbDropEffectNone
End Sub




'used to determine whether a file exists
'this is used instead of the VB Dir because,
'Dir("C:\") will return the first file in C:
'whereas I want to know if C:\ is a valid file!
Public Function FileExists(FName As String, Optional bNoNull As Boolean = False) As Boolean
Dim fd As WIN32_FIND_DATA
CloseHandle FindFirstFile(FName, fd)
FileExists = (Len(Replace$(fd.cFileName, vbNullChar, "")) > 0)
If FileExists And bNoNull Then FileExists = (FileLen(FName) > 0)
End Function


Public Function RetAddrOfFunc(addr As Long) As Long
RetAddrOfFunc = addr
End Function

Public Function TempFileName() As String
Dim tmpF As String
Dim tmp As String
tmpF = Space(MAX_PATH)
GetTempPath MAX_PATH, tmpF
tmp = "tmp"
GetTempFileName tmpF, tmp, 0, tmpF
TempFileName = Trim$(Replace$(tmpF, vbNullChar, ""))
End Function


Public Function ShellAndWait(PathName As String, WindowStyle As VbAppWinStyle) As Long
Dim pid As Long
Dim ph As Long

pid = Shell("cmd /c """ & PathName & """", WindowStyle)

DoEvents

ph = OpenProcess(SYNCHRONIZE Or PROCESS_QUERY_INFORMATION, 0, pid)
If ph <> 0 Then
 WaitForSingleObject ph, INFINITE
 GetExitCodeProcess ph, ShellAndWait
 CloseHandle ph
End If
End Function

Public Function DirName(fn As String) As String
Dim i As Integer
i = InStrRev(fn, "\")
If i > 0 Then
 DirName = Left$(fn, i)
Else
 DirName = fn
End If
End Function

Public Function IsDir(Path As String) As Boolean
On Local Error Resume Next
IsDir = (GetAttr(Path) And vbDirectory)
End Function

Public Sub MkDirRecur(dn As String)
If Len(dn) < 4 Then Exit Sub

If Right$(dn, 1) <> "\" Then dn = dn & "\"
Dim i As Integer
i = InStr(4, dn, "\")

While i > 0
 On Local Error Resume Next
 MkDir Left$(dn, i)
 On Local Error GoTo 0
 
 i = InStr(i + 1, dn, "\")
Wend
End Sub
