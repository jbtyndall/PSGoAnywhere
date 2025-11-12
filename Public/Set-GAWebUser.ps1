<#
.SYNOPSIS
Updates attributes of a GoAnywhere Web User.

.DESCRIPTION
Performs a PUT request to modify Web User properties such as first name, last name, organization, phone, or enabled status.
Returns $null on success.

.PARAMETER Client
A GoAnywhere client object returned by New-GAClient.

.PARAMETER Username
The Web User's username.

.PARAMETER Properties
A hashtable of fields to update, e.g. @{ firstName='John'; phone='555-1234' }.

Common properties include firstName, lastName, email, description, organization, phoneNumber, enabled

.EXAMPLE
Set-GAWebUser -Client $client -Username "user1" -Properties @{ organization="Example Org"; phone="555-1111" }

.EXAMPLE
Set-GAWebUser -Client $client -Username "user1" -Properties @{ isEnabled=$true }
#>
function Set-GAWebUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][PSObject]$Client,
        [Parameter(Mandatory)][string]$Username,
        [Parameter(Mandatory)][hashtable]$Properties
    )

    # The 'userName' field is required for updates."
    if (-not $Properties.ContainsKey("userName")) {
        $Properties["userName"] = $Username
    }

    $body = $Properties | ConvertTo-Json -Depth 2

    $uri = "$($Client.BaseUri.TrimEnd('/'))/webusers/$([System.Web.HttpUtility]::UrlEncode($Username))"

    Write-Verbose "Updating Web User '$Username' at $uri"

    Write-Verbose "Payload: $body"

    try {
        $response = Invoke-WebRequest -Uri $uri -Method Put -Headers $Client.Header -Body $body -ContentType "application/json" -ErrorAction Stop

        Write-Verbose "Received HTTP $($response.StatusCode) response"

        Write-Verbose "Response content length: $($response.Content.Length) bytes"

        if ($response.Content) {
            [xml]$xmlResponse = $response.Content

            $users = @($xmlResponse.webUsers.webUser)

            if ($users.Count -eq 1) { return $users[0] }

            return $users
        }

        return $null
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

        throw "Failed to update Web User '$Username': $($_.Exception.Message)"
    }
}