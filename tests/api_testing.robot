*** Settings ***
Library    ../libraries/__init__.py

*** Test Cases ***
API - Get Vehicle Status
    [Documentation]    Verify GET request returns vehicle status
    Reset Can Simulator
    Connect To Can Bus
    ${response}=    Get Request    /api/v1/vehicle/status
    Status Should Be    200    ${response}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['bluetooth_connected']}    ${False}
    Should Be Equal    ${body['media_state']}    stopped

API - Get Media State
    [Documentation]    Verify GET request returns current media state
    Reset Can Simulator
    Connect To Can Bus
    Send Can Message    0x100    41 01
    ${response}=    Get Request    /api/v1/media/state
    Status Should Be    200    ${response}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['playback_state']}    playing

API - Update Navigation Destination
    [Documentation]    Verify POST request sends navigation destination
    Reset Can Simulator
    Connect To Can Bus
    ${payload}=    Create Dictionary    destination=Home    latitude=45.4215    longitude=-75.6972
    ${response}=    Post Request    /api/v1/navigation/destination    ${payload}
    Status Should Be    200    ${response}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['status']}    confirmed

API - Telemetry Data Collection
    [Documentation]    Verify POST request collects telemetry data
    Reset Can Simulator
    Connect To Can Bus
    ${payload}=    Create Dictionary    vehicle_id=V12345    timestamp=2026-05-04T10:30:00Z    speed=65    fuel_level=0.75
    ${response}=    Post Request    /api/v1/telemetry/data    ${payload}
    Status Should Be    201    ${response}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['collected']}    ${True}

API - Bluetooth Connection State Change
    [Documentation]    Verify API reflects BT state changes
    Reset Can Simulator
    Connect To Can Bus
    ${response}=    Get Request    /api/v1/bluetooth/status
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['connected']}    ${False}
    Send Can Message    0x300    61 01
    Verify Bluetooth Connected    True
    ${response}=    Get Request    /api/v1/bluetooth/status
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['connected']}    ${True}

API - Media Control Commands
    [Documentation]    Verify API POST requests control media playback
    Reset Can Simulator
    Connect To Can Bus
    ${payload}=    Create Dictionary    command=play
    ${response}=    Post Request    /api/v1/media/control    ${payload}
    Status Should Be    200    ${response}
    Verify Media State    playing
    Can Message Should Contain    0x100    41
    ${payload}=    Create Dictionary    command=pause
    ${response}=    Post Request    /api/v1/media/control    ${payload}
    Status Should Be    200    ${response}
    Verify Media State    paused

API - Navigation Route Update
    [Documentation]    Verify API handles navigation route updates
    Reset Can Simulator
    Connect To Can Bus
    Send Can Message    0x400    71 01
    Verify Navigation Active    True
    ${response}=    Get Request    /api/v1/navigation/route
    Status Should Be    200    ${response}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body['active']}    ${True}

API - Batch Telemetry Upload
    [Documentation]    Verify POST can handle batch telemetry data
    Reset Can Simulator
    Connect To Can Bus
    ${entry1}=    Create Dictionary    timestamp=2026-05-04T10:00:00Z    speed=60
    ${payload}=    Create Dictionary    vehicle_id=V12345    entries=${entry1}
    ${response}=    Post Request    /api/v1/telemetry/batch    ${payload}
    Status Should Be    201    ${response}
    ${body}=    Set Variable    ${response.json()}
    ${count}=    Set Variable    ${body['collected_count']}
    Should Be Equal As Integers    ${count}    2

API - Error Handling - Invalid Endpoint
    [Documentation]    Verify API returns 404 for invalid endpoint
    Reset Can Simulator
    Connect To Can Bus
    ${response}=    Get Request    /api/v1/invalid/endpoint
    Status Should Be    404    ${response}

API - Error Handling - Invalid Payload
    [Documentation]    Verify API returns 400 for invalid payload
    Reset Can Simulator
    Connect To Can Bus
    ${payload}=    Create Dictionary    invalid_field=value
    ${response}=    Post Request    /api/v1/navigation/destination    ${payload}
    Status Should Be    400    ${response}
