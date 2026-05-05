*** Settings ***
Library    ../libraries/__init__.py

*** Test Cases ***
Media Playback - Play Command
    [Documentation]    Verify media plays when Play command is sent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Can Message Should Contain    0x100    41
    Log Can State

Media Playback - Pause Command
    [Documentation]    Verify media pauses when Pause command is sent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x100    41 02
    Verify Media State    paused

Media Playback - Stop Command
    [Documentation]    Verify media stops when Stop command is sent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x100    41 03
    Verify Media State    stopped

Media Playback - Next Track Command
    [Documentation]    Verify Next Track command is sent correctly
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 04
    Can Message Should Contain    0x100    41 04

Media Playback - Previous Track Command
    [Documentation]    Verify Previous Track command is sent correctly
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x100    41 05
    Can Message Should Contain    0x100    41 05

Media Playback - State Transition Sequence
    [Documentation]    Test complete playback state machine
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Verify Media State    stopped
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x100    41 02
    Verify Media State    paused
    Send Can Message    0x100    41 01
    Verify Media State    playing
    Send Can Message    0x100    41 03
    Verify Media State    stopped

Media Playback - Error Case Not Connected
    [Documentation]    Verify error when sending without CAN connection
    Reset Can Simulator
    Disconnect From Can Bus
    ${result}=    Run Keyword And Return Status
    ...    Send Can Message    0x100    41 01
    Should Not Be True    ${result}
