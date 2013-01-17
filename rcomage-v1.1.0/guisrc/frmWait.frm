VERSION 5.00
Begin VB.Form frmWait 
   BorderStyle     =   0  'None
   Caption         =   "Please wait - processing..."
   ClientHeight    =   960
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   2880
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   Moveable        =   0   'False
   ScaleHeight     =   960
   ScaleWidth      =   2880
   ShowInTaskbar   =   0   'False
   StartUpPosition =   1  'CenterOwner
   Begin VB.Frame Frame1 
      Height          =   855
      Left            =   120
      TabIndex        =   0
      Top             =   0
      Width           =   2655
      Begin VB.Label lbl 
         AutoSize        =   -1  'True
         BackStyle       =   0  'Transparent
         Caption         =   "Please wait - processing..."
         Height          =   195
         Left            =   360
         TabIndex        =   1
         Top             =   360
         Width           =   1845
      End
   End
End
Attribute VB_Name = "frmWait"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub Form_Click()
Unload Me
End Sub

Private Sub Frame1_Click()
Unload Me
End Sub

Private Sub lbl_Click()
Unload Me
End Sub
