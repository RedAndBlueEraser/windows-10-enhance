@ECHO OFF

REM windows-10-privacy-and-control-enhance.bat
REM Written by Harry Wong (RedAndBlueEraser)

REM Usage: windows-10-privacy-and-control-enhance.bat [options]
REM
REM Options:
REM   -h, -Help               Display this help message.
REM   -EditGroupPolicies      Edit Group Policies (via the registry) in addition to
REM                           just toggling settings. This prevents the user from
REM                           being able to toggle some settings through the UI.
REM                           Precaution should be taken when using this option in
REM                           conjunction with higher optimisation levels.
REM                           Some tweaks are only available by editing Group
REM                           Policies while some settings are not controlled by
REM                           any Group Policy.
REM   -AggressiveOptimization By default, the standard optimisation only changes
REM                           settings that should not impact any functionality.
REM                           For example: turning off telemetry data collection,
REM                           disabling advertising elements, and tightening
REM                           privacy controls. Aggressive optimisation goes
REM                           further by turning off privacy intrusive, yet
REM                           unlikely to be useful, features.

SETLOCAL
SETLOCAL ENABLEEXTENSIONS

:: Command line arguments.
FOR %%a IN (%*) DO (
  IF /I %%a == -h GOTO help
  IF /I %%a == -Help GOTO help
  IF /I %%a == -EditGroupPolicies SET EDITGROUPPOLICIES=1
  IF /I %%a == -AggressiveOptimization SET AGGRESSIVEOPTIMIZATION=1
  IF /I %%a == -AggressiveOptimisation SET AGGRESSIVEOPTIMIZATION=1
)

:: Main
REM Settings
REM   System
REM     Notifications & actions
REM       Show me the Windows welcome experience... > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-310093Enabled /t REG_DWORD /d 0 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Cloud Content\Turn off the Windows Welcome Experience > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightWindowsWelcomeExperience /t REG_DWORD /d 1 /f

REM       Get tips, tricks, and suggestions... > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SoftLandingEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338389Enabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Cloud Content\Do not show Windows tips > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableSoftLanding /t REG_DWORD /d 1 /f

REM     Shared experiences
REM       Let apps on other devices (including linked phones and tablets) open and message... > Off
REM       I can share or receive from > My devices only
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\SmartGlass" /v UserAuthPolicy /t REG_DWORD /d 0 /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v CdpSessionUserAuthzPolicy /t REG_DWORD /d 1 /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v NearShareChannelUserAuthzPolicy /t REG_DWORD /d 1 /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP" /v RomeSdkChannelUserAuthzPolicy /t REG_DWORD /d 0 /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\CDP\SettingsPage" /v RomeSdkChannelUserAuthzPolicy /t REG_DWORD /d 1 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\System\Group Policy\Continue experiences on this device > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableCdp /t REG_DWORD /d 0 /f

REM   Devices
REM     Pen & Windows Ink
REM       Show recommended app suggestions > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\PenWorkspace" /v PenWorkspaceAppSuggestionsEnabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Windows Ink Workspace\Allow suggested apps in Windows Ink Workspace > Disabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v AllowSuggestedAppsInWindowsInkWorkspace /t REG_DWORD /d 0 /f

REM   Network & Internet
REM     Wi-Fi
REM       Connect to suggested open hotspots > Off
REM       Connect to networks shared by my contacts > Off
REM         (Group Policy > Computer Configuration\Administrative Templates\Network\WLAN Service\WLAN Settings\Allow Windows to automatically connect to suggested open hotspots, to networks shared by contacts, and to hotspots offering paid services > Disabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v value /t REG_DWORD /d 0 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v value /t REG_DWORD /d 0 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v AutoConnectAllowedOEM /t REG_DWORD /d 0 /f

REM   Personalization
REM     Lock screen
REM       Background > Picture
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenEnabled /t REG_DWORD /d 0 /f
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Lock Screen\Creative" /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Cloud Content\Turn off all Windows spotlight features > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightFeatures /t REG_DWORD /d 1 /f

REM       Get fun facts, tips, and more... > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v RotatingLockScreenOverlayEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338387Enabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Control Panel\Personalization\Force a specific default lock screen image > Turn off fun facts, tips, tricks, and more on lock screen)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Personalization" /v LockScreenOverlaysDisabled /t REG_DWORD /d 1 /f

REM     Start
REM       Occasionally show suggestions in Start > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SystemPaneSuggestionsEnabled /t REG_DWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338388Enabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Cloud Content\Turn off Microsoft consumer experiences > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f

