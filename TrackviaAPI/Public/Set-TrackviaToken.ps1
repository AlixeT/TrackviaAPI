function Set-TrackviaToken{
    [CmdletBinding()]
    param (
        [Parameter()]
        [securestring]
        $Token,
        [SwitchParameter]
        $Admin
    )
    Try{
        if (!$Token){
            Write-Output "Please enter your Auth Token from API Access on Trackvia."
            $Token = Read-Host -AsSecureString
        }
        if (!$Admin){
            Write-Verbose "Auth Token Set."
            $ApiVariables.Bearer = $Token
        }else{
            Write-Verbose "Admin Auth Token Set."
            $ApiVariables.AdminBearer = $Token
            if ($null -eq $ApiVariables.Bearer){
                Write-Verbose "Non-Admin Auth Token not set. Setting Both Auth Tokens to defined Auth Token. To change Non-Admin Auth Token call Set-TrackviaToken without -Admin switch."
                $ApiVariables.Bearer = $Token
            }
        }
    }
    catch{
        Write-Error $_
    }
}
