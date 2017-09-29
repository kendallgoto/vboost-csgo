GetModuleFileNameEx( p_pid ) ; by shimanov -  www.autohotkey.com/forum/viewtopic.php?t=9000
{
   if A_OSVersion in WIN_95,WIN_98,WIN_ME
   {
      MsgBox, This Windows version (%A_OSVersion%) is not supported.
      return
   }

   h_process := DllCall( "OpenProcess", "uint", 0x10|0x400, "int", false, "uint", p_pid )
   if ( ErrorLevel or h_process = 0 )
      return

   name_size = 255
   VarSetCapacity( name, name_size )

   result := DllCall( "psapi.dll\GetModuleFileNameEx" [color=#FF0000]( A_IsUnicode ? "W" : "A" )[/color]
                 , "uint", h_process, "uint", 0, "str", name, "uint", name_size )

   DllCall( "CloseHandle", h_process )

   return, name
}