REM   Apps
REM     Apps & features
REM       3D Builder > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.3DBuilder\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.3DBuilder | Remove-AppxPackage"
REM       Alarms & Clock > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsAlarms\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.WindowsAlarms | Remove-AppxPackage"
REM       App Connector > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Appconnector\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.Appconnector | Remove-AppxPackage"
REM       App Installer > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.DesktopAppInstaller\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.DesktopAppInstaller | Remove-AppxPackage"
REM       Asphalt 8: Airborne > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Asphalt8Airborne\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Asphalt8Airborne | Remove-AppxPackage"
REM       Calculator > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsCalculator\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.WindowsCalculator | Remove-AppxPackage"
REM       Camera > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsCamera\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.WindowsCamera | Remove-AppxPackage"
REM       Candy Crush Soda Saga > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*king.com.CandyCrushSodaSaga*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *king.com.CandyCrushSodaSaga* | Remove-AppxPackage"
REM       Connect > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.PPIProjection\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.PPIProjection | Remove-AppxPackage"
REM       Drawboard PDF > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.DrawboardPDF\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.DrawboardPDF | Remove-AppxPackage"
REM       Facebook > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*Facebook*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *Facebook* | Remove-AppxPackage"
REM       Fallout Shelter > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*BethesdaSoftworks.FalloutShelter*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *BethesdaSoftworks.FalloutShelter* | Remove-AppxPackage"
REM       FarmVille 2: Country Escape > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*FarmVille2CountryEscape*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *FarmVille2CountryEscape* | Remove-AppxPackage"
REM       Feedback Hub > Uninstall
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsFeedbackHub\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
PowerShell -Command "Get-AppxPackage Microsoft.WindowsFeedbackHub | Remove-AppxPackage"
REM       Get Help > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.GetHelp\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.GetHelp | Remove-AppxPackage"
REM       Get Office > Uninstall
PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.MicrosoftOfficeHub\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
PowerShell -Command "Get-AppxPackage Microsoft.MicrosoftOfficeHub | Remove-AppxPackage"
REM       Groove Music > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.ZuneMusic\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.ZuneMusic | Remove-AppxPackage"
REM       Mail and Calendar > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"microsoft.windowscommunicationsapps\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage microsoft.windowscommunicationsapps | Remove-AppxPackage"
REM       Maps > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsMaps\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.WindowsMaps | Remove-AppxPackage"
REM       Messaging > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Messaging\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.Messaging | Remove-AppxPackage"
REM       Microsoft Edge > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.MicrosoftEdge\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.MicrosoftEdge | Remove-AppxPackage"
REM       Microsoft Solitaire Collection > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.MicrosoftSolitaireCollection\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.MicrosoftSolitaireCollection | Remove-AppxPackage"
REM       Microsoft Store > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsStore\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.WindowsStore | Remove-AppxPackage"
REM       Microsoft Wallet > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*Wallet*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage *Wallet* | Remove-AppxPackage"
REM       Microsoft Wi-Fi > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.ConnectivityStore\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.ConnectivityStore | Remove-AppxPackage"
REM       Minecraft > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*MinecraftUWP*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *MinecraftUWP* | Remove-AppxPackage"
REM       Mixed Reality Viewer > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Microsoft3DViewer\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage"
REM       Mixed Reality Portal > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Windows.HolographicFirstRun\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.Windows.HolographicFirstRun | Remove-AppxPackage"
REM       Money > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.BingFinance\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.BingFinance | Remove-AppxPackage"
REM       Movies & TV > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.ZuneVideo\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.ZuneVideo | Remove-AppxPackage"
REM       Netflix > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*Netflix*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *Netflix* | Remove-AppxPackage"
REM       News > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.BingNews\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.BingNews | Remove-AppxPackage"
REM       OneDrive > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION %SystemRoot%\System32\OneDriveSetup.exe /Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION %SystemRoot%\SysWOW64\OneDriveSetup.exe /Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION RMDIR C:\OneDriveTemp /S /Q
IF DEFINED AGGRESSIVEOPTIMIZATION RMDIR %USERPROFILE%\OneDrive /S /Q
IF DEFINED AGGRESSIVEOPTIMIZATION RMDIR %LOCALAPPDATA%\Microsoft\OneDrive /S /Q
IF DEFINED AGGRESSIVEOPTIMIZATION RMDIR "%ProgramData%\Microsoft OneDrive" /S /Q
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCR\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v Attributes /t REG_DWORD /d 0 /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCR\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}\ShellFolder" /v Attributes /t REG_DWORD /d 0 /f
REM       OneNote > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Office.OneNote\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Office.OneNote | Remove-AppxPackage"
REM       Paid Wi-Fi & Cellular > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.OneConnect\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.OneConnect | Remove-AppxPackage"
REM       Paint 3D > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.MSPaint\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.MSPaint | Remove-AppxPackage"
REM       Pandora > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*PandoraMediaInc*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *PandoraMediaInc* | Remove-AppxPackage"
REM       People > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.People\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.People | Remove-AppxPackage"
REM       Phone > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.CommsPhone\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.CommsPhone | Remove-AppxPackage"
REM       Phone Companion > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*windowsphone*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage *windowsphone* | Remove-AppxPackage"
REM       Photos > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Windows.Photos\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.Windows.Photos | Remove-AppxPackage"
REM       Print 3D > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Print3D\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.Print3D | Remove-AppxPackage"
REM       Royal Revolt 2 > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*flaregamesGmbH.RoyalRevolt2*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *flaregamesGmbH.RoyalRevolt2* | Remove-AppxPackage"
REM       Scan > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*WindowsScan*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage *WindowsScan* | Remove-AppxPackage"
REM       Skype > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.SkypeApp\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.SkypeApp | Remove-AppxPackage"
REM       Sports > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.BingSports\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.BingSports | Remove-AppxPackage"
REM       Sticky Notes > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.MicrosoftStickyNotes\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.MicrosoftStickyNotes | Remove-AppxPackage"
REM       Sway > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Office.Sway\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Office.Sway | Remove-AppxPackage"
REM       Tips > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Getstarted\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Getstarted | Remove-AppxPackage"
REM       Twitter > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*Twitter*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *Twitter* | Remove-AppxPackage"
REM       Voice Recorder > Uninstall
:: PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsSoundRecorder\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
:: PowerShell -Command "Get-AppxPackage Microsoft.WindowsSoundRecorder | Remove-AppxPackage"
REM       View 3D > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Microsoft3DViewer\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Microsoft3DViewer | Remove-AppxPackage"
REM       Weather > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.BingWeather\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.BingWeather | Remove-AppxPackage"
REM       Windows Phone > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.WindowsPhone\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.WindowsPhone | Remove-AppxPackage"
REM       Windows Phone Connector > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Windows.Phone\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Windows.Phone | Remove-AppxPackage"
REM       Xbox > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.XboxApp\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.XboxApp | Remove-AppxPackage"
REM       Xbox Game Speech Windows > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.XboxSpeechToTextOverlay\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.XboxSpeechToTextOverlay | Remove-AppxPackage"
REM       Xbox Live > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"Microsoft.Xbox.TCUI\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage Microsoft.Xbox.TCUI | Remove-AppxPackage"
REM       Xbox One SmartGlass > Uninstall
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -Like \"*XboxOneSmartGlass*\"} | ForEach-Object { Remove-AppxProvisionedPackage -Online -PackageName $_.PackageName}"
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Get-AppxPackage *XboxOneSmartGlass* | Remove-AppxPackage"

