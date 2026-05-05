*** Settings ***
# Common setup/teardown and utilities for all test suites
Library    ../libraries/__init__.py

*** Variables ***
${CAN_BUS_CONNECT_TIMEOUT}    5 seconds
${TEST_REPORT_DIR}    ./test-results

*** Keywords ***
Setup Test Environment
    [Documentation]    Standard setup for each test case
    Connect To Can Bus
    Clear Can History

Teardown Test Environment
    [Documentation]    Standard teardown for each test case
    Log Can State
    Disconnect From Can Bus

Setup Test Suite
    [Documentation]    Setup run once before test suite starts
    Connect To Can Bus

Teardown Test Suite
    [Documentation]    Cleanup run once after all tests complete
    Disconnect From Can Bus
    Log Can State

Dump All CAN Messages
    [Documentation]    Print all CAN messages to log
    ${messages}=    Get Current Vehicle State
    [Return]    ${messages}

Verify All States Initial
    [Documentation]    Verify all vehicle states are at default values
    ${state}=    Get Current Vehicle State
    Should Be Equal    ${state['media_state']}         stopped
    Should Be Equal    ${state['voice_active']}        ${False}
    Should Be Equal    ${state['bluetooth_connected']}    ${False}
    Should Be Equal    ${state['navigation_active']}    ${False}

Reset To Known State
    [Documentation]    Reset CAN simulator to known initial state
    Clear Can History
    Disconnect From Can Bus
    Connect To Can Bus
    Verify All States Initial
