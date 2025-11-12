# PSGoAnywhere

**PSGoAnywhere** is a PowerShell module for managing [Fortra GoAnywhere MFT](https://www.goanywhere.com/) via its REST API.  
It provides cmdlets for creating, retrieving, updating, and removing Web Users, making automation of GoAnywhere user management simple and efficient.

## Installation

You can install **PSGoAnywhere** directly from the [PowerShell Gallery](https://www.powershellgallery.com/packages/PSGoAnywhere) using:

```powershell
Install-Module -Name PSGoAnywhere
```

To update an existing installation:

```powershell
Update-Module -Name PSGoAnywhere
```

## Prerequisites

- PowerShell 7.0 or newer
- GoAnywhere MFT server with REST API enabled
- API username and API key

Set credentials as environment variables:
```
$env:GOANYWHERE_API_USERNAME = "your-api-username"
$env:GOANYWHERE_API_KEY = "your-api-key"
```
## Getting Started

### Create GoAnywhere Client

Create a client object to authenticate with the GoAnywhere REST API:

```powershell
$client = New-GAClient -ApiUsername "apiuser" -ApiKey "YourApiKey" -BaseUri "https://server.example.com:8001/goanywhere/rest/gacmd/v1"
```
Optionally, test the connection:

```powershell
$client = New-GAClient -ApiUsername "apiuser" -ApiKey "YourApiKey" -BaseUri "https://server.example.com:8001/goanywhere/rest/gacmd/v1" -TestConnection
```

### Web User Management

#### Retrieve a Web User

Retrieve one or all Web Users.

```powershell
Get-GAWebUser -Client $client -Username "user1"
Get-GAWebUser -Client $client
```

#### Create a new Web User

Create a new Web User.

```powershell
New-GAWebUser -Client $client -Username "user1" -FirstName "John" -LastName "Doe" -Email "user1@example.com" -Organization "IT"
```

#### Update an existing Web User

Update an existing Web User.

```powershell
Set-GAWebUser -Client $client -Username "user1" -Properties @{organization="IT" phone="555-1234"}
```

#### Remove a Web User

Delete a Web User.

```powershell
Remove-GAWebUser -Client $client -Username "user1"
```

## Cmdlets

| Cmdlet             | Description                                                |
| ------------------ | ---------------------------------------------------------- |
| `New-GAClient`     | Creates a GoAnywhere client object for API authentication. |
| `Get-GAWebUser`    | Retrieves one or more GoAnywhere Web Users.                |
| `New-GAWebUser`    | Creates a new GoAnywhere Web User.                         |
| `Set-GAWebUser`    | Updates properties of a GoAnywhere Web User.               |
| `Remove-GAWebUser` | Deletes a GoAnywhere Web User.                             |


## Best Practices
- Use `-Verbose` during testing for detailed request/response logging.
- Prefer environment variables for API credentials to avoid exposing secrets.
- Use `Get-GAWebUser` to confirm Web User existence before updating or removing.