#pragma once

// Including SDKDDKVer.h defines the highest available Windows platform.

// If you wish to build your application for a previous Windows platform, include WinSDKVer.h and
// set the _WIN32_WINNT macro to the platform you wish to support before including SDKDDKVer.h.

#ifndef WINVER
#define WINVER 0x0601
#endif

#ifndef _WIN32_WINNT		// Allow use of features specific to Windows 7 or later.                   
#define _WIN32_WINNT 0x0601	// Change this to the appropriate value to target other versions of Windows.
#endif

#ifndef _WIN32_IE
#define _WIN32_IE 0x0800
#endif

#include <SDKDDKVer.h>