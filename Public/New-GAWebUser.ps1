<#
.SYNOPSIS
Creates a new GoAnywhere Web User.

.DESCRIPTION
Performs a POST request to add a new Web User using a template. 
Returns $null on success.

.PARAMETER Client
A GoAnywhere client object returned by New-GAClient.

.PARAMETER Username
The username for the new Web User.

.PARAMETER FirstName
First name of the user.

.PARAMETER LastName
Last name of the user.

.PARAMETER Email
Email address of the user.

.PARAMETER Organization
The organization or department name.

.PARAMETER Phone
Optional phone number.

.PARAMETER Template
Optional Web User template name. Defaults to built-in "Web User Template".

.EXAMPLE
New-GAWebUser -Client $client -Username "jdoe" -FirstName "John" -LastName "Doe" -Email "jdoe@example.com"

.EXAMPLE
New-GAWebUser -Client $client -Username "jdoe" -FirstName "John" -LastName "Doe" -Email "jdoe@example.com" -Organization "ARL"
#>
function New-GAWebUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)][PSObject]$Client,
        [Parameter(Mandatory)][string]$Username,
        [string]$FirstName,
        [string]$LastName,
        [string]$Email,
        [string]$Organization,
        [string]$Phone,
        [string]$Template = "Web User Template"
    )

    $body = @{
        addParameters = @{
            username     = $Username
            template     = $Template
            firstName    = $FirstName
            lastName     = $LastName
            email        = $Email
            organization = $Organization
            phone        = $Phone
        }
    } | ConvertTo-Json -Depth 2

    $uri = "$($Client.BaseUri.TrimEnd('/'))/webusers"

    Write-Verbose "Creating Web User '$Username' at $uri"
    
    Write-Verbose "Payload: $body"

    try {
        $response = Invoke-WebRequest -Uri $uri -Method Post -Headers $Client.Header -Body $body -ContentType "application/json" -ErrorAction Stop

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
            Write-Verbose "Web User '$Username' not found or creation failed (401/404). Returning `$null."
            return $null
        }

        throw "Failed to create Web User '$Username': $($_.Exception.Message)"
    }
}
