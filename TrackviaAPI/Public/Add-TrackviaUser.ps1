function Add-TrackviaUser {
    <#
        .SYNOPSIS
            Get a list of Objects that include the information in the Manage Users view on Trackvia.
        .DESCRIPTION
            This function wraps the Post request for users from the Trackvia API. This requires a SuperAdmin API user to call. 
        .LINK
            https://developer.trackvia.com/api-development/swagger
            https://github.com/AlixeT/TrackviaAPI
            https://trackvia.com/
        .NOTES
            Info
            Author: Alixe Taylor
            Date: 06/03/2024
            Version 0.1
            Last Revision: 06/03/2024
            Changelog:
            N/A
        .PARAMETER Bearer
            Auth Token from Trackvia Account under API Access. Must be passed as a secure string.
        .PARAMETER Key
            API Key from Trackvia Account under API Access.
        .PARAMETER BaseUrl
            Base URL for your account's Trackvia Access. 
            Default:
            https://go.trackvia.com/openapi
            Custom:
            https://{domain}/openapi
        .PARAMETER UserEmail
            Email Address of user to add.
        .PARAMETER FirstName
            First Name of user to add.
        .PARAMETER LastName
            Last Name of user to add.
        .PARAMETER TimeZone
            Optional string to add TimeZone to user.

            
    #>
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [securestring] $Bearer,
        [Parameter(Mandatory=$true)]
        [string] $Key,
        [Parameter()]
        [string] $BaseUrl='https://go.trackvia.com/openapi',
        [Parameter(Mandatory=$true)]
        [string] $UserEmail,
        [Parameter(Mandatory=$true)]
        [string] $FirstName,
        [Parameter(Mandatory=$true)]
        [string] $LastName,
        [string] $TimeZone
    )
    $resource = 'users'
    $Method = 'POST'
    $Bearer = ConvertFrom-SecureString -SecureString $Bearer -AsPlainText
    $Headers = @{
        'accept'='application/json'
        'Authorization' = "Bearer $Bearer"
        'Content-Type' = 'application/x-www-form-urlencoded'
    }
    $UserEmail.Replace('@','%40')
    if (!$TimeZone){
        $TimeZone = ''
    }
    $Body = "email=$UserEmail&firstName=$FirstName&lastName=$LastName&timeZone=$TimeZone"
    $userKey = "?user_key=$Key"
    $uri = $Baseurl + $resource + $userKey
    try{
        $response = Invoke-RestMethod -Uri $uri -Method $Method -Headers $Headers -Body $Body
        return $response
    }
    catch{
        if ($_.code -eq "409"){
            Write-Error 'Conflict, User Email is probably already used. Check Manage Users view in your Trackvia Account.'
        }
        elseif ($_.code -eq "400") {
            Write-Error 'Bad Request, either incorrect parameters or Trackvia is unreachable.'
        }
        elseif ($_.code -eq "404") {
            Write-Error 'Not Found, Your account was not found.'
        }
        else{
            $eMessage=$_.message
            $eName=$_.name
            Write-Error "Undocumented Error: Name:$eName Message:$eMessage"
        }
    }
}