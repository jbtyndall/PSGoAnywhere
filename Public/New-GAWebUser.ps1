<#
.SYNOPSIS
Retrieves one or more GoAnywhere Web Users.

.DESCRIPTION
Queries the GoAnywhere REST API for a specific Web User or all Web Users if no username is provided.
Returns $null if the specified Web User is not found (401 or 404).

.PARAMETER Client
A GoAnywhere client object returned by New-GAClient.

.PARAMETER Username
The Web User's username. If omitted, retrieves all Web Users.

.EXAMPLE
Get-GAWebUser -Client $client -Username "user1"

.EXAMPLE
Get-GAWebUser -Client $client
#>
function Get-GAWebUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][PSObject]$Client,
        [string]$Username
    )

    $baseUri = $Client.BaseUri.TrimEnd('/')

    $uri = if ($Username) { "$baseUri/webusers/$([System.Web.HttpUtility]::UrlEncode($Username))" } else { "$baseUri/webusers" }

    Write-Verbose "Requesting Web User data from $uri"

    try {
        $response = Invoke-WebRequest -Uri $uri -Method Get -Headers $Client.Header -ErrorAction Stop
        
        Write-Verbose "Received HTTP $($response.StatusCode) response"

        Write-Verbose "Response content length: $($response.Content.Length) bytes"

        [xml]$xmlResponse = $response.Content

        $users = @($xmlResponse.webUsers.webUser)

        if ($users.Count -eq 0) {
            Write-Verbose "No Web Users found."

            return $null
        }
        elseif ($users.Count -eq 1) {
            Write-Verbose "Found Web User '$Username'"

            return $users[0]
        }
        else {
            Write-Verbose "Found $($users.Count) Web Users"

            return $users
        }
    }
    catch {
        $statusCode = $null
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            try { $statusCode = [int]$_.Exception.Response.StatusCode } catch {}
        }

        Write-Verbose "Caught exception. Status code: $statusCode. Message: $($_.Exception.Message)"

        if ($statusCode -in 401,404) {
            Write-Verbose "Web User '$Username' not found (401/404). Returning `$null."
            
            return $null
        }

        throw "Failed to retrieve Web User(s): $($_.Exception.Message)"
    }
}
