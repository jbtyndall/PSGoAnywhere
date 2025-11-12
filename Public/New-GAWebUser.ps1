<#
.SYNOPSIS
Creates a new GoAnywhere Web User.

.DESCRIPTION
Performs a POST request to add a new Web User. 
Returns $true if successful, $false otherwise.

.PARAMETER Client
A GoAnywhere client object returned by New-GAClient.

.PARAMETER Username
The username for the new Web User.

.PARAMETER FirstName
Optional first name of the user.

.PARAMETER LastName
Optional last name of the user.

.PARAMETER Email
Optional email address of the user.

.PARAMETER Organization
Optional organization or department name.

.PARAMETER Phone
Optional phone number.

.PARAMETER Template
Optional Web User template name. Defaults to built-in "Web User Template".

.EXAMPLE
New-GAWebUser -Client $client -Username "jdoe" -FirstName "John" -LastName "Doe" -Email "jdoe@example.com"

.EXAMPLE
New-GAWebUser -Client $client -Username "jdoe" -FirstName "John" -LastName "Doe" -Email "jdoe@example.com" -Organization "Example Org"
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

        if ($response.StatusCode -in 200,201) { 
            Write-Verbose "Successfully created Web User '$Username'."

            return $true
        } else {
            Write-Verbose "Unexpected status code $($response.StatusCode). Returning `$false."

            return $false
        }
    }
    catch {
        $statusCode = $null
        
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode) {
            try { $statusCode = [int]$_.Exception.Response.StatusCode } catch {}
        }

        Write-Verbose "Caught exception. Status code: $statusCode. Message: $($_.Exception.Message)"

        switch ($statusCode) {
            400 { Write-Verbose "Web User '$Username' already exists."; return $false }
            401 { Write-Verbose "Unauthorized. Check credentials."; return $false }
            404 { Write-Verbose "Endpoint not found."; return $false }
            default { throw "Failed to create Web User '$Username': $($_.Exception.Message)" }
    }

        throw "Failed to create Web User '$Username': $($_.Exception.Message)"
    }
}
