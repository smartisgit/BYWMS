Public Class Form1
    Public Shared Sub Main()
        Console.WriteLine("ActiveReportsPDFExport")

        Dim clArgs() As String = Environment.GetCommandLineArgs()
        Console.WriteLine("args: " & clArgs.Count())
        If clArgs.Count() <> 3 Then
            Console.WriteLine("Expected arguments <srcfil> <dstfil>")
        Else
            Call ExportToPDF(clArgs(1), clArgs(2))
        End If
        'Console.ReadKey(True)
    End Sub

    Shared Sub ExportToPDF(srcfil As String, dstfil As String)
        Console.WriteLine("srcfil " & srcfil)
        Console.WriteLine("dstfil " & dstfil)

        Dim x As New DDActiveReports2.ActiveReport
        x.Pages.Load(srcfil)
        Console.WriteLine("Loaded " & srcfil)

        Dim pdfExpt = New ActiveReportsPDFExport2.ARExportPDF
        'pdfExpt.AcrobatVersion = DDACR40
        pdfExpt.JPGQuality = 100
        pdfExpt.OutputTOCAsBookmarks = True
        pdfExpt.FileName = dstfil
        Call pdfExpt.Export(x.Pages)
        Console.WriteLine("Exported " & dstfil)
    End Sub
End Class
