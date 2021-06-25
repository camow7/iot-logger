; Script generated by the Inno Script Studio Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "Turbid Desktop App"
#define MyAppVersion "1.0"
#define MyAppPublisher "SAPHI Engineering"
#define MyAppURL "https://saphi.engineering/"
#define MyAppExeName "iot_logger.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{AE022CBE-5828-4AD9-AC01-34298851BA50}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={pf}\TurbidDesktopApp
DefaultGroupName={#MyAppName}
OutputDir=C:\Users\mrand\Downloads
OutputBaseFilename=Turbid Desktop App Installer
Compression=lzma
SolidCompression=yes
UsePreviousAppDir=False

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 0,6.1

[Files]
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\iot_logger.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\msvcp140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\vcruntime140_1.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\vcruntime140.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\mrand\Projects\iot-logger\build\windows\runner\Release\window_size_plugin.dll"; DestDir: "{app}"

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{commondesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Dirs]
Name: "{app}\data"

