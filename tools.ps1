function Get-DialogTools {
    $toolsHashtable = @{
        DragOverFileDropCopy = {
            param($e)
    
            if ($e.Data.GetDataPresent([System.Windows.DataFormats]::FileDrop)) {
                $e.Effects = [System.Windows.DragDropEffects]::Copy
            } else {
                $e.Effects = [System.Windows.DragDropEffects]::None
            }
            $e.Handled = $true
        };
        GetFileDropValue = {
            param($e)
    
            $dropValue = ""
            if ($e.Data.GetDataPresent([System.Windows.DataFormats]::FileDrop)) {
                $fileDrop = $e.Data.GetData([System.Windows.DataFormats]::FileDrop)
                $dropValue = $fileDrop[0]
            }
            return $dropValue
        };
    }

    $tools = New-Object PSCustomObject
    foreach ($methodName in $toolsHashtable.Keys) {
        $tools | Add-Member -MemberType ScriptMethod -Name $methodName -Value $toolsHashtable[$methodName]
    }

    return $tools
}
