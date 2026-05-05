*** Settings ***
Library    ../libraries/__init__.py

*** Test Cases ***
Bluetooth - Connect Device
    [Documentation]    Verify Bluetooth connects successfully
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True

Bluetooth - Disconnect Device
    [Documentation]    Verify Bluetooth disconnects successfully
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x300    61 00
    Verify Bluetooth Connected    False

Bluetooth - Reconnection Sequence
    [Documentation]    Test multiple connect/disconnect cycles
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    Send Can Message    0x300    61 00
    Verify Bluetooth Connected    False
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True

Bluetooth - Verify CAN Message Data
    [Documentation]    Verify correct CAN message data is sent
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    Send Can Message    0x300    61 01
    Can Message Should Contain    0x300    61
    Can Message Should Contain    0x300    01

Bluetooth - State Verification
    [Documentation]    Verify BT state via Get Current Vehicle State
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    ${state}=    Get Current Vehicle State
    Should Be Equal    ${state['bluetooth_connected']}    ${False}
    Send Can Message    0x300    61 01
    ${state}=    Get Current Vehicle State
    Should Be Equal    ${state['bluetooth_connected']}    ${True}

Bluetooth - Independent of Other States
    [Documentation]    Verify BT state changes don't affect other features
    Reset Can Simulator
    Connect To Can Bus
    Clear Can History
    ${initial_state}=    Get Current Vehicle State
    Should Be Equal    ${initial_state['bluetooth_connected']}    ${False}
    Send Can Message    0x300    61 01
    ${new_state}=    Get Current Vehicle State
    Should Be Equal    ${new_state['bluetooth_connected']}    ${True}
    Should Be Equal    ${initial_state['media_state']}    ${new_state['media_state']}
    Should Be Equal    ${initial_state['voice_active']}    ${new_state['voice_active']}
    Should Be Equal    ${initial_state['navigation_active']}    ${new_state['navigation_active']}
