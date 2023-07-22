Add-Type -AssemblyName PresentationFramework

function Set-EventMethods {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]
        $ControlHashTable,
        [Parameter(Mandatory=$true)]
        [string]
        $EventName,
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $EventScript
    )

    $controlAndEvent = $EventName -split "_"
    if ($controlAndEvent.Length -ne 2) { return }

    $controlName = $controlAndEvent[0]
    $EventName = $controlAndEvent[1]
    
    if (!$ControlHashTable.ContainsKey($controlName)) { return }

    $command = '$ControlHashTable.' + $controlName + '.Add_' + $EventName + '({'+ $EventScript.ToString() +'})'
    Invoke-Expression -Command $command
}

function Set-XamlControls {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]
        $ControlHashTable,
        [Parameter(Mandatory=$true)]
        [string]
        $XamlPath
    )

    if (![System.IO.File]::Exists($XamlPath)) { return }

    $xamlText = [System.IO.File]::ReadAllText($XamlPath, [System.Text.Encoding]::UTF8)
    $controlValue = [System.Windows.Markup.XamlReader]::Parse($xamlText)

    # Add Controls with name.
    $xnavi = ([xml]$xamlText).CreateNavigator()
    foreach ($node in $xnavi.Select("//@Name")) {
        $xamlControlName = $node.Value
        $ControlHashTable["$xamlControlName"] = $controlValue.FindName($xamlControlName)
    }
}

function Start-Dialog {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]
        $Controls,
        [array]
        $XAMLPaths,
        [Parameter(Mandatory=$true)]
        [hashtable]
        $EventMethods,
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $InitScript,
        [hashtable]
        $Methods,
        [hashtable]
        $Props
    )

    foreach ($path in $XAMLPaths) {
        Set-XamlControls -ControlHashTable $Controls -XamlPath $path
    }

    $methodHashtable = $Methods
    $Methods = New-Object PSCustomObject
    foreach ($methodName in $methodHashtable.Keys) {
        $Methods | Add-Member -MemberType ScriptMethod -Name $methodName -Value $methodHashtable[$methodName]
    }

    foreach ($eventName in $EventMethods.Keys) {
        Set-EventMethods -ControlHashTable $Controls -EventName $eventName -EventScript $EventMethods[$eventName]
    }

    $InitScript.Invoke() | Out-Null

    return $Controls
}
