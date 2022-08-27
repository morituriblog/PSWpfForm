Add-Type -AssemblyName System.Windows.Forms

function Start-Dialog {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]
        $Controls,
        [Parameter(Mandatory=$true)]
        [scriptblock]
        $InitScript
    )

    $InitScript.Invoke() | Out-Null

    return $Controls
}