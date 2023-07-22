. ..\..\dialog.ps1
. ..\..\tools.ps1

Start-Dialog `
-Controls @{} `
-XAMLPaths @("MainWindow.xaml") `
-EventMethods @{
    OkButton_Click = {
        $Methods.Hello()
    };
    InputText_PreviewDragOver = {
        param($sender, $e)

        $Props.Tools.DragOverFileDropCopy($e)
    };
    InputText_Drop = {
        param($sender, $e)

        $Controls.InputText.Text = $Props.Tools.GetFileDropValue($e)
    };
} `
-InitScript {
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
    Tools = Get-DialogTools;
}
