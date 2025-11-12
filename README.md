# PSGoAnywhere
PowerShell module for interacting with Fortra GoAnywhere MFT.

## Prerequisites

- PowerShell 7.0 or newer
- GoAnywhere MFT server with REST API enabled
- API username and API key

Set credentials as environment variables:
```
$env:GOANYWHERE_API_USERNAME = "your-api-username"
$env:GOANYWHERE_API_KEY = "your-api-key"
```

## Cmdlets

### `New-GAClient`

Creates a GoAnywhere client object for API calls.

```powershell
$client = New-GAClient -BaseUri "https://server.example.com:8001/goanywhere/rest/gacmd/v1" -TestConnection
```

### `Get-GAWebUser`

Retrieve one or all Web Users.

```powershell
Get-GAWebUser -Client $client -Username "user1"
Get-GAWebUser -Client $client
```

### `New-GAWebUser`

Create a new Web User.

```powershell
New-GAWebUser -Client $client -Username "user1" -FirstName "John" -LastName "Doe" -Email "user1@example.com" -Organization "IT"
```

### `Set-GAWebUser`

Update an existing Web User.

```powershell
Set-GAWebUser -Client $client -Username "user1" -Properties @{organization="IT" phone="555-1234"}
```

### `Remove-GAWebUser`

Delete a Web User.

```powershell
Remove-GAWebUser -Client $client -Username "user1"
```

## Best Practices
- Use `-Verbose` during testing for detailed request/response logging.
- Prefer environment variables for API credentials to avoid exposing secrets.
- Use `Get-GAWebUser` to confirm Web User existence before updating or removing.