REM     Offline maps
REM       Automatically update maps > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SYSTEM\Maps" /v AutoUpdateEnabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Maps\Turn off Automatic Download and Update of Map Data > Enabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v AutoDownloadAndUpdateMapData /t REG_DWORD /d 0 /f

REM   Accounts
REM     Sync your settings
REM       Sync settings > Off
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Sync your settings\Do not sync > Enabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSync /t REG_DWORD /d 2 /f
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\SettingSync" /v DisableSettingSyncUserOverride /t REG_DWORD /d 1 /f

REM   Privacy
REM     General
REM       Let apps use my advertising ID... > Off
REM         (Settings)
reg delete "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v Enabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\System\User Profiles\Turn off the advertising ID > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f

REM       Let websites provide locally relevant... > Off
REM         (Settings)
reg add "HKCU\Control Panel\International\User Profile" /v HttpAcceptLanguageOptOut /t REG_DWORD /d 1 /f

REM       Let Windows track app launches... > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v Start_TrackProgs /t REG_DWORD /d 0 /f

REM       Show me suggested content in the Settings app... > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v SubscribedContent-338393Enabled /t REG_DWORD /d 0 /f

REM     Location
REM       Location for this device > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SYSTEM\CurrentControlSet\Services\lfsvc\Service\Configuration" /v Status /t REG_DWORD /d 0 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Location and Sensors\Turn off location > Enabled)
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Location and Sensors\Turn off location > Enabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocation /t REG_DWORD /d 1 /f
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableLocation /t REG_DWORD /d 1 /f

