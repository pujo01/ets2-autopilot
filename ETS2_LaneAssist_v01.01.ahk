Numpad1::Reload                             ; Numpad 1 to reload the entire script

F12::                                       ; F12 to toggle the lane assist
    global Steering_Active
    Steering_Active := 1-Steering_Active
    if(Steering_Active) 
        GuiControl, Enable ,MySlider
    Else
        GuiControl, Disable ,MySlider
return

+F12::                                      ; Shift + F12 to start the Lane Assist
    ;setting up the overlay:                -----------------------------------------------------------------
    Gui, +AlwaysOnTop -Caption +LastFound 
    Gui, Font, s20 , Arial
    Gui, Add, Slider, vMySlider Range-11-11 TickInterval11 , 0
    Gui, Color, 111111
    ;WinSet, TransColor, 111111             ; uncomment this line to make the overlay background transparent
    Gui, Show, w350 h45 xCenter y-15 NA, Lane

    global Steering_Active
    Steering_Active := 0
    GuiControl, Disable ,MySlider

    ; the actual lane assist:               -----------------------------------------------------------------
    multip := 7.5                           ; multiplier of how long the arrow keys shall be pressed (possibly depends on your game settings)
    height := 837                           ; pixel height of the line to be read
    width2 := 25                            ; Loop amount, roughly equivalent to scan width

    Loop{
        ; read pixels
        Loop, %width2%
        {
            even := Mod(A_Index, 2)
            if(even == 0)
            {
                PixelGetColor, Mycolor, 1674 + (A_Index/2), height, RGB ;1674
                result := -12 + (A_Index/2)         ;steer left
            } Else
            {
                PixelGetColor, Mycolor, 1724 - ((A_Index-1)/2), height, RGB ;1724
                result := 12 - ((A_Index-1)/2)      ;steer right
            }
        } Until (Mycolor < 0xD20000 and Mycolor > 0xC90000)
        ; update the overlay
        GuiControl,,MySlider,%result%
        ; steer
        if(Steering_Active == 1)
        {
            if(result > 0)
            {
                Send {Right down}
                Sleep (result)*multip
                Send {Right up}
            }
                if(result < 0)
            {
                Send {Left down}
                Sleep (-result)*multip
                Send {Left up}
            }
        }
    }       ; warning: this is an infinite Loop, reload or exit the script to stop.
return