*** Settings ***
Library    ../libraries/__init__.py

*** Test Cases ***
Voice Command - Activate Voice Assistant
    [Documentation]    Verify voice assistant activates when triggered
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x200    51 01
    Verify Voice Active    True

Voice Command - Deactivate Voice Assistant
    [Documentation]    Verify voice assistant deactivates
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x200    51 01
    Verify Voice Active    True
    Send Can Message    0x200    51 00
    Verify Voice Active    False

Voice Command - Toggle Sequence
    [Documentation]    Test multiple voice ON/OFF cycles
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x200    51 01
    Verify Voice Active    True
    Send Can Message    0x200    51 00
    Verify Voice Active    False
    Send Can Message    0x200    51 01
    Verify Voice Active    True
    Send Can Message    0x200    51 00
    Verify Voice Active    False

Voice Command - Verify CAN Message Content
    [Documentation]    Verify correct CAN message data is sent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x200    51 01
    Can Message Should Contain    0x200    51
    Can Message Should Contain    0x200    01

Voice Command - State Consistency
    [Documentation]    Verify voice state remains consistent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    ${initial_state}=    Get Current Vehicle State
    Should Be Equal    ${initial_state['voice_active']}    ${False}
    Send Can Message    0x200    51 01
    ${new_state}=    Get Current Vehicle State
    Should Be Equal    ${new_state['voice_active']}    ${True}
