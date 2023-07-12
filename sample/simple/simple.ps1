. ..\..\dialog.ps1

Start-Dialog `
-Controls @{
    MainWindow = [System.Windows.Window]@{
        Title = "Hello WPF";
        Height = 150;
        Width = 250;
    };
} `
-XAMLPaths @("MainPanel.xaml") `
-EventMethods @{
    OkButton_Click = {
        $Methods.Hello()
    };
} `
-InitScript {
    $Controls.MainWindow.AddChild($Controls.MainPanel)
    $Controls.MainWindow.ShowDialog()
} `
-Methods @{
    Hello = {
        $helloMessage = $Props.HelloFormat -f $Controls.InputText.Text
        [System.Windows.MessageBox]::Show($helloMessage)
    };
} `
-Props @{
    HelloFormat = "Hello, {0}!";
}
