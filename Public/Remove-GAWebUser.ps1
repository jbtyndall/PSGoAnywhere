<#
.SYNOPSIS
Removes a GoAnywhere Web User.

.DESCRIPTION
Performs a DELETE request to remove a Web User by username.
Returns $true if successful, $false otherwise.

.PARAMETER Client
A GoAnywhere client object returned by New-GAClient.

.PARAMETER Username
The Web User's username to delete.

.EXAMPLE
Remove-GAWebUser -Client $client -Username "user1"

#>
function Remove-GAWebUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][PSObject]$Client,
        [Parameter(Mandatory)][string]$Username
    )

    $baseUri = $Client.BaseUri.TrimEnd('/')

    $uri = "$baseUri/webusers/$([System.Web.HttpUtility]::UrlEncode($Username))"

    Write-Verbose "Deleting Web User '$Username' at $uri"

    try {
        $response = Invoke-WebRequest -Uri $uri -Method Delete -Headers $Client.Header -ErrorAction Stop

        Write-Verbose "Received HTTP $($response.StatusCode) response"

        return $true
    }
    catch {
        $statusCode = $null

        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            try { $statusCode = [int]$_.Exception.Response.StatusCode } catch {}
        }

        Write-Verbose "Caught exception. Status code: $statusCode. Message: $($_.Exception.Message)"

        if ($statusCode -in 401,404) {
            Write-Verbose "Web User '$Username' not found (401/404). Nothing to delete."
            return $null
        }

        throw "Failed to delete Web User '$Username': $($_.Exception.Message)"
    }
}
