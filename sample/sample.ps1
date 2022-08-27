. ..\dialog\dialog.ps1

Start-Dialog `
-Controls @{
    MainForm = [System.Windows.Forms.Form]@{
        Text = "Main Form";
        Height = 100;
        Width = 250;
    };
    MainPanel = [System.Windows.Forms.FlowLayoutPanel]@{};
    OkButton = [System.Windows.Forms.Button]@{
        Text = "OK";
    };
    InputText = [System.Windows.Forms.TextBox]@{
        Text = "Taro";
    }
} `
-EventMethods @{
    OkButton_Click = {
        $Methods.Hello()
    };
} `
-InitScript {
    $Controls.MainForm.Controls.Add($Controls.MainPanel)
    $Controls.MainPanel.Controls.Add($Controls.OkButton)
    $Controls.MainPanel.Controls.Add($Controls.InputText)
    $Controls.MainForm.ShowDialog()
} `
-Methods @{
    Hello = {
        $helloMessage = $Props.HelloFormat -f $Controls.InputText.Text
        [System.Windows.Forms.MessageBox]::Show($helloMessage)
    };
} `
-Props @{
    HelloFormat = "Hello, {0}!";
}