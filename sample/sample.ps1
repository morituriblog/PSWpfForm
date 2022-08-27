. ..\dialog\dialog.ps1

Start-Dialog `
-Controls @{
    MainForm = [System.Windows.Forms.Form]@{
        Text = "Main Form";
        AutoSize = $true;
        AutoSizeMode = [System.Windows.Forms.AutoSizeMode]::GrowAndShrink;
    };
    OkButton = [System.Windows.Forms.Button]@{
        Text = "OK";
        Width = 400;
    };
} `
-InitScript {
    $Controls.MainForm.Controls.Add($Controls.OkButton)
    $Controls.MainForm.ShowDialog()
}