REM       Location service > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v Value /t REG_SZ /d Deny /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Sensor\Permissions\{BFA794E4-F964-4FDB-90F6-51056BFE4B44}" /v SensorPermissionState /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access location > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessLocation /t REG_DWORD /d 2 /f

REM     Camera
REM       Let apps use my camera hardware > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E5323777-F976-4f5b-9B55-B94699C46E44}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access the camera > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessCamera /t REG_DWORD /d 2 /f

REM     Microphone
REM       Let apps use my microphone > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2EEF81BE-33FA-4800-9670-1CD474972C3F}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access the microphone > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessMicrophone /t REG_DWORD /d 2 /f

REM     Notifications
REM       Let apps access my notifications > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{52079E78-A92B-413F-B213-E8FE35712E72}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access notifications > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessNotifications /t REG_DWORD /d 2 /f

REM     Speech, inking, & typing
REM       Turn off speech services and typing suggestions
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\InputPersonalization\TrainedDataStore" /v HarvestContacts /t REG_DWORD /d 0 /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Personalization\Settings" /v AcceptedPrivacyPolicy /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Control Panel\Regional and Language Options\Allow input personalization > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v AllowInputPersonalization /t REG_DWORD /d 0 /f

REM     Account info
REM       Let apps access my name, picture, and other account info > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{C1D23ACC-752B-43E5-8448-8D0E519CD6D6}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access account information > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessAccountInfo /t REG_DWORD /d 2 /f

REM     Contacts
REM       Let apps access my contacts > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{7D7E8402-7C54-4821-A34E-AEEFD62DED93}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access contacts > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessContacts /t REG_DWORD /d 2 /f

REM     Calendar
REM       Let apps access my calendar > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{D89823BA-7180-4B81-B50C-7E471E6121A3}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access the calendar > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessCalendar /t REG_DWORD /d 2 /f

REM     Call history
REM       Let apps access my call history > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{8BC668CF-7728-45BD-93F8-CF2B3B41D7AB}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access call history > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessCallHistory /t REG_DWORD /d 2 /f

REM     Email
REM       Let apps access and send email > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{9231CB4C-BF57-4AF3-8C55-FDA7BFCC04C5}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access email > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessEmail /t REG_DWORD /d 2 /f

REM     Tasks
REM       > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{E390DF20-07DF-446D-B962-F5C953062741}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access Tasks > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessTasks /t REG_DWORD /d 2 /f

REM     Messaging
REM       Let apps read or send messages (text or MMS) > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{21157C1F-2651-4CC1-90CA-1F28B02263F6}" /v Value /t REG_SZ /d Deny /f
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{992AFA70-6F47-4148-B3E9-3003349C1548}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access messaging > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessMessaging /t REG_DWORD /d 2 /f

REM     Radios
REM       Let apps control radios > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{A8804298-2D5F-42E3-9531-9C8C39EB29CE}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps control radios > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessRadios /t REG_DWORD /d 2 /f

REM     Other devices
REM       Let your apps automatically share and sync info with... > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\LooselyCoupled" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps sync with devices > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsSyncWithDevices /t REG_DWORD /d 2 /f

REM     Feedback & diagnostics
REM       Select how much data you send to Microsoft > Security
REM         (Settings)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Data Collection and Preview Builds\Allow Telemetry > 0 - Security)
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Data Collection and Preview Builds\Allow Telemetry > 0 - Security)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

REM       Let Microsoft provide more tailored experiences...
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Privacy" /v TailoredExperiencesWithDiagnosticDataEnabled /t REG_DWORD /d 0 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Cloud Content\Do not use diagnostic data for tailored experiences > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableTailoredExperiencesWithDiagnosticData /t REG_DWORD /d 1 /f

REM       Windows should ask for my feedback > Never
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v PeriodInNanoSeconds /t REG_QWORD /d 0 /f
reg add "HKCU\SOFTWARE\Microsoft\Siuf\Rules" /v NumberOfSIUFInPeriod /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Data Collection and Preview Builds\Do not show feedback notifications > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f

REM     Background apps
REM       Let apps run in the background > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v GlobalUserDisabled /t REG_DWORD /d 1 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps run in the background > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsRunInBackground /t REG_DWORD /d 2 /f

REM     App diagnostics
REM       Let apps access diagnostic information
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\DeviceAccess\Global\{2297E4E2-5DBE-466D-A12B-0F8286F0D9CA}" /v Value /t REG_SZ /d Deny /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access diagnostic information about other apps > Disabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsGetDiagnosticInfo /t REG_DWORD /d 2 /f

