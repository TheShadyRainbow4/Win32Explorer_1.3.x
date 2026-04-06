#define _STLSOFT_FORCE_MSVC_1600_QUALITY 1

// stdafx.h : include file for standard system include files,
// or project specific include files that are used frequently, but
// are changed infrequently
//

#pragma once

#include "targetver.h"

#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers

#include <windows.h>
#include <DbgHelp.h>
#include <tchar.h>
#include <commctrl.h>
#include <sstream>
#include <cassert>
#include <uxtheme.h>
#include <dwmapi.h>
#include <dbt.h>
#include <psapi.h>
#include <commoncontrols.h>
