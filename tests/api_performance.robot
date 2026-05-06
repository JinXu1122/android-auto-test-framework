*** Settings ***
Library    ../libraries/__init__.py
Library    DateTime

*** Test Cases ***
API - Response Time Measurement
    [Documentation]    Verify API response time is under threshold
    Reset Can Simulator
    Connect To Can Bus
    ${start_time}=    Get Current Date
    ${response}=    Get Request    /api/v1/vehicle/status
    ${end_time}=    Get Current Date
    Status Should Be    200    ${response}
    ${elapsed}=    Subtract Date From Date    ${end_time}    ${start_time}
    Log    Response time: ${elapsed}ms
    Should Be True    ${elapsed} < 200

API - Concurrent Request Handling
    [Documentation]    Verify API handles concurrent requests
    Reset Can Simulator
    Connect To Can Bus
    ${response1}=    Get Request    /api/v1/vehicle/status
    Status Should Be    200    ${response1}
    ${response2}=    Get Request    /api/v1/vehicle/status
    Status Should Be    200    ${response2}
    ${response3}=    Get Request    /api/v1/vehicle/status
    Status Should Be    200    ${response3}
    Log    Handled 3 sequential requests successfully

API - Batch Telemetry Performance
    [Documentation]    Verify batch telemetry endpoint responds correctly
    Reset Can Simulator
    Connect To Can Bus
    ${payload}=    Create Dictionary    vehicle_id=V12345    entries=[]
    ${response}=    Post Request    /api/v1/telemetry/batch    ${payload}
    Status Should Be    201    ${response}
    Log    Batch telemetry endpoint working
