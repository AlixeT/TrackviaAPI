function Get-TrackviaUsers {
    <#
        .SYNOPSIS
            Get a list of Objects that include the information in the Manage Users view on Trackvia.
        .DESCRIPTION
            This function wraps the GET request for users from the Trackvia API. This requires a SuperAdmin API user to call. This function by default returns the 50 newest users.
            Parameters for users per page and page number are provided.
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
        .PARAMETER UsersPerPage
            Number of users per page to return.
            Default:
            50
        .PARAMETER PageNumber
            Page number to return.
            Default:
            1
        .EXAMPLE
            Get-TrackviaUsers -Bearer $Bearer -Key $Key -PageNumber 3
            Retrieves the users 100-150 ordered by newest addition.
        .EXAMPLE
            Get-TrackviaUsers -Bearer $Bearer -Key $Key -UsersPerPage 500
            Retrieves the newest 500 users.
            
    #>
    [CmdletBinding()]
    param (
        [Parameter()]
        [securestring] $Bearer,
        [string] $Key,
        [string] $BaseUrl,
        [Int32] $UsersPerPage,
        [Int32] $PageNumber
    )
    $resource = 'users'
    $query='?'
    if ($PageNumber){
        $query += "start=$PageNumber&"
    }
    if ($UsersPerPage){
        $query += "max=$UsersPerPage&"
    }
    $userKey = "user_key=$Key"
    $uri = $Baseurl + $resource + $query + $userKey
    try{
        $response = Invoke-RestMethod -Uri $uri -Authentication Bearer -Token $Bearer
        return $response
    }
    catch{
        if ($_.code -eq "401"){
            Write-Error 'Access Denied, this function requires a SuperAdmin Bearer Token.'
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