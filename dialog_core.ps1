Add-Type -AssemblyName PresentationFramework

function Set-WpfControls {
    param([hashtable]$ControlHashTable, [string]$XamlText)

    $wpfObj = [System.Windows.Markup.XamlReader]::Parse($XamlText)

    $xnavi = ([xml]$XamlText).CreateNavigator()
    foreach ($node in $xnavi.Select("//@Name")) {
        $name = $node.Value
        $ControlHashTable["$name"] = $wpfObj.FindName($name)
    }
}

function Set-MethodObject {
    param([PSCustomObject]$MethodObject, [hashtable]$MethodHashtable)

    foreach ($name in $methodHashtable.Keys) {
        $MethodObject | Add-Member -MemberType ScriptMethod -Name $name -Value $methodHashtable[$name]
    }
}

function Set-ControlEvent {
    param([hashtable]$Controls, [hashtable]$EventHashtable)

    foreach ($key in $EventHashtable.Keys) {
        $controlAndEvent = $key -split "_"
        $controlName = $controlAndEvent[0]
        $eventName = $controlAndEvent[1]

        $addEvent = Invoke-Expression -Command ('$Controls[$controlName].Add_' + $eventName)
        $addEvent.Invoke($EventHashtable[$key])
    }
}