REM   Update & Security
REM     Windows Update
REM       Advanced options
REM         Choose the branch readiness level... > Semi-Annual Channel
REM           (Settings)
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v InsiderProgramEnabled /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings" /v BranchReadinessLevel /t REG_DWORD /d 32 /f
REM           (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Windows Update\Windows Update for Business\Select when Preview Builds and Feature Updates are received > Semi-Annual Channel)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v BranchReadinessLevel /t REG_DWORD /d 32 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\Software\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdates /t REG_DWORD /d 1 /f

REM         Delivery Optimization
REM           Allow downloads from other PCs > On, PCs on my local network
REM             (Settings)
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Settings" /v DownloadMode /t REG_SZ /d 1 /f
REM             (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Delivery Optimization\Download Mode > LAN (1))
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" /v DODownloadMode /t REG_DWORD /d 1 /f

REM     Windows Defender
REM       Open Windows Defender Security Center
REM         Settings
REM           Virus & threat protection settings
REM             Cloud-delivered protection > Off
REM               (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION PowerShell -Command "Set-MpPreference -MAPSReporting Disabled"
REM               (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Windows Defender Antivirus\MAPS\Configure local setting override for reporting to Microsoft Active Protection Service (MAPS) > Disabled)
REM               (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Windows Defender Antivirus\MAPS\Join Microsoft MAPS > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v LocalSettingOverrideSpynetReporting /t REG_DWORD /d 0 /f
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SpyNetReporting /t REG_DWORD /d 0 /f

REM             Automatic sample submission
REM               (Settings)
PowerShell -Command "Set-MpPreference -SubmitSamplesConsent Never"
REM               (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Windows Defender Antivirus\MAPS\Send file samples when further analysis is required > Never Send)
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v SubmitSamplesConsent /t REG_DWORD /d 2 /f

REM     Find my device
REM       Find my device > Off
REM         (Settings)
IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Microsoft\Settings\FindMyDevice" /v LocationSyncEnabled /t REG_DWORD /d 0 /f
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Find My Device\Turn On/Off Find My Device > Disabled)
IF DEFINED AGGRESSIVEOPTIMIZATION IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\FindMyDevice" /v AllowFindMyDevice /t REG_DWORD /d 0 /f

REM     Windows Insider Program
REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Data Collection and Preview Builds\Toggle user control over Insider builds > Disabled)
:: This group policy seems to permanently disable to option to opt-in to Insider Preview Builds, even after it is disabled.
:: IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v AllowBuildPreview /t REG_DWORD /d 0 /f

REM Internet Explorer
REM   Internet Options
REM     Advanced
REM       Security\Send Do Not Track requests to sites... > On
REM         (Internet Options)
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Internet Explorer\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Internet Explorer\Internet Control Panel\Advanced Page\Always send Do Not Track header > Disabled)
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Internet Explorer\Internet Control Panel\Advanced Page\Always send Do Not Track header > Disabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Main" /v DoNotTrack /t REG_DWORD /d 1 /f

REM       Browsing\Enable Suggested Sites > Off
REM         (Internet Options)
reg add "HKCU\SOFTWARE\Microsoft\Internet Explorer\Suggested Sites" /v Enabled /t REG_DWORD /d 0 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Internet Explorer\Turn on Suggested Sites > Disabled)
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Internet Explorer\Turn on Suggested Sites > Disabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v Enabled /t REG_DWORD /d 0 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\Suggested Sites" /v Enabled /t REG_DWORD /d 0 /f

REM Microsoft Edge
REM   Settings
REM     View advanced settings
REM       Send Do Not Track requests > On
REM         (Settings)
reg add "HKCR\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
REM         (Group Policy > User Configuration\Administrative Templates\Windows Components\Microsoft Edge\Configure Do Not Track > Enabled)
REM         (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Microsoft Edge\Configure Do Not Track > Enabled)
IF DEFINED EDITGROUPPOLICIES reg add "HKCU\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v DoNotTrack /t REG_DWORD /d 1 /f
IF DEFINED EDITGROUPPOLICIES reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v DoNotTrack /t REG_DWORD /d 1 /f

REM File Explorer
REM   Folder Options
REM     View
REM       Hide extensions for known file types > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v HideFileExt /t REG_DWORD /d 0 /f
REM       Hide protected operating system files (Recommended) > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSuperHidden /t REG_DWORD /d 1 /f
REM       Show sync provider notifications > Off
REM         (Settings)
reg add "HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f

