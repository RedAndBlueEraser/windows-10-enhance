# Windows 10 Privacy and Control Enhance
A batch script to automatically configure for the highest privacy and control settings in Windows 10.

## Synopsis
This batch script minimises telemetry and data collection sent to Microsoft and third parties, removes advertising elements, and uninstalls useless apps.

By default, it avoids making changes that remove or disable features or functions, such as Cortana and shared experiences. The script can perform more aggressive optimisations with a command line switch. In this mode, it turns off and uninstalls unlikely to be useful and possibly privacy intrusive features and apps, including OneDrive, find my device and Xbox.

Another command line switch makes the script apply Group Policies in addition to changing settings. This locks down the setting, and possibly disabling the option in the Settings app.

## Usage
Run the batch file `windows-10-enhance-privacy-and-control.bat` with administrator privileges. This performs the default optimisation where changes are made that do not remove or disable features or functions.

The batch script can be run with following command line switches:

### Command line switches
- `-Help`: Displays help for running the batch script.
- `-EditGroupPolicies`: Edits the group policy (via the registry) in addition to toggling settings. This prevents the user from being able to toggle some settings through the UI. **Precaution should be taken when using this option in conjunction with higher optimisation levels.** _Some tweaks are only available by editing Group Policies while some settings are not controlled by any Group Policy._
- `-AggressiveOptimization` By default, the standard optimisation only changes settings that should not impact any functionality. For example: turning off telemetry data collection, disabling advertising elements, and tightening privacy controls. Aggressive optimisation goes further by turning off privacy intrusive, yet unlikely to be useful, features.

### Recommended usage
This is the recommended usage of the batch script on a freshly installed Windows 10. It performs aggressive optimisation but still allows the user to undo some of the settings changed by the optimisation. The changes in standard optimisation are generally safe and can be locked down by group policies.
```bat
windows-10-enhance-privacy-and-control.bat -AggressiveOptimization
windows-10-enhance-privacy-and-control.bat -EditGroupPolicies
```
---
On an already set up system, it is recommended to just perform standard optimisation to prevent already set user settings from being reset.
```bat
windows-10-enhance-privacy-and-control.bat
```
---
It is **not recommended** to lock down aggressive optimisation changes by applying group policies, but this can still be done.
```bat
windows-10-enhance-privacy-and-control.bat -AggressiveOptimization -EditGroupPolicies
```

## Author
RedAndBlueEraser
