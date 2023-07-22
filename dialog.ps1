Add-Type -AssemblyName PresentationFramework

function Set-WpfControls {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]
        $ControlHashTable,
        [Parameter(Mandatory=$true)]
        [string]
        $XamlText
    )

    $wpfObj = [System.Windows.Markup.XamlReader]::Parse($XamlText)

    # Add Controls with name.
    $xnavi = ([xml]$XamlText).CreateNavigator()
    foreach ($node in $xnavi.Select("//@Name")) {
        $name = $node.Value
        $ControlHashTable["$name"] = $wpfObj.FindName($name)
    }
}

function Set-MethodObject {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]
        $MethodObject,
        [Parameter(Mandatory=$true)]
        [hashtable]
        $MethodHashtable
    )

    foreach ($name in $methodHashtable.Keys) {
        $MethodObject | Add-Member -MemberType ScriptMethod -Name $name -Value $methodHashtable[$name]
    }
}

function Set-ControlEvent {
    param(
        [Parameter(Mandatory=$true)]
        [hashtable]
        $Controls,
        [Parameter(Mandatory=$true)]
        [hashtable]
        $EventHashtable
    )

    foreach ($key in $EventHashtable.Keys) {
        $controlAndEvent = $key -split "_"
        $controlName = $controlAndEvent[0]
        $eventName = $controlAndEvent[1]

        $addEvent = Invoke-Expression -Command ('$Controls[$controlName].Add_' + $eventName)
        $addEvent.Invoke($EventHashtable[$key])
    }
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

    Set-WpfControls -ControlHashTable $ControlHashTable -XamlText $xamlText
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
    Set-MethodObject -MethodObject $Methods -MethodHashtable $methodHashtable

    Set-ControlEvent -Controls $Controls -EventHashtable $EventMethods

    $InitScript.Invoke() | Out-Null

    return $Controls
}
