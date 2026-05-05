*** Settings ***
Library    ../libraries/__init__.py

*** Test Cases ***
Integration - Voice Navigation While Playing Music
    [Documentation]    Test voice command during active media playback
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x200    51 01
    Verify Voice Active    True
    Send Can Message    0x400    71 01
    Verify Navigation Active    True
    Verify Media State    playing
    Send Can Message    0x200    51 00
    Verify Voice Active    False
    ${final_state}=    Get Current Vehicle State
    Should Be Equal    ${final_state['media_state']}         playing
    Should Be Equal    ${final_state['voice_active']}        ${False}
    Should Be Equal    ${final_state['navigation_active']}    ${True}

Integration - Phone Call Interrupts Media
    [Documentation]    Test incoming call pauses media playback
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x100    41 02
    Verify Media State    paused
    Send Can Message    0x100    41 01
    Verify Media State    playing

Integration - Android Auto Full Startup Sequence
    [Documentation]    Simulate complete Android Auto startup
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x100    41 01
    Verify Media State    playing
    ${state}=    Get Current Vehicle State
    Should Be Equal    ${state['bluetooth_connected']}    ${True}
    Should Be Equal    ${state['media_state']}          playing

Integration - Navigation to Destination with Music
    [Documentation]    Test full navigation session with media
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x200    51 01
    Verify Voice Active    True
    # Note: Voice remains active during navigation in this simulation
    Send Can Message    0x400    71 01
    Verify Navigation Active    True
    Verify Voice Active    True
    Verify Media State    playing
    # Deactivate voice explicitly
    Send Can Message    0x200    51 00
    Verify Voice Active    False
    Send Can Message    0x400    71 00
    Verify Navigation Active    False
    Verify Media State    playing

Integration - Disconnect and Reconnect Cycle
    [Documentation]    Test full BT disconnect/reconnect cycle
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x300    61 00
    Verify Bluetooth Connected    False
    Verify Media State    playing
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x100    41 01
    Verify Media State    playing
