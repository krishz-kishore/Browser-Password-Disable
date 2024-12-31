# Step 1: Detect Installed Browsers
Write-Host "Step 1: Detecting installed browsers on this computer..." -ForegroundColor Cyan

# Function to get installed programs from registry paths
function Get-InstalledApplicationsFromRegistry {
    param (
        [string]$RegistryPath
    )
    Get-ItemProperty -Path $RegistryPath |
        Select-Object -Property DisplayName, DisplayVersion |
        Where-Object { $_.DisplayName -ne $null } |
        ForEach-Object {
            [PSCustomObject]@{
                Name    = $_.DisplayName
                Version = $_.DisplayVersion
            }
        }
}

# Function to get installed Microsoft Store apps using Get-AppxPackage
function Get-InstalledStoreApps {
    Get-AppxPackage |
        Select-Object Name, Version |
        ForEach-Object {
            [PSCustomObject]@{
                Name    = $_.Name
                Version = $_.Version
            }
        }
}

# Combine results from registry paths and Microsoft Store apps
$installedApplications = @()
$registryPaths = @(
    "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*",
    "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*"
)

foreach ($path in $registryPaths) {
    $installedApplications += Get-InstalledApplicationsFromRegistry -RegistryPath $path
}

# Get installed Microsoft Store apps using Get-AppxPackage
$installedApplications += Get-InstalledStoreApps

# Remove duplicates and sort applications
$installedApplications = $installedApplications | Sort-Object Name -Unique

# Step 2: Exclude Edge-related components
$installedApplications = $installedApplications | Where-Object {
    $_.Name -notmatch "WebView2|S/MIME|DevTools|MicrosoftEdge"
}

# Step 3: Browser detection patterns (case-insensitive)
$browserPatterns = @(
    "chrom",    # Matches Chrome
    "brave",    # Matches Brave
    "firefox",  # Matches Firefox
    "opera",    # Matches Opera
    "safari"    # Matches Safari
)

# Step 4: Filter applications for browsers using pattern matching
$detectedBrowsers = $installedApplications | Where-Object {
    $match = $false
    foreach ($pattern in $browserPatterns) {
        if ($_.Name -match $pattern) {
            $match = $true
            break
        }
    }
    $match
}

# Step 5: Display only the detected browsers
if ($detectedBrowsers.Count -eq 0) {
    Write-Host "No popular browsers were detected on this computer." -ForegroundColor Yellow
} else {
    Write-Host "The following browsers are installed:" -ForegroundColor Green
    $detectedBrowsers | ForEach-Object { Write-Host "$($_.Name) - Version: $($_.Version)" }
}

# Step 6: Ask the user if they want to disable password saving in any browser
$disablePasswordSaving = Read-Host "Would you like to disable password saving in any browser? (Yes/No)"

if ($disablePasswordSaving -eq "Yes") {

    # Step 7: Prompt user to select browsers to disable password saving
    Write-Host "Step 7: Select the browsers to disable password saving (type numbers separated by commas):"
    Write-Host "1. Google Chrome"
    Write-Host "2. Brave"
    Write-Host "3. Mozilla Firefox"
    Write-Host "4. Microsoft Edge"
    Write-Host "5. Opera"
    
    $selectedBrowsers = Read-Host "Enter browser numbers (e.g., 1, 3, 4)".Split(",")

    # Step 8: Disable password saving based on user input
    foreach ($browser in $selectedBrowsers) {
        switch ($browser.Trim()) {
            "1" {
                # Disable password saving in Chrome
                Write-Host "Disabling password saving in Google Chrome..." -ForegroundColor Cyan
                New-Item -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Force
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Google\Chrome" -Name "PasswordManagerEnabled" -Value 0 -PropertyType DWord -Force
                Write-Host "Password saving disabled in Google Chrome." -ForegroundColor Green
                break
            }
            "2" {
                # Disable password saving in Brave (using Chromium registry path)
                Write-Host "Disabling password saving in Brave..." -ForegroundColor Cyan
                New-Item -Path "HKLM:\SOFTWARE\Policies\Chromium" -Force
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Chromium" -Name "PasswordManagerEnabled" -Value 0 -PropertyType DWord -Force
                Write-Host "Password saving disabled in Brave." -ForegroundColor Green
                break
            }
            "3" {
                # Disable password saving in Firefox
                Write-Host "Disabling password saving in Mozilla Firefox..." -ForegroundColor Cyan
                New-Item -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox" -Force
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Mozilla\Firefox" -Name "signon.rememberSignons" -Value "false" -PropertyType String -Force
                Write-Host "Password saving disabled in Mozilla Firefox." -ForegroundColor Green
                break
            }
            "4" {
                # Disable password saving in Microsoft Edge
                Write-Host "Disabling password saving in Microsoft Edge..." -ForegroundColor Cyan
                New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Force
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "PasswordManagerEnabled" -Value 0 -PropertyType DWord -Force
                Write-Host "Password saving disabled in Microsoft Edge." -ForegroundColor Green
                break
            }
            "5" {
                # Disable password saving in Opera
                Write-Host "Disabling password saving in Opera..." -ForegroundColor Cyan
                New-Item -Path "HKLM:\SOFTWARE\Policies\Opera Software" -Force
                New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Opera Software" -Name "PasswordManagerEnabled" -Value 0 -PropertyType DWord -Force
                Write-Host "Password saving disabled in Opera." -ForegroundColor Green
                break
            }
            default {
                Write-Host "Invalid option selected. Skipping..." -ForegroundColor Red
            }
        }
    }

    Write-Host "Password saving has been disabled for selected browsers." -ForegroundColor Green
} else {
    Write-Host "No changes were made to password saving settings." -ForegroundColor Yellow
}
