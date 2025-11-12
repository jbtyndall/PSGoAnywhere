<#
.SYNOPSIS
Creates a GoAnywhere Client object with authorization headers.

.DESCRIPTION
Builds a client object containing the BaseUri and Authorization header for GoAnywhere API calls.
Optionally tests connectivity to ensure the server is reachable and credentials are valid.

.PARAMETER Username
GoAnywhere API username. Defaults to environment variable GOANYWHERE_API_USERNAME.

.PARAMETER ApiKey
GoAnywhere API key. Defaults to environment variable GOANYWHERE_API_KEY.

.PARAMETER BaseUri
The base REST endpoint for GoAnywhere (e.g. https://server.example.com:8001/goanywhere/rest/gacmd/v1).

.PARAMETER TestConnection
If specified, performs a test request to validate connectivity and credentials.

.EXAMPLE
$client = New-GAClient -BaseUri "https://server.example.com:8001/goanywhere/rest/gacmd/v1"

.EXAMPLE
$client = New-GAClient -ApiUsername "apiuser" -ApiKey "abc123" -BaseUri "https://server.example.com:8001/goanywhere/rest/gacmd/v1" -TestConnection
#>
function New-GAClient {
    [CmdletBinding()]
    param (
        [string]$ApiUsername = $env:GOANYWHERE_API_USERNAME,
        [string]$ApiKey = $env:GOANYWHERE_API_KEY,
        [Parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]$BaseUri,
        [switch]$TestConnection
    )

    if (-not $ApiUsername -or -not $ApiKey) {
        throw "Missing GoAnywhere credentials. Provide ApiUsername/ApiKey or set environment variables."
    }

    $pair = "$ApiUsername`:$ApiKey"

    $encodedPair = [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($pair))

    $header = @{
        Authorization = "Basic $encodedPair"
        Accept        = "application/json"
    }

    $client = [PSCustomObject]@{
        BaseUri = $BaseUri.TrimEnd('/')
        Header  = $header
    }

    Write-Verbose "Created GoAnywhere client object for $BaseUri as $ApiUsername"

    if ($TestConnection) {
        try {
            Write-Verbose "Testing connection to $BaseUri..."

            $testUri = "$($client.BaseUri)/webusers"

            Invoke-RestMethod -Uri $testUri -Headers $header -Method Get -ErrorAction Stop | Out-Null
            
            Write-Verbose "Test connection successful."
        }
        catch {
            throw "Test connection failed: $($_.Exception.Message)"
        }
    }

    return $client
}