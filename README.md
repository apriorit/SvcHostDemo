# SvcHostDemo
Demo service that runs in svchost.exe

# Introduction
`svchost.exe` is designed to save system resources by combining several services into one process. So a service is written as a `dll` and not as an `exe` file. Note that Microsoft do not recommend to host 3rd-party services into `svchost.exe` and its interface is undocumented (thus it may be changed in future). This project is just a demo for academic and research purpose.

# Registration info
## Group registration
Services are combined into groups. Each group has one instance of `svchost.exe` process. Groups are registered in the registry:
```
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SvcHost]
```
|Name|Type|Description|
|--|--|--|
| `<group>` | REG_MULTI_SZ | List of services |

Group name is passed as a command-line parameter:
```
%SystemRoot%\System32\svchost.exe -k <group>
```

## Service registration
A service has to be registered with the following type and image:
```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\<service>]
```
|Name|Type|Value|
|--|--|--|
| ImagePath | REG_EXPAND_SZ | `%SystemRoot%\System32\svchost.exe -k <group>` |
| Type | REG_DWORD | 0x20 (shared) |

and specify its dll in the parameters key:
```
[HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\<service>\Parameters]
```
|Name|Type|Value|
|--|--|--|
| ServiceDll | REG_EXPAND_SZ | `<path to dll>` |

## Dll entry point
A dll has to export the following function:
```cpp
VOID WINAPI ServiceMain(DWORD dwArgc, LPCWSTR* lpszArgv)
```
This function is very similar to the `ServiceMain` in a standard service.

# How to run the sample
- build with cmake
```
cmake -Hsrc -Bbuild64 -G"Visual Studio 14 2015 Win64"
cmake --build build64 --config RelWithDebInfo -- /m /v:m
```
- copy `SvcHostDemo.dll` to `system32`
- run `install` from `src/Scripts`
- run `start` from `src/Scripts`
- run `stop` from `src/Scripts`
- run `uninstall` from `src/Scripts`
- delete `SvcHostDemo.dll` from `system32`
