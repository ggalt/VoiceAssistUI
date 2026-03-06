# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles/appVoiceAssistUI_autogen.dir/AutogenUsed.txt"
  "CMakeFiles/appVoiceAssistUI_autogen.dir/ParseCache.txt"
  "appVoiceAssistUI_autogen"
  )
endif()
