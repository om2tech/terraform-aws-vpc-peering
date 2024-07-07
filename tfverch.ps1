[CmdletBinding()]
param (
    [Parameter()]
    [ValidateNotNullOrEmpty()]
    [String]
    $Path
)

if (![string]::IsNullOrEmpty($Path)) {
    Push-Location $Path
}

Write-Output "Working directory is $(pwd)"
docker run --rm -it -v "$(pwd):/src" tfverch/tfvc /src

Pop-Location