REM Additional Group Policies
IF DEFINED EDITGROUPPOLICIES (
  REM See https://docs.microsoft.com/en-us/windows/configuration/manage-connections-from-windows-operating-system-components-to-microsoft-services
  REM   Cortana and Search
  REM     Allow Cortana > Disabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Search\Allow Cortana > Disabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowCortana /t REG_DWORD /d 0 /f
  REM     Allow search and Cortana to use location > Disabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Search\Allow search and Cortana to use location > Disabled)
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v AllowSearchToUseLocation /t REG_DWORD /d 0 /f
  REM     Do not allow web search > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Search\Do not allow web search > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v DisableWebSearch /t REG_DWORD /d 1 /f
  REM     Don't search the web or display web results in Search > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Search\Don't search the web or display web results in Search > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchUseWeb /t REG_DWORD /d 0 /f
  REM     Set what information is shared in Search > Anonymous info
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Search\Set what information is shared in Search > Anonymous info)
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v ConnectedSearchPrivacy /t REG_DWORD /d 3 /f

  REM   Device metadata retrieval
  REM     Prevent device metadata retrieval from the Internet > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\System\Device Installation\Prevent device metadata retrieval from the Internet > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Device Metadata" /v PreventDeviceMetadataFromNetwork /t REG_DWORD /d 1 /f

  REM   Internet Explorer
  REM     Allow Microsoft services to provide enhanced suggestions as the user types in the Address Bar > Disabled
  REM       (Group Policy > User Configuration\Administrative Templates\Windows Components\Internet Explorer\Allow Microsoft services to provide enhanced suggestions as the user types in the Address Bar > Disabled)
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Internet Explorer\Allow Microsoft services to provide enhanced suggestions as the user types in the Address Bar > Disabled)
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer" /v AllowServicePoweredQSA /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer" /v AllowServicePoweredQSA /t REG_DWORD /d 0 /f

  REM   Live Tiles
  REM     Turn Off notifications network usage > Enabled
  REM       (Group Policy > User Configuration\Administrative Templates\Start Menu and Taskbar\Notifications\Turn Off notifications network usage > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CurrentVersion\PushNotifications" /v NoCloudApplicationNotification /t REG_DWORD /d 1 /f

  REM   Microsoft Account
  REM     Accounts: Block Microsoft Accounts > Users can't add Microsoft accounts
  REM       (Group Policy > Computer Configuration\Windows Settings\Security Settings\Local Policies\Security Options\Accounts: Block Microsoft Accounts > Users can't add Microsoft accounts)
  :: reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v NoConnectedUser /t REG_DWORD /d 3 /f
  :: reg add "HKLM\SYSTEM\CurrentControlSet\Services\wlidsvc" /v Start /t REG_DWORD /d 4 /f

  REM   Offline maps
  REM     Turn off unsolicited network traffic on the Offline Maps settings page > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Maps\Turn off unsolicited network traffic on the Offline Maps settings page > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Maps" /v AllowUntriggeredNetworkTrafficOnSettingsPage /t REG_DWORD /d 0 /f

  REM   OneDrive
  REM     Prevent the usage of OneDrive for file storage > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\OneDrive\Prevent the usage of OneDrive for file storage > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v DisableFileSyncNGSC /t REG_DWORD /d 1 /f
  REM     Prevent OneDrive from generating network traffic until the user signs in to OneDrive > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\OneDrive\Prevent OneDrive from generating network traffic until the user signs in to OneDrive > Enabled)
  reg add "HKLM\SOFTWARE\Microsoft\OneDrive" /v PreventNetworkTrafficPreUserSignIn /t REG_DWORD /d 1 /f

  REM   Speech, inking, & typing
  REM     Turn off automatic learning > Enabled
  REM       (Group Policy > User Configuration\Administrative Templates\Control Panel\Regional and Language Options\Handwriting personalization\Turn off automatic learning > Enabled)
  REM       (Group Policy > Computer Configuration\Administrative Templates\Control Panel\Regional and Language Options\Handwriting personalization\Turn off automatic learning > Enabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitInkCollection /t REG_DWORD /d 1 /f
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\InputPersonalization" /v RestrictImplicitTextCollection /t REG_DWORD /d 1 /f
  REM     Allow automatically update of Speech Data > Disabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Speech\Allow Automatic Update of Speech Data > Disabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Microsoft\Speech_OneCore\Preferences" /v ModelDownloadAllowed /t REG_DWORD /d 0 /f

  REM   Phone calls
  REM     Let Windows apps make phone calls > Disabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps make phone calls > Disabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessPhone /t REG_DWORD /d 2 /f

  REM   Motion
  REM     Let Windows apps access motion > Disabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\App Privacy\Let Windows apps access motion > Disabled)
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppPrivacy" /v LetAppsAccessMotion /t REG_DWORD /d 2 /f

  REM   Software Protection Platform
  REM     Turn off KMS Client Online AVS Validation > Enabled
  REM       (Group Policy > Computer Configuration\Administrative Templates\Windows Components\Software Protection Platform\Turn off KMS Client Online AVS Validation > Enabled)
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v NoGenTicket /t REG_DWORD /d 1 /f

  REM   Sync your settings
  REM     To turn off Messaging cloud sync
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKCU\SOFTWARE\Microsoft\Messaging" /v CloudServiceSyncEnabled /t REG_DWORD /d 0 /f

  REM   Malicious Software Removal Tool
  REM     Turn off Malicious Software Removal Tool telemetry
  reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v DontReportInfectionInformation /t REG_DWORD /d 1 /f

  REM More Group Policies
  REM   Telemetry related
  reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v CEIPEnable /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM" /v DisableCustomerImprovementProgram /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Internet Explorer\SQM" /v DisableCustomerImprovementProgram /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Messenger\Client" /v CEIP /t REG_DWORD /d 2 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Messenger\Client" /v CEIP /t REG_DWORD /d 2 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v AITEnable /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v DisableInventory /t REG_DWORD /d 1 /f

  REM   Error Reporting related
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v AllOrNone /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v DoReport /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v IncludeKernelFaults /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v IncludeMicrosoftApps /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v IncludeShutdownErrs /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting" /v IncludeWindowsApps /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v DWNoFileCollection /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\PCHealth\ErrorReporting\DW" /v DWNoSecondLevelCollection /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v DisableSendGenericDriverNotFoundToWER /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" /v DisableSendRequestAdditionalSoftwareToWER /t REG_DWORD /d 1 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v PreventHandwritingErrorReports /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\HandwritingErrorReports" /v PreventHandwritingErrorReports /t REG_DWORD /d 1 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v AutoApproveOSDumps /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v AutoApproveOSDumps /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v BypassDataThrottling /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v BypassDataThrottling /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v BypassNetworkCostThrottling /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v BypassNetworkCostThrottling /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v BypassPowerThrottling /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v BypassPowerThrottling /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v DontSendAdditionalData /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v DontSendAdditionalData /t REG_DWORD /d 1 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v DefaultConsent /t REG_DWORD /d 0 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v DefaultConsent /t REG_DWORD /d 0 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v DefaultOverrideBehavior /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting\Consent" /v DefaultOverrideBehavior /t REG_DWORD /d 1 /f

  REM   Windows Spotlight related
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableThirdPartySuggestions /t REG_DWORD /d 1 /f
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnActionCenter /t REG_DWORD /d 1 /f

  REM   Allow Message Service Cloud Sync > Disabled
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Messaging" /v AllowMessageSync /t REG_DWORD /d 0 /f

  REM   Allow Microsoft accounts to be optional > Enabled
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v MSAOptional /t REG_DWORD /d 1 /f

  REM   Allow Online Tips > Disabled
  reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v AllowOnlineTips /t REG_DWORD /d 0 /f

  REM   Configure Automatic Updates > Notify for download and auto install
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 2 /f
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v NoAutoUpdate /t REG_DWORD /d 0 /f

  REM   Disable pre-release features or settings > Disabled
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v EnableConfigFlighting /t REG_DWORD /d 0 /f
  IF DEFINED AGGRESSIVEOPTIMIZATION reg delete "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v EnableExperimentation /f

  REM   Enable/Disable PerfTrack > Disabled
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WDI\{9c5a40da-b965-4fc3-8781-88dd50a6299d}" /v ScenarioExecutionEnabled /t REG_DWORD /d 0 /f

  REM   Microsoft Support Diagnostic Tool: Turn on MSDT interactive communication with support provider > Disabled
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\ScriptedDiagnosticsProvider\Policy" /v DisableQueryRemoteServer /t REG_DWORD /d 0 /f

  REM   Prevent Media Sharing > Enabled
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\WindowsMediaPlayer" /v PreventLibrarySharing /t REG_DWORD /d 1 /f

  REM   Turn off feature advertisement balloon notifications > Enabled
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v NoBalloonFeatureAdvertisements /t REG_DWORD /d 1 /f

  REM   Turn off handwriting personalization data sharing > Enabled
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v PreventHandwritingDataSharing /t REG_DWORD /d 1 /f
  reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v PreventHandwritingDataSharing /t REG_DWORD /d 1 /f

  REM   Turn off Help Experience Improvement Program > Enabled
  reg add "HKCU\SOFTWARE\Policies\Microsoft\Assistance\Client\1.0" /v NoImplicitFeedback /t REG_DWORD /d 1 /f

  REM   Turn off Windows Location Provider > Enabled
  IF DEFINED AGGRESSIVEOPTIMIZATION reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\LocationAndSensors" /v DisableWindowsLocationProvider /t REG_DWORD /d 1 /f
)

