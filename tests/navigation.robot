*** Settings ***
Library    ../libraries/__init__.py

*** Test Cases ***
Navigation - Start Navigation
    [Documentation]    Verify navigation activates when started
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x400    71 01
    Verify Navigation Active    True

Navigation - Stop Navigation
    [Documentation]    Verify navigation deactivates when stopped
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x400    71 01
    Verify Navigation Active    True
    Send Can Message    0x400    71 00
    Verify Navigation Active    False

Navigation - Full Session Cycle
    [Documentation]    Test complete navigation session
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x400    71 01
    Verify Navigation Active    True
    Send Can Message    0x400    71 00
    Verify Navigation Active    False

Navigation - Verify CAN Message Content
    [Documentation]    Verify correct CAN message data is sent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x400    71 01
    Can Message Should Contain    0x400    71
    Can Message Should Contain    0x400    01

Navigation - State Verification
    [Documentation]    Verify navigation state via Get Current Vehicle State
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    ${state}=    Get Current Vehicle State
    Should Be Equal    ${state['navigation_active']}    ${False}
    Send Can Message    0x400    71 01
    ${state}=    Get Current Vehicle State
    Should Be Equal    ${state['navigation_active']}    ${True}
