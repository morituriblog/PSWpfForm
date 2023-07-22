. ..\..\dialog.ps1

$controls = @{}
Set-WpfControls -ControlHashTable $controls -XamlText @"
<Window xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
    Name="MainWindow" Title="Hello WPF" Height="150" Width="250">
    <StackPanel Name="MainPanel">
        <Label FontSize="20" Name="PromptLabel">Please Input:</Label>
        <TextBox FontSize="20" Name="InputText">Taro</TextBox>
        <Button FontSize="20" Name="OkButton">OK</Button>
    </StackPanel>
</Window>
"@

$props = @{
    HelloFormat = "Hello, {0}!";
}

$methods = New-Object PSCustomObject
Set-MethodObject -MethodObject $methods -MethodHashtable @{
    Hello = {
        $helloMessage = $props.HelloFormat -f $controls.InputText.Text
        [System.Windows.MessageBox]::Show($helloMessage)
    };
}

Set-ControlEvent -Controls $controls -EventHashtable @{
    OkButton_Click = {
        $methods.Hello()
    };
}

$controls.MainWindow.ShowDialog()