REM Services
REM   Xbox related
IF DEFINED AGGRESSIVEOPTIMIZATION sc stop XboxGipSvc
IF DEFINED AGGRESSIVEOPTIMIZATION sc config XboxGipSvc start= disabled
IF DEFINED AGGRESSIVEOPTIMIZATION sc stop xbgm
IF DEFINED AGGRESSIVEOPTIMIZATION sc config xbgm start= disabled
IF DEFINED AGGRESSIVEOPTIMIZATION sc stop XblAuthManager
IF DEFINED AGGRESSIVEOPTIMIZATION sc config XblAuthManager start= disabled
IF DEFINED AGGRESSIVEOPTIMIZATION sc stop XblGameSave
IF DEFINED AGGRESSIVEOPTIMIZATION sc config XblGameSave start= disabled
IF DEFINED AGGRESSIVEOPTIMIZATION sc stop XboxNetApiSvc
IF DEFINED AGGRESSIVEOPTIMIZATION sc config XboxNetApiSvc start= disabled

REM   Connected User Experiences and Telemetry > Disabled
sc stop DiagTrack
sc config DiagTrack start= disabled
sc stop dmwappushservice
sc config dmwappushservice start= disabled

REM   Windows Media Player Network Sharing Service > Disabled.
sc stop WMPNetworkSvc
sc config WMPNetworkSvc start= disabled

