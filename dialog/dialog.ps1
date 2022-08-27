Add-Type -AssemblyName System.Windows.Forms

function AddEventMethods {
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

function Start-Dialog {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]
        $Controls,
        [Parameter(Mandatory=$true)]
        [hashtable]
        $EventMethods,
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $InitScript
    )

    foreach ($eventName in $EventMethods.Keys) {
        AddEventMethods -ControlHashTable $Controls -EventName $eventName -EventScript $EventMethods[$eventName]
    }

    $InitScript.Invoke() | Out-Null

    return $Controls
}