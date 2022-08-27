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
-EventMethods @{
    OkButton_Click = {
        [System.Windows.Forms.MessageBox]::Show("OK Clicked!")
    }
} `
-InitScript {
    $Controls.MainForm.Controls.Add($Controls.OkButton)
    $Controls.MainForm.ShowDialog()
}