REM Scheduled tasks
REM   Telemetry and feedback related
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /Disable
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /Disable
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /Disable
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /Disable
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /Disable
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClient" /Disable
schtasks /Change /TN "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload" /Disable

REM   Office 15 Subscription Heartbeat > Disabled
schtasks /Change /TN "Microsoft\Office\Office 15 Subscription Heartbeat" /Disable

REM   XblGameSaveTask > Disabled
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /Disable

REM Registry
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v CEIPEnable /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\IE" /v SqmLoggerRunning /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v CEIPEnable /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Reliability" /v SqmLoggerRunning /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v CEIPEnable /t REG_DWORD /d 0 /f
reg add "HKLM\SOFTWARE\Microsoft\SQMClient\Windows" /v DisableOptinExperience /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Diagnostics\DiagTrack" /v DiagTrackAuthorization /t REG_DWORD /d 0 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags" /v UpgradeEligible /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Appraiser" /v HaveUploadedForTarget /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v DontRetryOnError /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v IsCensusDisabled /t REG_DWORD /d 1 /f
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\ClientTelemetry" /v TaskEnableRun /t REG_DWORD /d 1 /f
reg delete "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\TelemetryController" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\AutoLogger-Diagtrack-Listener" /v Start /t REG_DWORD /d 0 /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\Diagtrack-Listener" /f
reg delete "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /f
reg add "HKLM\SYSTEM\CurrentControlSet\Control\WMI\AutoLogger\SQMLogger" /v Start /t REG_DWORD /d 0 /f

ECHO Done.
PAUSE
GOTO :EOF

:help
ECHO Usage: windows-10-privacy-and-control-enhance.bat [options]
ECHO.
ECHO Options:
ECHO   -h, -Help               Display this help message.
ECHO   -EditGroupPolicies      Edit Group Policies (via the registry) in addition to
ECHO                           just toggling settings. This prevents the user from
ECHO                           being able to toggle some settings through the UI.
ECHO                           Precaution should be taken when using this option in
ECHO                           conjunction with higher optimisation levels.
ECHO                           Some tweaks are only available by editing Group
ECHO                           Policies while some settings are not controlled by
ECHO                           any Group Policy.
ECHO   -AggressiveOptimization By default, the standard optimisation only changes
ECHO                           settings that should not impact any functionality.
ECHO                           For example: turning off telemetry data collection,
ECHO                           disabling advertising elements, and tightening
ECHO                           privacy controls. Aggressive optimisation goes
ECHO                           further by turning off privacy intrusive, yet
ECHO                           unlikely to be useful, features.
